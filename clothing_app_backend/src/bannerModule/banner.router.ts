import express from 'express';
import { uploadBannerImage } from '../utils/common/multer';
import { createBanner, getBanners, updateBanner, deleteBanner } from '../bannerModule/banner.controller';

export const BannerRouter = express.Router();

BannerRouter.post('/createBanners', uploadBannerImage, createBanner);
BannerRouter.get('/getBanners', getBanners);
BannerRouter.put('/updateBanner/:id',uploadBannerImage, updateBanner);
BannerRouter.delete('/deleteBanner/:id', deleteBanner);

export default BannerRouter;
