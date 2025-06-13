
import express from 'express';
import {
  createCategory,
  getAllCategories,
  updateCategory,
  uploadCategoryImage,
  uploadUpdateCategoryImage
} from './category.controller';

export const CategoryRouter = express.Router();

CategoryRouter.post('/createcategory',uploadCategoryImage,  createCategory);
CategoryRouter.get('/getcategory', getAllCategories);
CategoryRouter.put('/updateCategory/:id',uploadUpdateCategoryImage, updateCategory);

export default CategoryRouter;