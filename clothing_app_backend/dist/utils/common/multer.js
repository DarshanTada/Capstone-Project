"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.uploadBannerImage = exports.uploadCareImage = exports.uploadUpdateCategoryImage = exports.uploadCategoryImage = exports.upload = void 0;
const multer_1 = __importDefault(require("multer"));
const storage = multer_1.default.memoryStorage();
exports.upload = (0, multer_1.default)({ storage });
exports.uploadCategoryImage = exports.upload.single('image');
exports.uploadUpdateCategoryImage = exports.upload.single('image');
exports.uploadCareImage = (0, multer_1.default)({ storage: multer_1.default.memoryStorage() }).fields([
    { name: 'image', maxCount: 1 }
]);
exports.uploadBannerImage = (0, multer_1.default)({ storage: multer_1.default.memoryStorage() }).fields([
    { name: 'image', maxCount: 1 }
]);
