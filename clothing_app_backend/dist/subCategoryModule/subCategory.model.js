"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const product_model_1 = require("../productModule/product.model");
const mongoose_1 = __importDefault(require("mongoose"));
const subCategorySchema = new mongoose_1.default.Schema({
    name: {
        type: String,
        required: true,
    },
    image: { type: String, required: false },
    gender: {
        type: String,
        enum: Object.values(product_model_1.GENDER),
        default: product_model_1.GENDER.MALE,
        required: true,
    },
    body_type: {
        type: String,
        enum: Object.values(product_model_1.BODYTYPE),
        required: true,
    },
    category: { type: mongoose_1.default.Schema.Types.ObjectId, ref: 'Category' }
}, {
    timestamps: true,
});
const SubCategory = mongoose_1.default.model("SubCategory", subCategorySchema);
exports.default = SubCategory;
