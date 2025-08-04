"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AddressRouter = void 0;
const express_1 = __importDefault(require("express"));
const multer_1 = require("../utils/common/multer");
const address_controller_1 = require("./address.controller");
exports.AddressRouter = express_1.default.Router();
exports.AddressRouter.post('/addAddress', multer_1.upload.none(), address_controller_1.addAddress);
exports.AddressRouter.post('/getAddressesByuserId', multer_1.upload.none(), address_controller_1.getAllAddressesByUserId);
exports.AddressRouter.post('/updateAddress', multer_1.upload.none(), address_controller_1.updateAddress);
exports.AddressRouter.post('/deleteAddress', multer_1.upload.none(), address_controller_1.deleteAddress);
exports.default = exports.AddressRouter;
