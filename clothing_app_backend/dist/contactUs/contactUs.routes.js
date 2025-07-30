"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ContactUsRouter = void 0;
const express_1 = __importDefault(require("express"));
const contactUs_controller_1 = require("./contactUs.controller");
const contactUs_controller_2 = require("./contactUs.controller");
const multer_1 = require("../utils/common/multer");
exports.ContactUsRouter = express_1.default.Router();
exports.ContactUsRouter.post('/sendInquiry', multer_1.upload.none(), contactUs_controller_1.sendInquiry);
exports.ContactUsRouter.get('/getInquiries', contactUs_controller_1.getInquiries);
exports.ContactUsRouter.delete('/deleteInquiry/:id', contactUs_controller_1.deleteInquiry);
exports.ContactUsRouter.post('/replyInquiry/:id', multer_1.upload.none(), contactUs_controller_2.replyInquiry);
exports.default = exports.ContactUsRouter;
