"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SIZE = void 0;
const mongoose_1 = __importDefault(require("mongoose"));
exports.SIZE = {
    ES: "ex",
    S: "s",
    M: "m",
    L: "l",
    XL: "xl",
};
const AVAILABLE_STATUS = {
    IN_STOCK: "in_stock",
    OUT_OF_STOCK: "out_of_stock",
    PRE_ORDER: "pre_order",
};
const productVariantSchema = new mongoose_1.default.Schema({
    productObjectId: { type: mongoose_1.default.Schema.Types.ObjectId, ref: "Product" },
    size: {
        type: String,
        enum: Object.values(exports.SIZE),
        default: exports.SIZE.L,
        required: true,
    },
    available_status: {
        type: String,
        enum: Object.values(AVAILABLE_STATUS),
        default: AVAILABLE_STATUS.IN_STOCK,
        required: true,
    },
    avatarUrl: String,
    ageGroup: String,
    skin_tone: [String],
    under_tone: [String],
    color: String,
    sku: String,
    stock_qty: Number,
    barcode: String,
    variant_image: String,
    price: Number,
    discount_price: Number,
    is_featured: Boolean,
    is_new_arrival: Boolean,
    is_best_seller: Boolean,
    is_on_sale: Boolean,
    is_on_trend: Boolean,
    is_limited_edition: Boolean,
    is_back_in_stock: Boolean,
    is_pre_order: Boolean,
    is_exclusive: Boolean,
    is_eco_friendly: Boolean,
    is_customizable: Boolean,
    is_limited_time_offer: Boolean,
    is_clearance: Boolean,
    is_giftable: Boolean,
    is_bundle: Boolean,
    is_recommended: Boolean,
    is_trending_near_you: Boolean,
    is_celebrity_pick: Boolean,
    is_festival_ready: Boolean,
    isTryOn: Boolean,
}, { timestamps: true });
const ProductVariant = mongoose_1.default.model("ProductVariant", productVariantSchema);
exports.default = ProductVariant;
