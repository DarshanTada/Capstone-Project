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
exports.deleteSubCategory = exports.updateSubCategory = exports.uploadUpdateSubCategoryImage = exports.getSubCategoriesByCategory = exports.getAllSubCategories = exports.createSubCategory = exports.uploadSubCategoryImage = void 0;
const subCategory_model_1 = __importDefault(require("./subCategory.model"));
const multer_1 = require("../utils/common/multer");
exports.uploadSubCategoryImage = multer_1.upload.fields([
    { name: 'image', maxCount: 1 },
]);
const createSubCategory = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        const { name, gender, body_type, category } = req.body;
        const files = req.files;
        const imageFile = (_a = files === null || files === void 0 ? void 0 : files['image']) === null || _a === void 0 ? void 0 : _a[0];
        if (!name) {
            res.status(400).json({
                success: false,
                message: "SubCategory name is required.",
            });
            return;
        }
        if (!gender) {
            res.status(400).json({
                success: false,
                message: "Gender is required.",
            });
            return;
        }
        if (!body_type) {
            res.status(400).json({
                success: false,
                message: "Body type is required.",
            });
            return;
        }
        if (!category) {
            res.status(400).json({
                success: false,
                message: "Category ID is required.",
            });
            return;
        }
        console.log('req.body:', req.body);
        console.log('req.files:', req.files);
        let base64Image;
        if (imageFile && imageFile.buffer) {
            base64Image = imageFile.buffer.toString('base64');
        }
        const newSubCategory = new subCategory_model_1.default(Object.assign({ name,
            gender,
            body_type,
            category }, (base64Image && { image: base64Image })));
        yield newSubCategory.save();
        res.status(201).json({ success: true, data: newSubCategory });
    }
    catch (error) {
        console.error('Create SubCategory Error:', error);
        res.status(500).json({ success: false, message: `Create SubCategory Error: ${error.message}` });
    }
});
exports.createSubCategory = createSubCategory;
const getAllSubCategories = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const subCategories = yield subCategory_model_1.default.find().populate('category');
        const formatted = subCategories.map((subCat) => {
            var _a;
            return ({
                _id: subCat._id,
                name: subCat.name,
                gender: subCat.gender,
                body_type: subCat.body_type,
                category: subCat.category,
                image: ((_a = subCat.image) === null || _a === void 0 ? void 0 : _a.toString('base64')) || null,
                createdAt: subCat.createdAt,
                updatedAt: subCat.updatedAt,
            });
        });
        res.status(200).json({ success: true, data: formatted });
    }
    catch (error) {
        console.error('Get SubCategory Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getAllSubCategories = getAllSubCategories;
const getSubCategoriesByCategory = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { categoryId } = req.params;
        if (!categoryId) {
            res.status(400).json({
                success: false,
                message: "Category ID is required.",
            });
            return;
        }
        const subCategories = yield subCategory_model_1.default.find({ category: categoryId }).populate('category');
        const formatted = subCategories.map((subCat) => {
            var _a;
            return ({
                _id: subCat._id,
                name: subCat.name,
                gender: subCat.gender,
                body_type: subCat.body_type,
                category: subCat.category,
                image: ((_a = subCat.image) === null || _a === void 0 ? void 0 : _a.toString('base64')) || null,
                createdAt: subCat.createdAt,
                updatedAt: subCat.updatedAt,
            });
        });
        res.status(200).json({ success: true, data: formatted });
    }
    catch (error) {
        console.error('Get SubCategories by Category Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getSubCategoriesByCategory = getSubCategoriesByCategory;
exports.uploadUpdateSubCategoryImage = multer_1.upload.fields([{ name: 'image', maxCount: 1 }]);
const updateSubCategory = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a, _b;
    try {
        const { id } = req.params;
        const { name, gender, body_type, category } = req.body;
        const files = req.files;
        const imageBuffer = (_b = (_a = files === null || files === void 0 ? void 0 : files['image']) === null || _a === void 0 ? void 0 : _a[0]) === null || _b === void 0 ? void 0 : _b.buffer;
        const updateData = {};
        if (name)
            updateData.name = name;
        if (gender)
            updateData.gender = gender;
        if (body_type)
            updateData.body_type = body_type;
        if (category)
            updateData.category = category;
        if (imageBuffer)
            updateData.image = imageBuffer;
        console.log('Updating SubCategory with ID:', id);
        console.log('Update data:', updateData);
        const updatedSubCategory = yield subCategory_model_1.default.findByIdAndUpdate(id, updateData, {
            new: true,
        }).populate('category');
        if (!updatedSubCategory) {
            res.status(404).json({ success: false, message: 'SubCategory not found.' });
            return;
        }
        res.status(200).json({ success: true, data: updatedSubCategory });
    }
    catch (error) {
        console.error('Update SubCategory Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.updateSubCategory = updateSubCategory;
const deleteSubCategory = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const deleted = yield subCategory_model_1.default.findByIdAndDelete(req.params.id);
        if (!deleted) {
            res.status(404).json({ success: false, message: 'SubCategory not found' });
            return;
        }
        res.status(200).json({ success: true, message: 'SubCategory deleted successfully' });
    }
    catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});
exports.deleteSubCategory = deleteSubCategory;
