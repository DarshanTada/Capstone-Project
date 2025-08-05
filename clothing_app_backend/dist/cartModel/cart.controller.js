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
exports.clearCart = exports.getCart = exports.removeFromCart = exports.updateCartQuantity = exports.addToCart = void 0;
const cart_model_1 = __importDefault(require("./cart.model"));
const user_model_1 = __importDefault(require("../userModule/user.model"));
const product_model_1 = __importDefault(require("../productModule/product.model"));
const productVariant_model_1 = __importDefault(require("../productModule/productVariant.model"));
const productImage_model_1 = __importDefault(require("../productModule/productImage.model"));
const mongoose_1 = __importDefault(require("mongoose"));
const addToCart = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        console.log("Received request body:", req.body);
        const { userId, variantId, quantity } = req.body;
        const parsedQuantity = parseInt(quantity);
        if (!userId || !variantId || !quantity) {
            res.status(400).json({
                success: false,
                message: "All fields are required: userId, variantId, quantity"
            });
            return;
        }
        if (!mongoose_1.default.Types.ObjectId.isValid(userId)) {
            res.status(400).json({ success: false, message: "Invalid user ID" });
            return;
        }
        if (!mongoose_1.default.Types.ObjectId.isValid(variantId)) {
            res.status(400).json({ success: false, message: "Invalid variant ID" });
            return;
        }
        if (isNaN(parsedQuantity) || parsedQuantity <= 0) {
            res.status(400).json({ success: false, message: "Quantity must be a positive number" });
            return;
        }
        const userExists = yield user_model_1.default.findById(userId);
        if (!userExists) {
            res.status(404).json({ success: false, message: "User not found" });
            return;
        }
        const variant = yield productVariant_model_1.default.findById(variantId);
        if (!variant) {
            res.status(404).json({ success: false, message: "Product variant not found" });
            return;
        }
        if (variant.available_status !== 'in_stock') {
            res.status(400).json({
                success: false,
                message: `Product variant is not available. Status: ${variant.available_status}`
            });
            return;
        }
        const productExists = yield product_model_1.default.findById(variant.productObjectId);
        if (!productExists) {
            res.status(404).json({ success: false, message: "Product not found" });
            return;
        }
        if (variant.stock_qty && variant.stock_qty < parsedQuantity) {
            res.status(400).json({
                success: false,
                message: `Insufficient stock. Available: ${variant.stock_qty}, Requested: ${parsedQuantity}`
            });
            return;
        }
        const variantPrice = parseFloat(((_a = variant.price) === null || _a === void 0 ? void 0 : _a.toString()) || '0');
        if (isNaN(variantPrice) || variantPrice <= 0) {
            res.status(400).json({
                success: false,
                message: `Invalid variant price for size ${variant.size}`
            });
            return;
        }
        let cart = yield cart_model_1.default.findOne({ user: userId });
        if (!cart) {
            cart = new cart_model_1.default({
                user: userId,
                items: [],
                subTotalAmount: 0
            });
        }
        const existingItemIndex = cart.items.findIndex((item) => { var _a; return ((_a = item.variantId) === null || _a === void 0 ? void 0 : _a.toString()) === variantId; });
        console.log(`Checking for existing variant: VariantId ${variantId}`);
        console.log(`Existing item index: ${existingItemIndex}`);
        const images = yield productImage_model_1.default.find({
            variantObjectid: variantId
        }).sort({ sort_order: 1 });
        const validImages = images.filter(img => img.image && img.image.trim() !== '');
        const primaryImage = validImages.find(img => img.is_primary) || validImages[0];
        const imageData = primaryImage ? primaryImage.image : null;
        if (existingItemIndex > -1) {
            const newQuantity = cart.items[existingItemIndex].quantity + parsedQuantity;
            console.log(`Updating existing variant: Current qty ${cart.items[existingItemIndex].quantity}, Adding ${parsedQuantity}, New total: ${newQuantity}`);
            if (variant.stock_qty && variant.stock_qty < newQuantity) {
                res.status(400).json({
                    success: false,
                    message: `Cannot add ${parsedQuantity} more items. Available stock: ${variant.stock_qty}, Current in cart: ${cart.items[existingItemIndex].quantity}`
                });
                return;
            }
            cart.items[existingItemIndex].quantity = newQuantity;
            cart.items[existingItemIndex].price = variantPrice * newQuantity;
            cart.items[existingItemIndex].image = imageData || '';
        }
        else {
            console.log(`Adding new variant: VariantId ${variantId}, Product ${variant.productObjectId}, Size ${variant.size}, Quantity ${parsedQuantity}`);
            cart.items.push({
                product: variant.productObjectId,
                variantId: variantId,
                size: variant.size.toLowerCase(),
                quantity: parsedQuantity,
                price: variantPrice * parsedQuantity,
                image: imageData || ''
            });
        }
        cart.subTotalAmount = cart.items.reduce((total, item) => total + item.price, 0);
        yield cart.save();
        const populatedCart = yield cart_model_1.default.findById(cart._id)
            .populate('items.product', 'name description')
            .populate('user', 'name email');
        const cartWithVariants = yield Promise.all(populatedCart.items.map((item) => __awaiter(void 0, void 0, void 0, function* () {
            const itemVariant = yield productVariant_model_1.default.findById(item.variantId);
            return Object.assign(Object.assign({}, item.toObject()), { variant: itemVariant });
        })));
        res.status(200).json({
            success: true,
            message: "Product added to cart successfully",
            data: {
                user: populatedCart.user,
                items: cartWithVariants,
                subTotalAmount: populatedCart.subTotalAmount
            }
        });
    }
    catch (error) {
        console.error("Error adding to cart:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.addToCart = addToCart;
const updateCartQuantity = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        const { userId, variantId, quantity } = req.body;
        const parsedQuantity = parseInt(quantity);
        if (!userId || !variantId || !quantity) {
            res.status(400).json({
                success: false,
                message: "All fields are required: userId, variantId, quantity"
            });
            return;
        }
        if (!mongoose_1.default.Types.ObjectId.isValid(userId)) {
            res.status(400).json({ success: false, message: "Invalid user ID" });
            return;
        }
        if (!mongoose_1.default.Types.ObjectId.isValid(variantId)) {
            res.status(400).json({ success: false, message: "Invalid variant ID" });
            return;
        }
        if (isNaN(parsedQuantity) || parsedQuantity <= 0) {
            res.status(400).json({ success: false, message: "Quantity must be a positive number" });
            return;
        }
        const userExists = yield user_model_1.default.findById(userId);
        if (!userExists) {
            res.status(404).json({ success: false, message: "User not found" });
            return;
        }
        const variant = yield productVariant_model_1.default.findById(variantId);
        if (!variant) {
            res.status(404).json({ success: false, message: "Product variant not found" });
            return;
        }
        if (variant.available_status !== 'in_stock') {
            res.status(400).json({
                success: false,
                message: `Product variant is not available. Status: ${variant.available_status}`
            });
            return;
        }
        const productExists = yield product_model_1.default.findById(variant.productObjectId);
        if (!productExists) {
            res.status(404).json({ success: false, message: "Product not found" });
            return;
        }
        const cart = yield cart_model_1.default.findOne({ user: userId });
        if (!cart) {
            res.status(404).json({ success: false, message: "Cart not found" });
            return;
        }
        const itemIndex = cart.items.findIndex((item) => { var _a; return ((_a = item.variantId) === null || _a === void 0 ? void 0 : _a.toString()) === variantId; });
        if (itemIndex === -1) {
            res.status(404).json({ success: false, message: "Item not found in cart" });
            return;
        }
        if (variant.stock_qty && variant.stock_qty < parsedQuantity) {
            res.status(400).json({
                success: false,
                message: `Insufficient stock. Available: ${variant.stock_qty}, Requested: ${parsedQuantity}`
            });
            return;
        }
        const variantPrice = parseFloat(((_a = variant.price) === null || _a === void 0 ? void 0 : _a.toString()) || '0');
        if (isNaN(variantPrice) || variantPrice <= 0) {
            res.status(400).json({
                success: false,
                message: `Invalid variant price for size ${variant.size}`
            });
            return;
        }
        const images = yield productImage_model_1.default.find({
            variantObjectid: variantId
        }).sort({ sort_order: 1 });
        const validImages = images.filter(img => img.image && img.image.trim() !== '');
        const primaryImage = validImages.find(img => img.is_primary) || validImages[0];
        const imageData = primaryImage ? primaryImage.image : null;
        cart.items[itemIndex].quantity = parsedQuantity;
        cart.items[itemIndex].price = variantPrice * parsedQuantity;
        cart.items[itemIndex].image = imageData || '';
        cart.subTotalAmount = cart.items.reduce((total, item) => total + item.price, 0);
        yield cart.save();
        const populatedCart = yield cart_model_1.default.findById(cart._id)
            .populate('items.product', 'name description')
            .populate('user', 'name email');
        const cartWithVariants = yield Promise.all(populatedCart.items.map((item) => __awaiter(void 0, void 0, void 0, function* () {
            const itemVariant = yield productVariant_model_1.default.findById(item.variantId);
            return Object.assign(Object.assign({}, item.toObject()), { variant: itemVariant });
        })));
        res.status(200).json({
            success: true,
            message: "Cart quantity updated successfully",
            data: {
                user: populatedCart.user,
                items: cartWithVariants,
                subTotalAmount: populatedCart.subTotalAmount
            }
        });
    }
    catch (error) {
        console.error("Error updating cart quantity:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.updateCartQuantity = updateCartQuantity;
const removeFromCart = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { userId, variantId } = req.body;
        if (!userId || !variantId) {
            res.status(400).json({
                success: false,
                message: "All fields are required: userId, variantId"
            });
            return;
        }
        if (!mongoose_1.default.Types.ObjectId.isValid(userId)) {
            res.status(400).json({ success: false, message: "Invalid user ID" });
            return;
        }
        if (!mongoose_1.default.Types.ObjectId.isValid(variantId)) {
            res.status(400).json({ success: false, message: "Invalid variant ID" });
            return;
        }
        const userExists = yield user_model_1.default.findById(userId);
        if (!userExists) {
            res.status(404).json({ success: false, message: "User not found" });
            return;
        }
        const variant = yield productVariant_model_1.default.findById(variantId);
        if (!variant) {
            res.status(404).json({ success: false, message: "Product variant not found" });
            return;
        }
        const cart = yield cart_model_1.default.findOne({ user: userId });
        if (!cart) {
            res.status(404).json({ success: false, message: "Cart not found" });
            return;
        }
        const itemToRemove = cart.items.find((item) => { var _a; return ((_a = item.variantId) === null || _a === void 0 ? void 0 : _a.toString()) === variantId; });
        if (!itemToRemove) {
            res.status(404).json({ success: false, message: "Item not found in cart" });
            return;
        }
        cart.items.pull(itemToRemove._id);
        cart.subTotalAmount = cart.items.reduce((total, item) => total + item.price, 0);
        yield cart.save();
        res.status(200).json({
            success: true,
            message: "Product removed from cart successfully",
            data: {
                subTotalAmount: cart.subTotalAmount
            }
        });
    }
    catch (error) {
        console.error("Error removing from cart:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.removeFromCart = removeFromCart;
const getCart = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { userId } = req.body;
        if (!userId) {
            res.status(400).json({
                success: false,
                message: "User ID is required"
            });
            return;
        }
        if (!mongoose_1.default.Types.ObjectId.isValid(userId)) {
            res.status(400).json({ success: false, message: "Invalid user ID" });
            return;
        }
        const cart = yield cart_model_1.default.findOne({ user: userId })
            .populate('items.product', 'name description')
            .populate('user', 'name email');
        if (!cart) {
            res.status(200).json({
                success: true,
                message: "Cart is empty",
                data: {
                    user: userId,
                    items: [],
                    subTotalAmount: 0
                }
            });
            return;
        }
        const cartWithVariants = yield Promise.all(cart.items.map((item) => __awaiter(void 0, void 0, void 0, function* () {
            const itemVariant = yield productVariant_model_1.default.findById(item.variantId);
            return Object.assign(Object.assign({}, item.toObject()), { variant: itemVariant });
        })));
        res.status(200).json({
            success: true,
            message: "Cart retrieved successfully",
            data: {
                user: cart.user,
                items: cartWithVariants,
                subTotalAmount: cart.subTotalAmount
            }
        });
    }
    catch (error) {
        console.error("Error getting cart:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.getCart = getCart;
const clearCart = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { userId } = req.body;
        if (!userId) {
            res.status(400).json({
                success: false,
                message: "User ID is required"
            });
            return;
        }
        if (!mongoose_1.default.Types.ObjectId.isValid(userId)) {
            res.status(400).json({ success: false, message: "Invalid user ID" });
            return;
        }
        const cart = yield cart_model_1.default.findOne({ user: userId });
        if (!cart) {
            res.status(404).json({ success: false, message: "Cart not found" });
            return;
        }
        cart.items.splice(0, cart.items.length);
        cart.subTotalAmount = 0;
        yield cart.save();
        res.status(200).json({
            success: true,
            message: "Cart cleared successfully",
            data: cart
        });
    }
    catch (error) {
        console.error("Error clearing cart:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.clearCart = clearCart;
