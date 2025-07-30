"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PAYMENTMETHOD = exports.STATUS = void 0;
const mongoose_1 = __importDefault(require("mongoose"));
exports.STATUS = {
    PENDING: "Pending",
    PROCESSING: "Processing",
    SHIPPED: "Shipped",
    DELIVERED: "Delivered",
    CANCELLED: "Cancelled",
};
exports.PAYMENTMETHOD = {
    CREDITCARD: "Credit Card",
    PAYPAL: "PayPal",
    APPLEPAY: "Apple Pay",
    GOOGLEPAY: "Google Pay",
};
const productItemSchema = new mongoose_1.default.Schema({
    product: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: "Product",
        required: true,
    },
    quantity: {
        type: Number,
        required: true,
    },
    size: {
        type: String,
        required: true,
    },
    status: {
        type: String,
        enum: Object.values(exports.STATUS),
        default: exports.STATUS.PENDING,
        required: true,
    },
    price: {
        type: Number,
        required: true,
    },
    cancelReason: {
        type: String,
        default: null,
    },
    isCancelled: {
        type: Boolean,
        default: false,
    },
}, {
    _id: true,
    timestamps: true,
});
const orderSchema = new mongoose_1.default.Schema({
    products: [productItemSchema],
    user: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: "User",
        required: true,
    },
    address: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: "Address",
        required: true,
    },
    paymentMethod: {
        type: String,
        enum: Object.values(exports.PAYMENTMETHOD),
        default: exports.PAYMENTMETHOD.CREDITCARD,
        required: true,
    },
    totalAmount: {
        type: Number,
        required: true,
    }
}, {
    timestamps: true,
});
const Order = mongoose_1.default.model("Order", orderSchema);
exports.default = Order;
