import { Request, Response } from 'express';
import Category from './category.model';
import multer from 'multer';

// Setup multer to use memory storage
const storage = multer.memoryStorage();
const upload = multer({ storage });

// Export middleware
export const uploadCategoryImage = upload.fields([
  { name: 'image', maxCount: 1 },
]);

// Create Category

export const createCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const { name } = req.body;

    const files = req.files as Record<string, Express.Multer.File[]> | undefined;
    const imageBuffer = files?.['image']?.[0]?.buffer;
// 
    if (!name || !imageBuffer) {
      res.status(400).json({ success: false, message: 'Name and image are required.' });
      return;
    }

    const newCategory = new Category({
      name,
      image: imageBuffer,
    });

    await newCategory.save();
    res.status(201).json({ success: true, data: newCategory });
  } catch (error: any) {
    console.error('Create Category Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get All Categories (with image as base64)
export const getAllCategories = async (_req: Request, res: Response): Promise<void> => {
  try {
    const categories = await Category.find();

    const formatted = categories.map((cat) => ({
      _id: cat._id,
      name: cat.name,
      image: cat.image?.toString('base64') || null,
    }));

    res.status(200).json({ success: true, data: formatted });
  } catch (error: any) {
    console.error('Get Categories Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

//Update Category
export const uploadUpdateCategoryImage = upload.fields([{ name: 'image', maxCount: 1 }]);

export const updateCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { name } = req.body;

    const files = req.files as Record<string, Express.Multer.File[]> | undefined;
    const imageBuffer = files?.['image']?.[0]?.buffer;

    if (!name && !imageBuffer) {
      res.status(400).json({ success: false, message: 'At least name or image is required to update.' });
      return;
    }

    const updateData: any = {};
    if (name) updateData.name = name;
    if (imageBuffer) updateData.image = imageBuffer;

    const updatedCategory = await Category.findByIdAndUpdate(id, updateData, {
      new: true,
    });

    if (!updatedCategory) {
      res.status(404).json({ success: false, message: 'Category not found.' });
      return;
    }

    res.status(200).json({ success: true, data: updatedCategory });
  } catch (error: any) {
    console.error('Update Category Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};