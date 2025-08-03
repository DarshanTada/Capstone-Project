import express from 'express';
import {
  uploadCategoryImage,
  createCategory,
  updateCategory,
  getAllCategories,
  getProductsByCategoryPost,
  deleteCategory
} from './category.controller';
import { upload } from '../utils/common/multer';

export const CategoryRoute = express.Router();

CategoryRoute.post('/createCategory', uploadCategoryImage, createCategory);
CategoryRoute.put('/updateCategory/:id', uploadCategoryImage, updateCategory);
CategoryRoute.get('/getCategory', getAllCategories);
CategoryRoute.post('/getProductsByCategory', upload.none(), getProductsByCategoryPost);
CategoryRoute.delete('/deleteCategory/:id', deleteCategory);

export default CategoryRoute;