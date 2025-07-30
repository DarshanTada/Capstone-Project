"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const product_model_js_1 = require("../productModule/product.model.js");
const productVariant_model_js_1 = require("../productModule/productVariant.model.js");
const preferenceSchema = new mongoose_1.default.Schema({
    user: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: "User",
        required: true,
        unique: true,
    },
    username: {
        type: String,
    },
    gender: {
        type: String,
        enum: Object.values(product_model_js_1.GENDER),
        default: product_model_js_1.GENDER.MALE
    },
    age: {
        type: Number
    },
    height: {
        type: Number
    },
    body_type: {
        type: String,
        enum: Object.values(product_model_js_1.BODYTYPE),
        default: product_model_js_1.BODYTYPE.HOURGLASS,
        required: true,
    },
    skin_tone: {
        type: String,
    },
    style: [String],
    occasion: [String],
    festivals: [String],
    color_tones: [String],
    size: {
        type: String,
        enum: Object.values(productVariant_model_js_1.SIZE),
        default: productVariant_model_js_1.SIZE.L
    },
    undertone: {
        type: String,
    },
    userPhoto: {
        base64: String,
        contentType: String,
    },
    avartarURL: {
        type: String,
    },
}, {
    timestamps: true,
});
const Preference = mongoose_1.default.model("Preference", preferenceSchema);
exports.default = Preference;
