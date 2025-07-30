"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const BANNER_TYPES = [
    'featured', 'popular_category', 'chic_look', 'seasonal', 'discount',
    'new_arrival', 'best_seller', 'clearance', 'you_may_like', 'model_list',
    'all_products', 'flash_sale', 'editor_pick', 'trending_now', 'limited_edition',
    'back_in_stock', 'shop_by_occasion'
];
const bannerSchema = new mongoose_1.default.Schema({
    title: { type: String, required: true },
    description: { type: String, default: '' },
    image: { type: String, required: true },
    type: { type: String, enum: BANNER_TYPES, required: true },
    redirect_url: { type: String, default: null },
    is_active: { type: Boolean, default: true },
    priority: { type: Number, default: 0 },
    created_at: { type: Date, default: Date.now },
    updated_at: { type: Date, default: Date.now }
});
const Banner = mongoose_1.default.model("Banner", bannerSchema);
exports.default = Banner;
