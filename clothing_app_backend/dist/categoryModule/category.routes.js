"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CategoryRoute = void 0;
const express_1 = __importDefault(require("express"));
const category_controller_1 = require("./category.controller");
const multer_1 = require("../utils/common/multer");
exports.CategoryRoute = express_1.default.Router();
exports.CategoryRoute.post('/createCategory', category_controller_1.uploadCategoryImage, category_controller_1.createCategory);
exports.CategoryRoute.get('/getCategory', category_controller_1.getAllCategories);
exports.CategoryRoute.post('/getProductsByCategory', multer_1.upload.none(), category_controller_1.getProductsByCategoryPost);
exports.CategoryRoute.delete('/deleteCategory/:id', category_controller_1.deleteCategory);
exports.default = exports.CategoryRoute;
