import express from 'express';
import {
  uploadCategoryImage,
  createCategory,
  getAllCategories,
  deleteCategory
} from './category.controller';

export const CategoryRoute = express.Router();

CategoryRoute.post('/createCategory', uploadCategoryImage, createCategory);
CategoryRoute.get('/getCategory', getAllCategories);
CategoryRoute.delete('/deleteCategory/:id', deleteCategory);

export default CategoryRoute;