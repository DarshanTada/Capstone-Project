
import express from 'express';
import {
  createCategory,
  getAllCategories,
  updateCategory,
  uploadCategoryImage,
  uploadUpdateCategoryImage
} from './category.controller';

export const CategoryRouter = express.Router();

// api/category/getCategory
CategoryRouter.post('/createCategory',uploadCategoryImage,  createCategory);
CategoryRouter.get('/getCategory', getAllCategories);
CategoryRouter.put('/updateCategory/:id',uploadUpdateCategoryImage, updateCategory);

export default CategoryRouter;