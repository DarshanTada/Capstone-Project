import { Request, Response } from 'express';
import Category from './category.model';
import { upload } from '../utils/common/multer';

export const uploadCategoryImage = upload.fields([
  { name: 'image', maxCount: 1 },
]);

// Create Category
export const createCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const { name } = req.body;
    const files = req.files as Record<string, Express.Multer.File[]> | undefined;
    const imageFile = files?.['image']?.[0];

    if (!name) {
      res.status(400).json({
        success: false,
        message: "Category name is required.",
      });
      return;
    }

    console.log('req.body:', req.body);
    console.log('req.files:', req.files);

    let base64Image: string | undefined;

    if (imageFile && imageFile.buffer) {
      base64Image = imageFile.buffer.toString('base64');
    }

    const newCategory = new Category({
      name,
      ...(base64Image && { image: base64Image }),
    });

    await newCategory.save();

    res.status(200).json({ success: true, data: newCategory });
  } catch (error: any) {
    console.error('Create Category Error:', error);
    res.status(500).json({ success: false, message: `Create Category Error: ${error.message}` });
  }
};

// Read all Categories
export const getAllCategories = async (req: Request, res: Response): Promise<void> => {
  try {
    const categories = await Category.find();

    const formatted = categories.map((cat) => ({
      _id: cat._id,
      name: cat.name,
      image: cat.image?.toString('base64') || null,
    }));

    res.status(200).json({ success: true, data: formatted });
  } catch (error: any) {
    console.error('Get Category Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Delete Category
export const deleteCategory = async (req: Request, res: Response): Promise<void> => {
  try {
    const deleted = await Category.findByIdAndDelete(req.params.id);
    if (!deleted) {
      res.status(404).json({ success: false, message: 'Category not found' });
      return;
    }
    res.status(200).json({ success: true, message: 'Category deleted successfully' });
  } catch (err: any) {
    res.status(500).json({ success: false, message: err.message });
  }
};


