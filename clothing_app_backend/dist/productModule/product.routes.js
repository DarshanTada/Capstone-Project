"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProductRouter = void 0;
const express_1 = __importDefault(require("express"));
const product_controller_1 = require("../productModule/product.controller");
const multer_1 = require("../utils/common/multer");
exports.ProductRouter = express_1.default.Router();
exports.ProductRouter.post('/createProducts', multer_1.upload.any(), product_controller_1.createProduct);
exports.ProductRouter.put('/updateProduct/:id', multer_1.upload.any(), product_controller_1.updateProduct);
exports.ProductRouter.get('/getProduct', product_controller_1.getAllProducts);
exports.ProductRouter.get('/getTrendingProducts', product_controller_1.getTrendingProducts);
exports.ProductRouter.get('/getProductDetail/:productId', product_controller_1.getProductDetail);
exports.ProductRouter.delete('/deleteProduct/:productId', product_controller_1.deleteProduct);
exports.default = exports.ProductRouter;
