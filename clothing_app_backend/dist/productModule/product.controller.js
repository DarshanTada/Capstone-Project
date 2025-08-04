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
exports.getTrendingProducts = exports.getProductDetail = exports.deleteProduct = exports.getAllProducts = exports.updateProduct = exports.createProduct = void 0;
const product_model_1 = __importDefault(require("../productModule/product.model"));
const productVariant_model_1 = __importDefault(require("../productModule/productVariant.model"));
const productImage_model_1 = __importDefault(require("../productModule/productImage.model"));
const mongoose_1 = __importDefault(require("mongoose"));
const safeParse = (value) => {
    try {
        if (typeof value === "string") {
            const parsed = JSON.parse(value);
            return Array.isArray(parsed) ? parsed : [];
        }
        return Array.isArray(value) ? value : [];
    }
    catch (_a) {
        return [];
    }
};
const createProduct = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        const { name, description, fabric_type, category_id, subcategory_id, gender, bodyType, season_objectId, festival_objectId, care_instruction_objectId, productType, style, variants, } = req.body;
        const parsedStyle = safeParse(style);
        const parsedVariants = safeParse(variants);
        const parsedSeason = safeParse(season_objectId);
        const parsedFestival = safeParse(festival_objectId);
        const parsedCareInstructions = safeParse(care_instruction_objectId);
        const newProduct = yield product_model_1.default.create({
            name,
            description,
            fabric_type,
            category_id,
            subcategory_id,
            gender,
            bodyType,
            productType,
            style: parsedStyle,
            season_objectId: parsedSeason,
            festival_objectId: parsedFestival,
            care_instruction_objectId: parsedCareInstructions,
        });
        const filesArray = req.files || [];
        const files = {};
        filesArray.forEach(file => {
            if (!files[file.fieldname])
                files[file.fieldname] = [];
            files[file.fieldname].push(file);
        });
        for (let i = 0; i < parsedVariants.length; i++) {
            const variant = parsedVariants[i];
            const savedVariant = yield productVariant_model_1.default.create(Object.assign(Object.assign({}, variant), { productObjectId: newProduct._id }));
            let imageIndex = 0;
            while (true) {
                const key = `variant_${i}_image_${imageIndex}`;
                const file = (_a = files === null || files === void 0 ? void 0 : files[key]) === null || _a === void 0 ? void 0 : _a[0];
                if (!file)
                    break;
                const isPrimaryKey = `variant_${i}_image_${imageIndex}_is_primary`;
                const sortOrderKey = `variant_${i}_image_${imageIndex}_sort_order`;
                const isPrimary = req.body[isPrimaryKey] === 'true' || req.body[isPrimaryKey] === true;
                const sortOrder = parseInt(req.body[sortOrderKey]) || imageIndex + 1;
                const imageBase64 = `data:${file.mimetype};base64,${file.buffer.toString('base64')}`;
                yield productImage_model_1.default.create({
                    productObjectId: newProduct._id,
                    variantObjectid: savedVariant._id,
                    image: imageBase64,
                    is_primary: isPrimary,
                    sort_order: sortOrder
                });
                imageIndex++;
            }
        }
        const savedVariants = yield productVariant_model_1.default.find({ productObjectId: newProduct._id });
        const images = yield productImage_model_1.default.find({ productObjectId: newProduct._id });
        res.status(200).json({
            success: true,
            message: "Product created successfully",
            data: {
                product: newProduct,
                variants: savedVariants,
                images,
            },
        });
    }
    catch (error) {
        console.error("Error creating product:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.createProduct = createProduct;
exports.default = exports.createProduct;
const updateProduct = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        const { productId, name, description, fabric_type, category_id, subcategory_id, gender, bodyType, season_objectId, festival_objectId, care_instruction_objectId, productType, style, variants, } = req.body;
        if (!productId || !mongoose_1.default.Types.ObjectId.isValid(productId)) {
            res.status(400).json({ success: false, message: "Invalid product ID" });
            return;
        }
        const product = yield product_model_1.default.findById(productId);
        if (!product) {
            res.status(404).json({ success: false, message: "Product not found" });
            return;
        }
        product.name = name;
        product.description = description;
        product.fabric_type = fabric_type;
        product.category_id = category_id;
        product.subcategory_id = subcategory_id;
        product.gender = gender;
        product.bodyType = bodyType;
        product.productType = productType;
        product.style = safeParse(style);
        product.season_objectId = safeParse(season_objectId);
        product.festival_objectId = safeParse(festival_objectId);
        product.care_instruction_objectId = safeParse(care_instruction_objectId);
        yield product.save();
        const filesArray = req.files || [];
        const files = {};
        filesArray.forEach(file => {
            if (!files[file.fieldname])
                files[file.fieldname] = [];
            files[file.fieldname].push(file);
        });
        const parsedVariants = safeParse(variants);
        for (let i = 0; i < parsedVariants.length; i++) {
            const variant = parsedVariants[i];
            if (!variant._id || !mongoose_1.default.Types.ObjectId.isValid(variant._id)) {
                res.status(400).json({
                    success: false,
                    message: `Invalid or missing _id for variant at index ${i}. Only existing variants can be updated.`,
                });
                return;
            }
            const existingVariant = yield productVariant_model_1.default.findById(variant._id);
            if (!existingVariant) {
                res.status(404).json({
                    success: false,
                    message: `Variant not found with id: ${variant._id}`,
                });
                return;
            }
            yield productVariant_model_1.default.findByIdAndUpdate(variant._id, Object.assign(Object.assign({}, variant), { productObjectId: productId }));
            const variantImages = safeParse(variant.images || []);
            for (let j = 0; j < variantImages.length; j++) {
                const imageObj = variantImages[j];
                if (!imageObj._id || !mongoose_1.default.Types.ObjectId.isValid(imageObj._id)) {
                    res.status(400).json({
                        success: false,
                        message: `Invalid or missing _id for image at variant index ${i}, image index ${j}. New images cannot be added.`,
                    });
                    return;
                }
                const fileKey = `variant_${i}_image_${j}`;
                const file = (_a = files === null || files === void 0 ? void 0 : files[fileKey]) === null || _a === void 0 ? void 0 : _a[0];
                if (file) {
                    const imageBase64 = `data:${file.mimetype};base64,${file.buffer.toString('base64')}`;
                    yield productImage_model_1.default.findByIdAndUpdate(imageObj._id, {
                        image: imageBase64,
                    });
                }
            }
        }
        const updatedVariants = yield productVariant_model_1.default.find({ productObjectId: productId });
        const images = yield productImage_model_1.default.find({ productObjectId: productId });
        res.status(200).json({
            success: true,
            message: "Product, variants, and images updated successfully",
            data: {
                product,
                variants: updatedVariants,
                images,
            },
        });
    }
    catch (error) {
        console.error("Error updating product:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.updateProduct = updateProduct;
const getAllProducts = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10;
        const skip = (page - 1) * limit;
        const total = yield product_model_1.default.countDocuments();
        const products = yield product_model_1.default.find()
            .skip(skip)
            .limit(limit)
            .lean();
        const productIds = products.map(p => p._id);
        const variants = yield productVariant_model_1.default.find({ productObjectId: { $in: productIds } }).lean();
        const images = yield productImage_model_1.default.find({ productObjectId: { $in: productIds } }).lean();
        const enrichedProducts = products.map(product => {
            const productVariants = variants.filter(v => String(v.productObjectId) === String(product._id));
            const productImages = images.filter(img => String(img.productObjectId) === String(product._id));
            return Object.assign(Object.assign({}, product), { variants: productVariants, images: productImages });
        });
        res.status(200).json({
            success: true,
            data: enrichedProducts,
            pagination: {
                total,
                currentPage: page,
                totalPages: Math.ceil(total / limit),
                limit,
            },
        });
    }
    catch (error) {
        console.error("Error fetching products:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.getAllProducts = getAllProducts;
const deleteProduct = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { productId } = req.params;
    if (!mongoose_1.default.Types.ObjectId.isValid(productId)) {
        res.status(400).json({ success: false, message: "Invalid product ID" });
        return;
    }
    try {
        const product = yield product_model_1.default.findById(productId);
        if (!product) {
            res.status(404).json({ success: false, message: "Product not found" });
            return;
        }
        yield product_model_1.default.findByIdAndDelete(productId);
        yield productVariant_model_1.default.deleteMany({ productObjectId: productId });
        yield productImage_model_1.default.deleteMany({ productObjectId: productId });
        res.status(200).json({
            success: true,
            message: "Product, variants, and images deleted successfully",
        });
    }
    catch (error) {
        console.error("Error deleting product:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.deleteProduct = deleteProduct;
const getProductDetail = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { productId } = req.params;
        if (!mongoose_1.default.Types.ObjectId.isValid(productId)) {
            res.status(400).json({ success: false, message: "Invalid product ID" });
            return;
        }
        const product = yield product_model_1.default.findById(productId)
            .populate('care_instruction_objectId')
            .populate('season_objectId')
            .populate('festival_objectId')
            .lean();
        if (!product) {
            res.status(404).json({ success: false, message: "Product not found" });
            return;
        }
        const variants = yield productVariant_model_1.default.find({ productObjectId: productId }).lean();
        const images = yield productImage_model_1.default.find({ productObjectId: productId }).lean();
        const productDetail = Object.assign(Object.assign({}, product), { variants,
            images });
        const similarProductsQuery = yield product_model_1.default.aggregate([
            {
                $match: {
                    _id: { $ne: new mongoose_1.default.Types.ObjectId(productId) },
                    category_id: product.category_id,
                    subcategory_id: product.subcategory_id
                }
            },
            {
                $lookup: {
                    from: 'subcategories',
                    localField: 'subcategory_id',
                    foreignField: '_id',
                    as: 'subcategory'
                }
            }
        ]);
        const similarProducts = yield product_model_1.default.populate(similarProductsQuery, []);
        const similarProductIds = similarProducts.map(p => p._id);
        const similarVariants = yield productVariant_model_1.default.find({ productObjectId: { $in: similarProductIds } }).lean();
        const similarImages = yield productImage_model_1.default.find({ productObjectId: { $in: similarProductIds } }).lean();
        const enrichedSimilarProducts = similarProducts.map(prod => {
            const prodVariants = similarVariants.filter(v => String(v.productObjectId) === String(prod._id));
            const prodImages = similarImages.filter(img => String(img.productObjectId) === String(prod._id));
            return Object.assign(Object.assign({}, prod), { variants: prodVariants, images: prodImages });
        });
        const oppositeProductType = product.productType === 'top' ? 'bottom' : 'top';
        const matchingProductsQuery = yield product_model_1.default.aggregate([
            {
                $lookup: {
                    from: 'subcategories',
                    localField: 'subcategory_id',
                    foreignField: '_id',
                    as: 'subcategory'
                }
            },
            {
                $match: {
                    _id: { $ne: new mongoose_1.default.Types.ObjectId(productId) },
                    productType: oppositeProductType,
                    gender: product.gender,
                    bodyType: product.bodyType
                }
            }
        ]);
        const matchingProducts = yield product_model_1.default.populate(matchingProductsQuery, []);
        const matchingProductIds = matchingProducts.map(p => p._id);
        const matchingVariants = yield productVariant_model_1.default.find({ productObjectId: { $in: matchingProductIds } }).lean();
        const matchingImages = yield productImage_model_1.default.find({ productObjectId: { $in: matchingProductIds } }).lean();
        const enrichedMatchingProducts = matchingProducts.map(prod => {
            const prodVariants = matchingVariants.filter(v => String(v.productObjectId) === String(prod._id));
            const prodImages = matchingImages.filter(img => String(img.productObjectId) === String(prod._id));
            return Object.assign(Object.assign({}, prod), { variants: prodVariants, images: prodImages });
        });
        const trendingProductsQuery = yield product_model_1.default.aggregate([
            {
                $lookup: {
                    from: 'productvariants',
                    localField: '_id',
                    foreignField: 'productObjectId',
                    as: 'variants'
                }
            },
            {
                $match: {
                    _id: { $ne: new mongoose_1.default.Types.ObjectId(productId) },
                    'variants.is_on_trend': true
                }
            },
            {
                $lookup: {
                    from: 'subcategories',
                    localField: 'subcategory_id',
                    foreignField: '_id',
                    as: 'subcategory'
                }
            }
        ]);
        const trendingProducts = yield product_model_1.default.populate(trendingProductsQuery, []);
        const trendingProductIds = trendingProducts.map(p => p._id);
        const trendingVariants = yield productVariant_model_1.default.find({ productObjectId: { $in: trendingProductIds } }).lean();
        const trendingImages = yield productImage_model_1.default.find({ productObjectId: { $in: trendingProductIds } }).lean();
        const enrichedTrendingProducts = trendingProducts.map(prod => {
            const prodVariants = trendingVariants.filter(v => String(v.productObjectId) === String(prod._id));
            const prodImages = trendingImages.filter(img => String(img.productObjectId) === String(prod._id));
            return Object.assign(Object.assign({}, prod), { variants: prodVariants, images: prodImages });
        });
        res.status(200).json({
            success: true,
            data: {
                productDetail: productDetail,
                similarproduct: {
                    title: "Similar Products",
                    products: enrichedSimilarProducts
                },
                matchingproduct: {
                    title: "Matching Products",
                    products: enrichedMatchingProducts
                },
                trandingproducts: {
                    title: "Trending Products",
                    products: enrichedTrendingProducts
                }
            }
        });
    }
    catch (error) {
        console.error("Error fetching product detail:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.getProductDetail = getProductDetail;
const getTrendingProducts = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10;
        const skip = (page - 1) * limit;
        const trendingProductsQuery = yield product_model_1.default.aggregate([
            {
                $lookup: {
                    from: 'productvariants',
                    localField: '_id',
                    foreignField: 'productObjectId',
                    as: 'variants'
                }
            },
            {
                $match: {
                    'variants.is_on_trend': true
                }
            },
            {
                $lookup: {
                    from: 'categories',
                    localField: 'category_id',
                    foreignField: '_id',
                    as: 'category'
                }
            },
            {
                $lookup: {
                    from: 'subcategories',
                    localField: 'subcategory_id',
                    foreignField: '_id',
                    as: 'subcategory'
                }
            },
            {
                $lookup: {
                    from: 'careinstruction',
                    localField: 'care_instruction_objectId',
                    foreignField: '_id',
                    as: 'care_instruction_objectId'
                }
            },
            {
                $lookup: {
                    from: 'seasons',
                    localField: 'season_objectId',
                    foreignField: '_id',
                    as: 'season_objectId'
                }
            },
            {
                $lookup: {
                    from: 'festivals',
                    localField: 'festival_objectId',
                    foreignField: '_id',
                    as: 'festival_objectId'
                }
            },
            { $skip: skip },
            { $limit: limit }
        ]);
        const totalCountQuery = yield product_model_1.default.aggregate([
            {
                $lookup: {
                    from: 'productvariants',
                    localField: '_id',
                    foreignField: 'productObjectId',
                    as: 'variants'
                }
            },
            {
                $match: {
                    'variants.is_on_trend': true
                }
            },
            { $count: "total" }
        ]);
        const total = totalCountQuery.length > 0 ? totalCountQuery[0].total : 0;
        const productIds = trendingProductsQuery.map(p => p._id);
        const variants = yield productVariant_model_1.default.find({
            productObjectId: { $in: productIds },
            is_on_trend: true
        }).lean();
        const images = yield productImage_model_1.default.find({ productObjectId: { $in: productIds } }).lean();
        const enrichedProducts = trendingProductsQuery.map(product => {
            const productVariants = variants.filter(v => String(v.productObjectId) === String(product._id));
            const productImages = images.filter(img => String(img.productObjectId) === String(product._id));
            return Object.assign(Object.assign({}, product), { variants: productVariants, images: productImages });
        });
        res.status(200).json({
            success: true,
            data: enrichedProducts,
            pagination: {
                total,
                currentPage: page,
                totalPages: Math.ceil(total / limit),
                limit,
            },
        });
    }
    catch (error) {
        console.error("Error fetching trending products:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.getTrendingProducts = getTrendingProducts;
