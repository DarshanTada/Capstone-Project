"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SubCategoryRoute = void 0;
const express_1 = __importDefault(require("express"));
const subCategory_controller_1 = require("./subCategory.controller");
exports.SubCategoryRoute = express_1.default.Router();
exports.SubCategoryRoute.post('/createSubCategory', subCategory_controller_1.uploadSubCategoryImage, subCategory_controller_1.createSubCategory);
exports.SubCategoryRoute.get('/getAll', subCategory_controller_1.getAllSubCategories);
exports.SubCategoryRoute.get('/getByCategory/:categoryId', subCategory_controller_1.getSubCategoriesByCategory);
exports.SubCategoryRoute.put('/updateSubCategory/:id', subCategory_controller_1.uploadUpdateSubCategoryImage, subCategory_controller_1.updateSubCategory);
exports.SubCategoryRoute.delete('/deleteSubCategory/:id', subCategory_controller_1.deleteSubCategory);
exports.default = exports.SubCategoryRoute;
