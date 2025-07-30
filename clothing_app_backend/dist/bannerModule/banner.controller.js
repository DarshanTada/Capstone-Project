"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteBanner = exports.updateBanner = exports.getBanners = exports.createBanner = void 0;
const banner_model_1 = __importDefault(require("../bannerModule/banner.model"));
const createBanner = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        const { title, description, type, redirect_url, priority, is_active } = req.body;
        const files = req.files;
        const imageFile = (_a = files === null || files === void 0 ? void 0 : files['image']) === null || _a === void 0 ? void 0 : _a[0];
        if (!title || !type || !imageFile) {
            res.status(400).json({
                success: false,
                message: 'title, type, and image are required.'
            });
            return;
        }
        const imageBase64 = `data:${imageFile.mimetype};base64,${imageFile.buffer.toString('base64')}`;
        const banner = new banner_model_1.default({
            title,
            description,
            type,
            redirect_url,
            priority: priority !== null && priority !== void 0 ? priority : 0,
            is_active: is_active !== null && is_active !== void 0 ? is_active : true,
            image: imageBase64
        });
        yield banner.save();
        res.status(201).json({
            success: true,
            message: 'Banner created successfully',
            data: banner
        });
    }
    catch (error) {
        console.error('Error creating banner:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.createBanner = createBanner;
const getBanners = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { type, is_active } = req.query;
        const filter = {};
        if (type)
            filter.type = type;
        if (is_active !== undefined)
            filter.is_active = is_active === 'true';
        const banners = yield banner_model_1.default.find(filter).sort({ priority: -1, created_at: -1 });
        res.status(200).json({
            success: true,
            message: 'Banners fetched successfully',
            data: banners
        });
    }
    catch (error) {
        console.error('Error fetching banners:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getBanners = getBanners;
const updateBanner = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        const { id } = req.params;
        const { title, description, type, redirect_url, priority, is_active } = req.body;
        const files = req.files;
        const imageFile = (_a = files === null || files === void 0 ? void 0 : files['image']) === null || _a === void 0 ? void 0 : _a[0];
        const updateData = {};
        if (title !== undefined)
            updateData.title = title;
        if (description !== undefined)
            updateData.description = description;
        if (type !== undefined)
            updateData.type = type;
        if (redirect_url !== undefined)
            updateData.redirect_url = redirect_url;
        if (priority !== undefined)
            updateData.priority = priority;
        if (is_active !== undefined)
            updateData.is_active = is_active === 'true' || is_active === true;
        if (imageFile) {
            const imageBase64 = `data:${imageFile.mimetype};base64,${imageFile.buffer.toString('base64')}`;
            updateData.image = imageBase64;
        }
        updateData.updated_at = new Date();
        const updatedBanner = yield banner_model_1.default.findByIdAndUpdate(id, updateData, {
            new: true,
            runValidators: true
        });
        if (!updatedBanner) {
            res.status(404).json({ success: false, message: 'Banner not found' });
            return;
        }
        res.status(200).json({
            success: true,
            message: 'Banner updated successfully',
            data: updatedBanner
        });
    }
    catch (error) {
        console.error('Error updating banner:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.updateBanner = updateBanner;
const deleteBanner = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { id } = req.params;
        const deletedBanner = yield banner_model_1.default.findByIdAndDelete(id);
        if (!deletedBanner) {
            res.status(404).json({
                success: false,
                message: 'Banner not found',
            });
            return;
        }
        res.status(200).json({
            success: true,
            message: 'Banner deleted successfully',
            data: deletedBanner,
        });
    }
    catch (error) {
        console.error('Error deleting banner:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.deleteBanner = deleteBanner;
