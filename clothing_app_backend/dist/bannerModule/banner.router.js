"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.BannerRouter = void 0;
const express_1 = __importDefault(require("express"));
const multer_1 = require("../utils/common/multer");
const banner_controller_1 = require("../bannerModule/banner.controller");
exports.BannerRouter = express_1.default.Router();
exports.BannerRouter.post('/createBanners', multer_1.uploadBannerImage, banner_controller_1.createBanner);
exports.BannerRouter.get('/getBanners', banner_controller_1.getBanners);
exports.BannerRouter.put('/updateBanner/:id', multer_1.uploadBannerImage, banner_controller_1.updateBanner);
exports.BannerRouter.delete('/deleteBanner/:id', banner_controller_1.deleteBanner);
exports.default = exports.BannerRouter;
