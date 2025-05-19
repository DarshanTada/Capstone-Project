"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthRoutes = void 0;
const express_1 = __importDefault(require("express"));
exports.AuthRoutes = express_1.default.Router();
const auth_controllers_1 = require("./auth.controllers");
exports.AuthRoutes.post("/sendOTPtoUser", auth_controllers_1.sendOTPtoUser);
exports.AuthRoutes.post("/verifyOTPofUser", auth_controllers_1.verifyOTPofUser);
exports.AuthRoutes.post("/resendOTPtoUser", auth_controllers_1.resendOTPtoUser);
