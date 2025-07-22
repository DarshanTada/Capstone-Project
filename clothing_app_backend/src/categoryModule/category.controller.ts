import { Request, Response } from 'express';
import Category from './category.model';
import mongoose from "mongoose";
import { upload } from '../utils/common/multer';
import Product, { GENDER, BODYTYPE } from "../productModule/product.model";


// POST /categories
export const createCategories = async (req: Request, res: Response): Promise<void> => {
  try {
    const { name, gender, bodyType, subcategory } = req.body;
    const imageBuffer = req.file?.buffer;

    // Validate inputs
    if (!name || typeof name !== "string") {
      res.status(400).json({ success: false, message: "Category name is required." });
      return;
    }

    if (!gender || !Object.values(GENDER).includes(gender)) {
      res.status(400).json({ success: false, message: `Invalid or missing gender. Allowed: ${Object.values(GENDER).join(", ")}` });
      return;
    }

    if (!bodyType || typeof bodyType !== "string") {
      res.status(400).json({ success: false, message: "bodyType (comma-separated string) is required." });
      return;
    }

    if (!subcategory || typeof subcategory !== "string") {
      res.status(400).json({ success: false, message: "subcategory (semicolon-separated groups) is required." });
      return;
    }

    // Convert image to base64 if exists
    let imageBase64: string | null = null;
    if (imageBuffer) {
      imageBase64 = imageBuffer.toString("base64");
    }

    // Parse bodyType and validate
    const bodyTypeArray = bodyType.split(",").map(bt => bt.trim());
    for (const bt of bodyTypeArray) {
      if (!Object.values(BODYTYPE).includes(bt)) {
        res.status(400).json({ success: false, message: `Invalid bodyType: ${bt}. Allowed: ${Object.values(BODYTYPE).join(", ")}` });
        return;
      }
    }

    // Parse subcategories: expected format -> "id1,id2;id3,id4"
    const subcategoryGroups = subcategory.split(";").map(group => group.trim());
    if (subcategoryGroups.length !== bodyTypeArray.length) {
      res.status(400).json({
        success: false,
        message: "Mismatch: Each bodyType must have a corresponding subcategory group (use semicolons to separate groups)."
      });
      return;
    }

    const bodyTypeObjects = [];

    for (let i = 0; i < bodyTypeArray.length; i++) {
      const bt = bodyTypeArray[i];
      const subIds = subcategoryGroups[i].split(",").map(id => id.trim());

      // Validate each subcategory ObjectId
      for (const subId of subIds) {
        if (!mongoose.Types.ObjectId.isValid(subId)) {
          res.status(400).json({ success: false, message: `Invalid subcategory ObjectId: ${subId}` });
          return;
        }
      }

      bodyTypeObjects.push({
        name: bt,
        subcategory: subIds
      });
    }

    // Create and save category
    const newCategory = new Category({
      name,
      image: imageBase64,
      gender,
      body_type: bodyTypeObjects
    });

    await newCategory.save();

    res.status(201).json({ success: true, data: newCategory });
  } catch (error: any) {
    console.error("Error creating category:", error);
    res.status(500).json({ success: false, message: error.message });
  }
};

export const getAllCategories = async (req: Request, res: Response) => {
  try {
    // Parse pagination query params with defaults
    const page = parseInt(req.query.page as string) || 1;
    const limit = parseInt(req.query.limit as string) || 10;
    const skip = (page - 1) * limit;

    // Get total count for pagination metadata
    const total = await Category.countDocuments();

    // Fetch paginated data
    const categories = await Category.find()
      .skip(skip)
      .limit(limit)
      .lean();

    res.status(200).json({
      success: true,
      count: categories.length,
      page,
      totalPages: Math.ceil(total / limit),
      totalItems: total,
      data: categories,
    });
  } catch (error: any) {
    console.error("Error fetching categories:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch categories.",
    });
  }
};


