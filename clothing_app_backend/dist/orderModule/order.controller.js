"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
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
exports.getOrderById = exports.getOrdersByUserId = exports.getAllOrders = exports.cancelProduct = exports.updateProductStatus = exports.createOrder = void 0;
const order_model_1 = __importStar(require("./order.model"));
const user_model_1 = __importDefault(require("../userModule/user.model"));
const product_model_1 = __importDefault(require("../productModule/product.model"));
const productVariant_model_1 = __importDefault(require("../productModule/productVariant.model"));
const address_model_1 = __importDefault(require("../addressModule/address.model"));
const mongoose_1 = __importDefault(require("mongoose"));
const sendMail_1 = require("../utils/sendMail");
const createOrder = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        console.log("Received request body:", req.body);
        console.log("Products type:", typeof req.body.products);
        console.log("Products value:", req.body.products);
        let { products, user, address, paymentMethod } = req.body;
        if (typeof products === 'string') {
            try {
                products = JSON.parse(products);
                console.log("Parsed products:", products);
            }
            catch (parseError) {
                console.error("JSON parse error:", parseError);
                res.status(400).json({
                    success: false,
                    message: "Invalid products JSON format",
                    error: parseError.message
                });
                return;
            }
        }
        if (!products || !Array.isArray(products) || products.length === 0 || !user || !address) {
            console.log("Validation failed:", { products, user, address, productsIsArray: Array.isArray(products) });
            res.status(400).json({
                success: false,
                message: "All required fields must be provided: products array, user, address",
                received: {
                    products: products ? (Array.isArray(products) ? `Array with ${products.length} items` : typeof products) : 'null/undefined',
                    user: user || 'null/undefined',
                    address: address || 'null/undefined'
                }
            });
            return;
        }
        if (!mongoose_1.default.Types.ObjectId.isValid(user)) {
            res.status(400).json({ success: false, message: "Invalid user ID" });
            return;
        }
        if (!mongoose_1.default.Types.ObjectId.isValid(address)) {
            res.status(400).json({ success: false, message: "Invalid address ID" });
            return;
        }
        const userExists = yield user_model_1.default.findById(user);
        if (!userExists) {
            res.status(404).json({ success: false, message: "User not found" });
            return;
        }
        const addressExists = yield address_model_1.default.findById(address);
        if (!addressExists) {
            res.status(404).json({ success: false, message: "Address not found" });
            return;
        }
        if (String(addressExists.userId) !== String(user)) {
            res.status(403).json({ success: false, message: "Address does not belong to this user" });
            return;
        }
        const processedProducts = [];
        let totalAmount = 0;
        for (const productItem of products) {
            const { product, quantity, size } = productItem;
            const parsedQuantity = parseInt(quantity);
            if (!product || !parsedQuantity || !size) {
                res.status(400).json({
                    success: false,
                    message: "Each product must have: product ID, quantity, and size"
                });
                return;
            }
            if (!mongoose_1.default.Types.ObjectId.isValid(product)) {
                res.status(400).json({ success: false, message: `Invalid product ID: ${product}` });
                return;
            }
            if (isNaN(parsedQuantity) || parsedQuantity <= 0) {
                res.status(400).json({ success: false, message: "Quantity must be a positive number" });
                return;
            }
            const productExists = yield product_model_1.default.findById(product);
            if (!productExists) {
                res.status(404).json({ success: false, message: `Product not found: ${product}` });
                return;
            }
            console.log("Product details:", {
                id: product,
                name: productExists.name,
                price: productExists.price,
                priceType: typeof productExists.price
            });
            const variant = yield productVariant_model_1.default.findOne({
                productObjectId: product,
                size: size.toLowerCase(),
                available_status: 'in_stock'
            });
            if (!variant) {
                res.status(400).json({
                    success: false,
                    message: `Product variant with size ${size} is not available or out of stock for ${productExists.name}`
                });
                return;
            }
            if (variant.stock_qty && variant.stock_qty < parsedQuantity) {
                res.status(400).json({
                    success: false,
                    message: `Insufficient stock for ${productExists.name}. Available: ${variant.stock_qty}, Requested: ${parsedQuantity}`
                });
                return;
            }
            console.log("Variant details:", {
                variantId: variant._id,
                price: variant.price,
                priceType: typeof variant.price,
                size: variant.size,
                stock: variant.stock_qty
            });
            const variantPrice = parseFloat(((_a = variant.price) === null || _a === void 0 ? void 0 : _a.toString()) || '0');
            if (isNaN(variantPrice) || variantPrice <= 0) {
                res.status(400).json({
                    success: false,
                    message: `Invalid variant price for ${productExists.name} (Size: ${size}). Price: ${variant.price}`
                });
                return;
            }
            const itemPrice = variantPrice * parsedQuantity;
            totalAmount += itemPrice;
            console.log("Price calculation:", {
                variantPrice,
                parsedQuantity,
                itemPrice,
                totalAmount
            });
            processedProducts.push({
                product,
                quantity: parsedQuantity,
                size: size.toLowerCase(),
                status: order_model_1.STATUS.PENDING,
                price: itemPrice
            });
            if (variant.stock_qty) {
                variant.stock_qty -= parsedQuantity;
                if (variant.stock_qty <= 0) {
                    variant.available_status = 'out_of_stock';
                }
                yield variant.save();
            }
        }
        const newOrder = yield order_model_1.default.create({
            products: processedProducts,
            user,
            address,
            paymentMethod: paymentMethod || order_model_1.PAYMENTMETHOD.CREDITCARD,
            totalAmount
        });
        const populatedOrder = yield order_model_1.default.findById(newOrder._id)
            .populate('products.product', 'name price images')
            .populate('user', 'name email phone_number')
            .populate('address');
        try {
            const productList = processedProducts.map((item, index) => {
                const product = populatedOrder.products[index].product;
                return `- ${product.name} (Size: ${item.size}, Quantity: ${item.quantity}) - $${item.price.toFixed(2)}`;
            }).join('\n');
            yield (0, sendMail_1.sendMail)({
                to: userExists.email,
                subject: `Order Confirmation - Order #${newOrder._id}`,
                text: `Dear ${userExists.name || 'Customer'},

Your order has been successfully placed!

Order Details:
- Order ID: ${newOrder._id}
- Total Amount: $${totalAmount.toFixed(2)}

Products Ordered:
${productList}

Status: ${order_model_1.STATUS.PENDING}

We will send you updates as your order progresses.

Thank you for shopping with us!

Best regards,
Your Shopping Team`
            });
        }
        catch (emailError) {
            console.error('Failed to send order confirmation email:', emailError);
        }
        res.status(200).json({
            success: true,
            message: "Order created successfully",
            data: populatedOrder
        });
    }
    catch (error) {
        console.error("Error creating order:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.createOrder = createOrder;
const updateProductStatus = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { orderId, productId, status, reason } = req.body;
        if (!orderId || !productId || !status) {
            res.status(400).json({
                success: false,
                message: "Order ID, Product ID, and status are required"
            });
            return;
        }
        if (!mongoose_1.default.Types.ObjectId.isValid(orderId)) {
            res.status(400).json({ success: false, message: "Invalid order ID" });
            return;
        }
        if (!mongoose_1.default.Types.ObjectId.isValid(productId)) {
            res.status(400).json({ success: false, message: "Invalid product ID" });
            return;
        }
        if (!Object.values(order_model_1.STATUS).includes(status)) {
            res.status(400).json({
                success: false,
                message: `Invalid status. Valid statuses are: ${Object.values(order_model_1.STATUS).join(', ')}`
            });
            return;
        }
        const order = yield order_model_1.default.findById(orderId)
            .populate("user", "name email phone_number")
            .populate("products.product", "name");
        if (!order) {
            res.status(404).json({ success: false, message: "Order not found" });
            return;
        }
        const productIndex = order.products.findIndex((item) => item.product._id.toString() === productId);
        if (productIndex === -1) {
            res.status(404).json({
                success: false,
                message: "Product not found in this order"
            });
            return;
        }
        const oldStatus = order.products[productIndex].status;
        order.products[productIndex].status = status;
        yield order.save();
        try {
            const user = order.user;
            const product = order.products[productIndex].product;
            yield (0, sendMail_1.sendMail)({
                to: user.email,
                subject: `Order Status Update - Order #${order._id}`,
                text: `Dear ${user.name || 'Customer'},

Your order status has been updated!

Order ID: ${order._id}
Product: ${product.name}
Previous Status: ${oldStatus}
New Status: ${status}
${reason ? `Reason: ${reason}` : ''}

Best regards,
Your Shopping Team`
            });
        }
        catch (emailError) {
            console.error('Failed to send status update email:', emailError);
        }
        res.status(200).json({
            success: true,
            message: `Product status updated from ${oldStatus} to ${status}`,
            data: order
        });
    }
    catch (error) {
        console.error("Error updating product status:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.updateProductStatus = updateProductStatus;
const cancelProduct = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        const { orderId, productId, cancelReason } = req.body;
        if (!orderId || !productId) {
            res.status(400).json({
                success: false,
                message: "Order ID and Product ID are required"
            });
            return;
        }
        if (!mongoose_1.default.Types.ObjectId.isValid(orderId)) {
            res.status(400).json({ success: false, message: "Invalid order ID" });
            return;
        }
        if (!mongoose_1.default.Types.ObjectId.isValid(productId)) {
            res.status(400).json({ success: false, message: "Invalid product ID" });
            return;
        }
        const order = yield order_model_1.default.findById(orderId)
            .populate("user", "name email phone_number")
            .populate("products.product", "name");
        if (!order) {
            res.status(404).json({ success: false, message: "Order not found" });
            return;
        }
        const productIndex = order.products.findIndex((item) => item.product._id.toString() === productId);
        if (productIndex === -1) {
            res.status(404).json({
                success: false,
                message: "Product not found in this order"
            });
            return;
        }
        const productItem = order.products[productIndex];
        if (productItem.isCancelled) {
            res.status(400).json({
                success: false,
                message: "Product is already cancelled"
            });
            return;
        }
        if ([order_model_1.STATUS.SHIPPED, order_model_1.STATUS.DELIVERED].includes(productItem.status)) {
            res.status(400).json({
                success: false,
                message: "Cannot cancel shipped or delivered items"
            });
            return;
        }
        productItem.status = order_model_1.STATUS.CANCELLED;
        productItem.isCancelled = true;
        productItem.cancelReason = cancelReason || "Cancelled by user";
        const variant = yield productVariant_model_1.default.findOne({
            productObjectId: productId,
            size: productItem.size,
        });
        if (variant) {
            if (variant.stock_qty !== undefined) {
                variant.stock_qty = ((_a = variant.stock_qty) !== null && _a !== void 0 ? _a : 0) + productItem.quantity;
            }
            if (variant.available_status === 'out_of_stock') {
                variant.available_status = 'in_stock';
            }
            yield variant.save();
        }
        order.totalAmount = order.products
            .filter((item) => !item.isCancelled)
            .reduce((total, item) => total + item.price, 0);
        yield order.save();
        try {
            const user = order.user;
            const product = productItem.product;
            yield (0, sendMail_1.sendMail)({
                to: user.email,
                subject: `Product Cancelled - Order #${order._id}`,
                text: `Dear ${user.name || 'Customer'},

A product in your order has been cancelled.

Order ID: ${order._id}
Cancelled Product: ${product.name}
Reason: ${cancelReason || "No reason provided"}

Refund Amount: $${productItem.price.toFixed(2)}
New Order Total: $${order.totalAmount.toFixed(2)}

If you didn't request this cancellation, please contact our support team.

Best regards,
Your Shopping Team`
            });
        }
        catch (emailError) {
            console.error('Failed to send cancellation email:', emailError);
        }
        res.status(200).json({
            success: true,
            message: "Product cancelled successfully",
            data: order
        });
    }
    catch (error) {
        console.error("Error cancelling product:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.cancelProduct = cancelProduct;
const getAllOrders = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { page, limit, status, userId } = req.body;
        const parsedPage = parseInt(page) || 1;
        const parsedLimit = parseInt(limit) || 10;
        const skip = (parsedPage - 1) * parsedLimit;
        let filterCondition = {};
        if (userId && mongoose_1.default.Types.ObjectId.isValid(userId)) {
            filterCondition.user = userId;
        }
        const total = yield order_model_1.default.countDocuments(filterCondition);
        const orders = yield order_model_1.default.find(filterCondition)
            .populate('products.product', 'name images price')
            .populate('user', 'name email phone_number')
            .populate('address')
            .sort({ createdAt: -1 })
            .skip(skip)
            .limit(parsedLimit);
        res.status(200).json({
            success: true,
            data: orders,
            pagination: {
                total,
                currentPage: parsedPage,
                totalPages: Math.ceil(total / parsedLimit),
                limit: parsedLimit,
            },
            filters: {
                status: status || 'all',
                userId: userId || 'all'
            }
        });
    }
    catch (error) {
        console.error("Error fetching orders:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.getAllOrders = getAllOrders;
const getOrdersByUserId = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { userId, page, limit, status } = req.body;
        if (!userId || !mongoose_1.default.Types.ObjectId.isValid(userId)) {
            res.status(400).json({ success: false, message: "Valid user ID is required" });
            return;
        }
        const parsedPage = parseInt(page) || 1;
        const parsedLimit = parseInt(limit) || 10;
        const skip = (parsedPage - 1) * parsedLimit;
        let filterCondition = { user: userId };
        const total = yield order_model_1.default.countDocuments(filterCondition);
        const orders = yield order_model_1.default.find(filterCondition)
            .populate('products.product', 'name images price')
            .populate('address')
            .sort({ createdAt: -1 })
            .skip(skip)
            .limit(parsedLimit);
        res.status(200).json({
            success: true,
            data: orders,
            pagination: {
                total,
                currentPage: parsedPage,
                totalPages: Math.ceil(total / parsedLimit),
                limit: parsedLimit,
            },
            filters: {
                status: status || 'all'
            }
        });
    }
    catch (error) {
        console.error("Error fetching user orders:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.getOrdersByUserId = getOrdersByUserId;
const getOrderById = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { orderId } = req.params;
        if (!mongoose_1.default.Types.ObjectId.isValid(orderId)) {
            res.status(400).json({ success: false, message: "Invalid order ID" });
            return;
        }
        const order = yield order_model_1.default.findById(orderId)
            .populate('products.product', 'name price images description')
            .populate('user', 'name email phone_number gender age')
            .populate('address');
        if (!order) {
            res.status(404).json({ success: false, message: "Order not found" });
            return;
        }
        res.status(200).json({
            success: true,
            data: order
        });
    }
    catch (error) {
        console.error("Error fetching order:", error);
        res.status(500).json({
            success: false,
            message: "Something went wrong",
            error: error.message,
        });
    }
});
exports.getOrderById = getOrderById;
