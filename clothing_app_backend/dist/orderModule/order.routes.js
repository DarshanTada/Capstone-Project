"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.OrderRouter = void 0;
const express_1 = __importDefault(require("express"));
const order_controller_1 = require("./order.controller");
const multer_1 = require("../utils/common/multer");
exports.OrderRouter = express_1.default.Router();
exports.OrderRouter.post('/createOrder', multer_1.upload.none(), order_controller_1.createOrder);
exports.OrderRouter.get('/getOrder/:orderId', order_controller_1.getOrderById);
exports.OrderRouter.post('/getAllOrders', multer_1.upload.none(), order_controller_1.getAllOrders);
exports.OrderRouter.post('/getUserOrders', multer_1.upload.none(), order_controller_1.getOrdersByUserId);
exports.OrderRouter.post('/updateProductStatus', multer_1.upload.none(), order_controller_1.updateProductStatus);
exports.OrderRouter.post('/cancelProduct', multer_1.upload.none(), order_controller_1.cancelProduct);
exports.default = exports.OrderRouter;
