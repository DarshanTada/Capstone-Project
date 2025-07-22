
import express from 'express';
import {
    uploadSubCategoryImage,
  createSubCategory,
  getAllSubCategories,
  getSubCategoryById,
  uploadUpdateSubCategoryImage,
  updateSubCategory,
  deleteSubCategory,
  getSubCategoriesByCategoryId,
  createMultipleSubCategories
} from '../subCategoryModule/subCategory.controller';

export const SubCategoryRoute = express.Router();

SubCategoryRoute.post('/createSubcategory',uploadSubCategoryImage, createSubCategory);
SubCategoryRoute.get('/getAll', getAllSubCategories);
SubCategoryRoute.get('/getSubcategory/:id', getSubCategoryById);
SubCategoryRoute.put('/updateSubcategory/:id',
  uploadUpdateSubCategoryImage,
  updateSubCategory);
SubCategoryRoute.delete('/deleteSubcategory/:id', deleteSubCategory);
SubCategoryRoute.get('/bycategory/:categoryId', getSubCategoriesByCategoryId);
SubCategoryRoute.post('/multipleSubCategory', createMultipleSubCategories);

export default SubCategoryRoute;
