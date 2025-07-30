"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.BODYTYPE = exports.GENDER = void 0;
const mongoose_1 = __importDefault(require("mongoose"));
exports.GENDER = {
    MALE: "male",
    FEMALE: "female",
    OTHER: "other",
};
exports.BODYTYPE = {
    HOURGLASS: "Hourglass",
    TRIANGLE: "Triangle",
    ROUND: "Round",
    STRIGHT: "Straight",
    INVERTED_TRIANGLE: "Inverted Triangle",
    ECTOMORPH: "Ectomorph",
    MESOMORPH: "Mesomorph",
    ENDOMORPH: "Endomorph",
};
const PRODUCTTYPE = {
    TOP: "top",
    BOTTOM: "bottom",
};
const productSchema = new mongoose_1.default.Schema({
    name: String,
    description: String,
    fabric_type: String,
    category_id: { type: mongoose_1.default.Schema.Types.ObjectId, ref: "Category", required: true },
    subcategory_id: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: "SubCategory",
        required: true
    },
    reviewObjectId: { type: mongoose_1.default.Schema.Types.ObjectId, ref: "Review" },
    gender: {
        type: String,
        enum: Object.values(exports.GENDER),
        default: exports.GENDER.MALE,
        required: true,
    },
    bodyType: {
        type: String,
        enum: Object.values(exports.BODYTYPE),
        default: exports.BODYTYPE.HOURGLASS,
        required: true,
    },
    season_objectId: [{ type: mongoose_1.default.Schema.Types.ObjectId, ref: "Season" }],
    festival_objectId: [{
            type: mongoose_1.default.Schema.Types.ObjectId,
            ref: "Festival",
        }],
    care_instruction_objectId: [{
            type: mongoose_1.default.Schema.Types.ObjectId,
            ref: "CareInstruction",
            required: true
        }],
    height: String,
    productType: {
        type: String,
        enum: Object.values(PRODUCTTYPE),
        default: PRODUCTTYPE.TOP,
        required: true,
    },
    style: [String]
}, { timestamps: true });
const Product = mongoose_1.default.model("Product", productSchema);
exports.default = Product;
