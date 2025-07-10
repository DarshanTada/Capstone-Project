import express from 'express';
import {
  createCategories,
  getAllCategories,
  updateCategory,
  deleteCategory
} from '../categoryModule/category.controller';
import { uploadCategoryImage, uploadUpdateCategoryImage } from '../utils/common/multer';

export const CategoryRouter = express.Router();

CategoryRouter.post('/createCategories', uploadCategoryImage, createCategories);
CategoryRouter.get('/getCategory', getAllCategories);
CategoryRouter.put("/updateCategory/:id", uploadUpdateCategoryImage, updateCategory);
CategoryRouter.delete('/deleteCategory/:id', deleteCategory);

export default CategoryRouter;