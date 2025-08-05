"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const productImageSchema = new mongoose_1.default.Schema({
    productObjectId: { type: mongoose_1.default.Schema.Types.ObjectId, ref: 'Product' },
    variantObjectid: { type: mongoose_1.default.Schema.Types.ObjectId, ref: 'ProductVariant' },
    image: { type: String, required: false },
    is_primary: Boolean,
    sort_order: Number
}, { timestamps: true });
const ProductImage = mongoose_1.default.model("ProductImage", productImageSchema);
exports.default = ProductImage;
