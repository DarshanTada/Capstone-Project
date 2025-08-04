"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserRoutes = void 0;
const express_1 = __importDefault(require("express"));
exports.UserRoutes = express_1.default.Router();
const multer_1 = require("../utils/common/multer");
const user_controller_1 = require("../userModule/user.controller");
const user_controller_2 = require("../userModule/user.controller");
exports.UserRoutes.post('/sendBulkEmailToUsers', user_controller_2.sendBulkEmailToUsers);
exports.UserRoutes.post('/sendPromotionalEmail', user_controller_2.sendPromotionalEmailToUser);
exports.UserRoutes.post('/loginOrRegisterUser', user_controller_1.loginOrRegisterUser);
exports.UserRoutes.put('/updateUser', user_controller_1.updateUser);
exports.UserRoutes.post("/registerAdmin", user_controller_1.registerAdmin);
exports.UserRoutes.post('/loginAdmin', user_controller_1.loginAdmin);
exports.UserRoutes.post('/userById', multer_1.upload.none(), user_controller_1.getUserById);
exports.UserRoutes.post('/users', user_controller_1.getAllUsers);