export const updateCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const categoryId = req.params.id;
    if (!mongoose.Types.ObjectId.isValid(categoryId)) {
      res.status(400).json({ success: false, message: "Invalid category ID" });
      return;
    }

    const { name, gender, bodyType, subcategory } = req.body;
    const imageBuffer = req.file?.buffer;

    // Validate fields if provided
    if (name && typeof name !== "string") {
      res.status(400).json({ success: false, message: "Category name must be a string." });
      return;
    }

    if (gender && !Object.values(GENDER).includes(gender)) {
      res.status(400).json({ success: false, message: `Invalid gender. Allowed: ${Object.values(GENDER).join(", ")}` });
      return;
    }

    if (bodyType && typeof bodyType !== "string") {
      res.status(400).json({ success: false, message: "bodyType must be a comma-separated string." });
      return;
    }

    if (subcategory && typeof subcategory !== "string") {
      res.status(400).json({ success: false, message: "subcategory must be a comma-separated string." });
      return;
    }

    // Find existing category
    const category = await Category.findById(categoryId);
    if (!category) {
      res.status(404).json({ success: false, message: "Category not found." });
      return;
    }

    // Prepare update fields
    if (name) category.name = name;
    if (gender) category.gender = gender;

    // Update image if new file uploaded
    if (imageBuffer) {
      category.image = imageBuffer;
    }

    // Update body_type if bodyType and subcategory provided
    if (bodyType && subcategory) {
      const bodyTypeArray = bodyType.split(",").map((bt: string) => bt.trim());

      for (const bt of bodyTypeArray) {
        if (!Object.values(BODYTYPE).includes(bt)) {
          res.status(400).json({ success: false, message: `Invalid bodyType value: ${bt}. Allowed: ${Object.values(BODYTYPE).join(", ")}` });
          return;
        }
      }

      let bodyTypeObjects: { name: string; subcategory: mongoose.Types.ObjectId[] }[] = [];

      if (subcategory.includes(";")) {
        const subcategoryGroups = subcategory.split(";").map((group: string) => group.trim());

        if (subcategoryGroups.length !== bodyTypeArray.length) {
          res.status(400).json({ success: false, message: "Number of bodyType values and subcategory groups must match." });
          return;
        }

        for (let i = 0; i < bodyTypeArray.length; i++) {
          const subcatIds = subcategoryGroups[i].split(",").map((id: string) => id.trim());

          for (const subId of subcatIds) {
            if (!mongoose.Types.ObjectId.isValid(subId)) {
              res.status(400).json({ success: false, message: `Invalid subcategory ObjectId: ${subId}` });
              return;
            }
          }

          bodyTypeObjects.push({
            name: bodyTypeArray[i],
            subcategory: subcatIds.map((id: string) => mongoose.Types.ObjectId.createFromHexString(id)),
          });
        }
      } else {
        const subcategoryArray = subcategory.split(",").map((id: string) => id.trim());

        for (const subId of subcategoryArray) {
          if (!mongoose.Types.ObjectId.isValid(subId)) {
            res.status(400).json({ success: false, message: `Invalid subcategory ObjectId: ${subId}` });
            return;
          }
        }

        if (subcategoryArray.length !== bodyTypeArray.length) {
          bodyTypeObjects = bodyTypeArray.map((bt: any) => ({
            name: bt,
            subcategory: [],
          }));
        } else {
          bodyTypeObjects = bodyTypeArray.map((bt: any, idx: string | number) => ({
            name: bt,
            subcategory: [mongoose.Types.ObjectId.createFromHexString(subcategoryArray[idx])],
          }));
        }
      }

      category.set('body_type', bodyTypeObjects);
    }

    await category.save();

    res.status(200).json({ success: true, data: category });
  } catch (error: any) {
    console.error("Error updating category:", error);
    res.status(500).json({ success: false, message: error.message });
  }
};

export const deleteCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const categoryId = req.params.id;

    if (!mongoose.Types.ObjectId.isValid(categoryId)) {
      res.status(400).json({ success: false, message: "Invalid category ID." });
      return;
    }

    const deletedCategory = await Category.findByIdAndDelete(categoryId);

    if (!deletedCategory) {
      res.status(404).json({ success: false, message: "Category not found." });
      return;
    }

    res.status(200).json({ success: true, message: "Category deleted successfully." });
  } catch (error: any) {
    console.error("Error deleting category:", error);
    res.status(500).json({ success: false, message: error.message });
  }
};