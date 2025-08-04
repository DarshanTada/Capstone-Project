import express from 'express';
import {
  uploadSubCategoryImage,
  createSubCategory,
  getAllSubCategories,
  getSubCategoriesByCategory,
  uploadUpdateSubCategoryImage,
  updateSubCategory,
  deleteSubCategory
} from './subCategory.controller';

export const SubCategoryRoute = express.Router();

SubCategoryRoute.post('/createSubCategory', uploadSubCategoryImage, createSubCategory);
SubCategoryRoute.get('/getAll', getAllSubCategories);
SubCategoryRoute.get('/getByCategory/:categoryId', getSubCategoriesByCategory);
SubCategoryRoute.put('/updateSubCategory/:id', uploadUpdateSubCategoryImage, updateSubCategory);
SubCategoryRoute.delete('/deleteSubCategory/:id', deleteSubCategory);

export default SubCategoryRoute;