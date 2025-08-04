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
exports.getHomeData = void 0;
const banner_model_1 = __importDefault(require("../bannerModule/banner.model"));
const category_model_1 = __importDefault(require("../categoryModule/category.model"));
const subCategory_model_1 = __importDefault(require("../subCategoryModule/subCategory.model"));
const product_model_1 = __importDefault(require("../productModule/product.model"));
const productVariant_model_1 = __importDefault(require("../productModule/productVariant.model"));
const productImage_model_1 = __importDefault(require("../productModule/productImage.model"));
const attachVariantsAndImages = (products) => __awaiter(void 0, void 0, void 0, function* () {
    if (products.length === 0)
        return [];
    const productIds = products.map(p => p._id);
    const variants = yield productVariant_model_1.default.find({ productObjectId: { $in: productIds } });
    const variantIds = variants.map(v => v._id);
    const images = yield productImage_model_1.default.find({
        $or: [
            { productObjectId: { $in: productIds } },
            { variantObjectid: { $in: variantIds } }
        ]
    });
    return products.map(product => {
        const productVariants = variants.filter(v => v.productObjectId && v.productObjectId.toString() === product._id.toString());
        const productImages = images.filter(img => img.productObjectId && img.productObjectId.toString() === product._id.toString());
        const variantsWithImages = productVariants.map(variant => {
            const variantImages = images.filter(img => img.variantObjectid && img.variantObjectid.toString() === variant._id.toString());
            return Object.assign(Object.assign({}, variant.toObject()), { images: variantImages });
        });
        return Object.assign(Object.assign({}, product.toObject()), { variants: variantsWithImages, images: productImages });
    });
});
const getHomeData = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const page = Number(req.query.page) || 1;
        const limit = Number(req.query.limit) || 20;
        const category = req.query.category;
        const subcategory = req.query.subcategory;
        const skinTone = req.query.skinTone;
        const undertone = req.query.undertone;
        const height = req.query.height;
        const bodyType = req.query.bodyType;
        const banners = yield banner_model_1.default.find({});
        const seasonalBanners = yield banner_model_1.default.find({ type: 'seasonal' });
        const popularCategories = yield category_model_1.default.find({ is_popular: true });
        const chicSubcategories = yield subCategory_model_1.default.find({ is_curated: true });
        const discountedVariants = yield productVariant_model_1.default.find({ discount: { $gt: 0 } });
        const discountedProductIds = discountedVariants.map(v => v.productObjectId);
        const discountedProductsRaw = yield product_model_1.default.find({ _id: { $in: discountedProductIds } });
        const discountedProducts = yield attachVariantsAndImages(discountedProductsRaw);
        const newVariants = yield productVariant_model_1.default.find().sort({ createdAt: -1 }).limit(20);
        const newProductIds = newVariants.map(v => v.productObjectId);
        const newArrivalsRaw = yield product_model_1.default.find({ _id: { $in: newProductIds } });
        const newArrivals = yield attachVariantsAndImages(newArrivalsRaw);
        const bestSellerVariants = yield productVariant_model_1.default.find().sort({ sales: -1 }).limit(20);
        const bestSellerProductIds = bestSellerVariants.map(v => v.productObjectId);
        const bestSellersRaw = yield product_model_1.default.find({ _id: { $in: bestSellerProductIds } });
        const bestSellers = yield attachVariantsAndImages(bestSellersRaw);
        const clearanceVariants = yield productVariant_model_1.default.find({ is_clearance: true });
        const clearanceProductIds = clearanceVariants.map(v => v.productObjectId);
        const clearanceProductsRaw = yield product_model_1.default.find({ _id: { $in: clearanceProductIds } });
        const clearanceProducts = yield attachVariantsAndImages(clearanceProductsRaw);
        let productQuery = {};
        if (category)
            productQuery.categoryObjectId = category;
        if (subcategory)
            productQuery.subcategoryObjectId = subcategory;
        if (skinTone)
            productQuery.skin_tone = skinTone;
        if (undertone)
            productQuery.under_tone = undertone;
        if (height)
            productQuery.height = height;
        if (bodyType)
            productQuery.body_type = bodyType;
        const allProducts = yield product_model_1.default.find(productQuery)
            .skip((page - 1) * limit)
            .limit(limit);
        const totalCount = yield product_model_1.default.countDocuments(productQuery);
        const productIds = allProducts.map(p => p._id);
        const allVariants = yield productVariant_model_1.default.find({ productObjectId: { $in: productIds } });
        const productsWithVariants = allProducts.map(product => {
            const variants = allVariants.filter(v => v.productObjectId && v.productObjectId.toString() === product._id.toString());
            return Object.assign(Object.assign({}, product.toObject()), { variants });
        });
        res.status(200).json({
            success: true,
            data: {
                banners,
                seasonalBanners,
                popularCategories,
                chicSubcategories,
                discountedProducts,
                newArrivals,
                bestSellers,
                clearanceProducts,
                allProducts: productsWithVariants,
            },
            page,
            limit,
            totalCount,
        });
    }
    catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getHomeData = getHomeData;
