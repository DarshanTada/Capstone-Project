"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CartRouter = void 0;
const express_1 = __importDefault(require("express"));
const cart_controller_1 = require("./cart.controller");
const multer_1 = require("../utils/common/multer");
exports.CartRouter = express_1.default.Router();
exports.CartRouter.post('/addToCart', multer_1.upload.none(), cart_controller_1.addToCart);
exports.CartRouter.post('/updateQuantity', multer_1.upload.none(), cart_controller_1.updateCartQuantity);
exports.CartRouter.post('/removeFromCart', multer_1.upload.none(), cart_controller_1.removeFromCart);
exports.CartRouter.post('/getCart', multer_1.upload.none(), cart_controller_1.getCart);
exports.CartRouter.post('/clearCart', multer_1.upload.none(), cart_controller_1.clearCart);
exports.default = exports.CartRouter;
