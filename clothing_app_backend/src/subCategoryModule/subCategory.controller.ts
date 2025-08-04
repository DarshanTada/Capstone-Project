import { Request, Response } from 'express';
import SubCategory from './subCategory.model';
import { upload } from '../utils/common/multer';

export const uploadSubCategoryImage = upload.fields([
  { name: 'image', maxCount: 1 },
]);

// Create SubCategory
export const createSubCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const { name, gender, body_type, category } = req.body;
    const files = req.files as Record<string, Express.Multer.File[]> | undefined;
    const imageFile = files?.['image']?.[0];

    if (!name) {
      res.status(400).json({
        success: false,
        message: "SubCategory name is required.",
      });
      return;
    }

    if (!gender) {
      res.status(400).json({
        success: false,
        message: "Gender is required.",
      });
      return;
    }

    if (!body_type) {
      res.status(400).json({
        success: false,
        message: "Body type is required.",
      });
      return;
    }

    if (!category) {
      res.status(400).json({
        success: false,
        message: "Category ID is required.",
      });
      return;
    }

    console.log('req.body:', req.body);
    console.log('req.files:', req.files);

    let imageBase64: string | undefined;

    if (imageFile && imageFile.buffer) {
      imageBase64 = `data:${imageFile.mimetype};base64,${imageFile.buffer.toString('base64')}`;
    }

    const newSubCategory = new SubCategory({
      name,
      gender,
      body_type,
      category,
      ...(imageBase64 && { image: imageBase64 }),
    });

    await newSubCategory.save();

    res.status(200).json({ success: true, data: newSubCategory });
  } catch (error: any) {
    console.error('Create SubCategory Error:', error);
    res.status(500).json({ success: false, message: `Create SubCategory Error: ${error.message}` });
  }
};

// Read all SubCategories
export const getAllSubCategories = async (req: Request, res: Response): Promise<void> => {
  try {
    const subCategories = await SubCategory.find().populate('category');

    const formatted = subCategories.map((subCat) => ({
      _id: subCat._id,
      name: subCat.name,
      gender: subCat.gender,
      body_type: subCat.body_type,
      category: subCat.category,
      image: subCat.image || null,
      createdAt: subCat.createdAt,
      updatedAt: subCat.updatedAt,
    }));

    res.status(200).json({ success: true, data: formatted });
  } catch (error: any) {
    console.error('Get SubCategory Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get SubCategories by Category ID
export const getSubCategoriesByCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const { categoryId } = req.params;

    if (!categoryId) {
      res.status(400).json({
        success: false,
        message: "Category ID is required.",
      });
      return;
    }

    const subCategories = await SubCategory.find({ category: categoryId }).populate('category');

    const formatted = subCategories.map((subCat) => ({
      _id: subCat._id,
      name: subCat.name,
      gender: subCat.gender,
      body_type: subCat.body_type,
      category: subCat.category,
      image: subCat.image || null,
      createdAt: subCat.createdAt,
      updatedAt: subCat.updatedAt,
    }));

    res.status(200).json({ success: true, data: formatted });
  } catch (error: any) {
    console.error('Get SubCategories by Category Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Update SubCategory
export const uploadUpdateSubCategoryImage = upload.fields([{ name: 'image', maxCount: 1 }]);

export const updateSubCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { name, gender, body_type, category } = req.body;

    const files = req.files as Record<string, Express.Multer.File[]> | undefined;
    const imageFile = files?.['image']?.[0];

    const updateData: any = {};
    if (name) updateData.name = name;
    if (gender) updateData.gender = gender;
    if (body_type) updateData.body_type = body_type;
    if (category) updateData.category = category;
    
    if (imageFile) {
      const imageBase64 = `data:${imageFile.mimetype};base64,${imageFile.buffer.toString('base64')}`;
      updateData.image = imageBase64;
    }

    console.log('Updating SubCategory with ID:', id);
    console.log('Update data:', updateData);

    const updatedSubCategory = await SubCategory.findByIdAndUpdate(id, updateData, {
      new: true,
    }).populate('category');

    if (!updatedSubCategory) {
      res.status(404).json({ success: false, message: 'SubCategory not found.' });
      return;
    }

    res.status(200).json({ success: true, data: updatedSubCategory });
  } catch (error: any) {
    console.error('Update SubCategory Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Delete SubCategory
export const deleteSubCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const deleted = await SubCategory.findByIdAndDelete(req.params.id);
    if (!deleted) {
      res.status(404).json({ success: false, message: 'SubCategory not found' });
      return;
    }
    res.status(200).json({ success: true, message: 'SubCategory deleted successfully' });
  } catch (err: any) {
    res.status(500).json({ success: false, message: err.message });
  }
};