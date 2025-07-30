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
exports.deleteCategory = exports.getProductsByCategoryPost = exports.getAllCategories = exports.createCategory = exports.uploadCategoryImage = void 0;
const category_model_1 = __importDefault(require("./category.model"));
const product_model_1 = __importDefault(require("../productModule/product.model"));
const productVariant_model_1 = __importDefault(require("../productModule/productVariant.model"));
const productImage_model_1 = __importDefault(require("../productModule/productImage.model"));
const banner_model_1 = __importDefault(require("../bannerModule/banner.model"));
const multer_1 = require("../utils/common/multer");
exports.uploadCategoryImage = multer_1.upload.fields([
    { name: 'image', maxCount: 1 },
]);
const createCategory = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        const { name } = req.body;
        const files = req.files;
        const imageFile = (_a = files === null || files === void 0 ? void 0 : files['image']) === null || _a === void 0 ? void 0 : _a[0];
        if (!name) {
            res.status(400).json({
                success: false,
                message: "Category name is required.",
            });
            return;
        }
        console.log('req.body:', req.body);
        console.log('req.files:', req.files);
        let base64Image;
        if (imageFile && imageFile.buffer) {
            base64Image = imageFile.buffer.toString('base64');
        }
        const newCategory = new category_model_1.default(Object.assign({ name }, (base64Image && { image: base64Image })));
        yield newCategory.save();
        res.status(200).json({ success: true, data: newCategory });
    }
    catch (error) {
        console.error('Create Category Error:', error);
        res.status(500).json({ success: false, message: `Create Category Error: ${error.message}` });
    }
});
exports.createCategory = createCategory;
const getAllCategories = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const categories = yield category_model_1.default.find();
        const formatted = categories.map((cat) => {
            var _a;
            return ({
                _id: cat._id,
                name: cat.name,
                image: ((_a = cat.image) === null || _a === void 0 ? void 0 : _a.toString('base64')) || null,
            });
        });
        res.status(200).json({ success: true, data: formatted });
    }
    catch (error) {
        console.error('Get Category Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getAllCategories = getAllCategories;
const getProductsByCategoryPost = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { bodyType, gender } = req.body;
        let topMatchCondition = { productType: 'top' };
        let bottomMatchCondition = { productType: 'bottom' };
        if (bodyType) {
            topMatchCondition['subcategory.body_type'] = bodyType;
            bottomMatchCondition['subcategory.body_type'] = bodyType;
        }
        if (gender) {
            topMatchCondition['subcategory.gender'] = gender;
            topMatchCondition['gender'] = gender;
            bottomMatchCondition['subcategory.gender'] = gender;
            bottomMatchCondition['gender'] = gender;
        }
        const topProducts = yield product_model_1.default.aggregate([
            {
                $lookup: {
                    from: 'subcategories',
                    localField: 'subcategory_id',
                    foreignField: '_id',
                    as: 'subcategory'
                }
            },
            {
                $match: topMatchCondition
            },
            { $sample: { size: 6 } }
        ]);
        const bottomProducts = yield product_model_1.default.aggregate([
            {
                $lookup: {
                    from: 'subcategories',
                    localField: 'subcategory_id',
                    foreignField: '_id',
                    as: 'subcategory'
                }
            },
            {
                $match: bottomMatchCondition
            },
            { $sample: { size: 6 } }
        ]);
        const populatedTopProducts = yield product_model_1.default.populate(topProducts, []);
        const populatedBottomProducts = yield product_model_1.default.populate(bottomProducts, []);
        const topProductIds = populatedTopProducts.map(p => p._id);
        const topVariants = yield productVariant_model_1.default.find({ productObjectId: { $in: topProductIds } });
        const topImages = yield productImage_model_1.default.find({ productObjectId: { $in: topProductIds } });
        const bottomProductIds = populatedBottomProducts.map(p => p._id);
        const bottomVariants = yield productVariant_model_1.default.find({ productObjectId: { $in: bottomProductIds } });
        const bottomImages = yield productImage_model_1.default.find({ productObjectId: { $in: bottomProductIds } });
        const enrichedTopProducts = populatedTopProducts.map(product => {
            const productVariants = topVariants.filter(v => String(v.productObjectId) === String(product._id));
            const productImages = topImages.filter(img => String(img.productObjectId) === String(product._id));
            return Object.assign(Object.assign({}, product), { variants: productVariants, images: productImages });
        });
        const enrichedBottomProducts = populatedBottomProducts.map(product => {
            const productVariants = bottomVariants.filter(v => String(v.productObjectId) === String(product._id));
            const productImages = bottomImages.filter(img => String(img.productObjectId) === String(product._id));
            return Object.assign(Object.assign({}, product), { variants: productVariants, images: productImages });
        });
        const banners = yield banner_model_1.default.find({ is_active: true, type: "seasonal" });
        let categories;
        if (gender) {
            categories = yield category_model_1.default.aggregate([
                {
                    $lookup: {
                        from: 'subcategories',
                        localField: '_id',
                        foreignField: 'category_id',
                        as: 'subcategories'
                    }
                },
                {
                    $match: {
                        'subcategories.gender': gender
                    }
                },
                {
                    $project: {
                        _id: 1,
                        name: 1,
                        image: 1
                    }
                }
            ]);
        }
        else {
            categories = yield category_model_1.default.find();
        }
        const response = [
            {
                name: "Top",
                products: enrichedTopProducts
            },
            {
                name: "Bottom",
                products: enrichedBottomProducts
            },
            {
                banners: banners
            },
            {
                category: categories.map(category => {
                    var _a;
                    return ({
                        _id: category._id,
                        name: category.name,
                        image: ((_a = category.image) === null || _a === void 0 ? void 0 : _a.toString('base64')) || null
                    });
                })
            }
        ];
        res.status(200).json({
            success: true,
            data: response,
            filters: {
                bodyType: bodyType || 'all',
                gender: gender || 'all'
            }
        });
    }
    catch (error) {
        console.error('Get Products by Category Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getProductsByCategoryPost = getProductsByCategoryPost;
const deleteCategory = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const deleted = yield category_model_1.default.findByIdAndDelete(req.params.id);
        if (!deleted) {
            res.status(404).json({ success: false, message: 'Category not found' });
            return;
        }
        res.status(200).json({ success: true, message: 'Category deleted successfully' });
    }
    catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
});
exports.deleteCategory = deleteCategory;
