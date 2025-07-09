import { Request, Response } from 'express';
import SubCategory from '../subCategoryModule/subCategory.model';
import Category from '../categoryModule/category.model';
import { upload } from '../utils/common/multer';


export const uploadSubCategoryImage = upload.fields([
  { name: 'image', maxCount: 1 },
]);
// Create
export const createSubCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const { name } = req.body;
    const files = req.files as Record<string, Express.Multer.File[]> | undefined;
    const imageFile = files?.['image']?.[0];

    if (!name) {
      res.status(400).json({
        success: false,
        message: "Sub category name is required.",
      });
      return;
    }

    console.log('req.body:', req.body);
    console.log('req.files:', req.files);

    let base64Image: string | undefined;

    if (imageFile && imageFile.buffer) {
      base64Image = imageFile.buffer.toString('base64');
      // You can also prefix with data URI if needed:
      // base64Image = `data:${imageFile.mimetype};base64,${base64Image}`;
    }

    const newSubCategory = new SubCategory({
      name,
      ...(base64Image && { image: base64Image }),
    });

    await newSubCategory.save();

    res.status(201).json({ success: true, data: newSubCategory });
  } catch (error: any) {
    console.error('Create Sub category Error:', error);
    res.status(500).json({ success: false, message: `Create Sub category Error: ${error.message}` });
  }
};


// Read all
export const getAllSubCategories = async (req: Request, res: Response): Promise<void> => {
  try {
    const subCategories = await SubCategory.find();

    const formatted = subCategories.map((cat) => ({
      _id: cat._id,
      name: cat.name,
      image: cat.image?.toString('base64') || null,
    }));

    res.status(200).json({ success: true, data: formatted });
  } catch (error: any) {
    console.error('Get SubCategory Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Read by ID
export const getSubCategoryById = async (req: Request, res: Response): Promise<void> => {
  try {
    const subCategory = await SubCategory.findById(req.params.id);
    if (!subCategory) res.status(404).json({  success: false, message: 'SubCategory not found' });
    res.status(200).json({ success: true, data: subCategory });
  } catch (err) {
    console.error('Get SubCategory Error:', err);
    res.status(500).json({ success: false, message: err.message })
  }
};

//Update Category
export const uploadUpdateSubCategoryImage = upload.fields([{ name: 'image', maxCount: 1 }]);

export const updateSubCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { name } = req.body;

    const files = req.files as Record<string, Express.Multer.File[]> | undefined;
    const imageBuffer = files?.['image']?.[0]?.buffer;

    const updateData: any = {};
    if (name) updateData.name = name;
    if (imageBuffer) updateData.image = imageBuffer;

    console.log('Updating SubCategory with ID:', id);
    console.log('Update data:', updateData);

    const updatedSubCategory = await SubCategory.findByIdAndUpdate(id, updateData, {
      new: true,
    });

    if (!updatedSubCategory) {
      res.status(404).json({ success: false, message: 'Sub Category not found.' });
      return;
    }

    res.status(200).json({ success: true, data: updatedSubCategory });
  } catch (error: any) {
    console.error('Update SubCategory Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Delete
export const deleteSubCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const deleted = await SubCategory.findByIdAndDelete(req.params.id);
    if (!deleted) res.status(404).json({ success: false, message: 'SubCategory not found' });
    res.status(200).json({ success: true, message: 'SubCategory deleted successfully' });
  } catch (err) {
    res.status(500).json({success: false, message: err.message });
  }
};

// Get SubCategories by Category
export const getSubCategoriesByCategoryId = async (req: Request, res: Response): Promise<void> => {
  try {
    const category = await Category.findById(req.params.categoryId).populate('body_type.subcategory');
    if (!category) {
      res.status(404).json({ success: false, message: 'Category not found' });
      return;
    }

    const allSubcategories = category.body_type.flatMap(bt => bt.subcategory);
    res.status(200).json({ success: true, data: allSubcategories });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
export const createMultipleSubCategories = async (req: Request, res: Response): Promise<void> => {
  try {
    const names = req.query.names as string | undefined; // read from query
    const files = req.files as Record<string, Express.Multer.File[]> | undefined;
    const imageFile = files?.['image']?.[0];

    if (!names) {
      res.status(400).json({ success: false, message: "Comma separated 'names' query parameter is required." });
      return;
    }

    const namesArray = names.split(',').map(name => name.trim()).filter(Boolean);

    if (namesArray.length === 0) {
      res.status(400).json({ success: false, message: "No valid subcategory names provided." });
      return;
    }

    let base64Image: string | undefined;
    if (imageFile && imageFile.buffer) {
      base64Image = imageFile.buffer.toString('base64');
    }

    const subCategoriesToCreate = namesArray.map(name => ({
      name,
      ...(base64Image && { image: base64Image }),
    }));

    const createdSubCategories = await SubCategory.insertMany(subCategoriesToCreate);

    res.status(201).json({ success: true, data: createdSubCategories });
  } catch (error: any) {
    console.error('Create Multiple SubCategories Error:', error);
    res.status(500).json({ success: false, message: `Error: ${error.message}` });
  }
};
