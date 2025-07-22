import mongoose from "mongoose";

const BANNER_TYPES = [
  'featured', 'popular_category', 'chic_look', 'seasonal', 'discount',
  'new_arrival', 'best_seller', 'clearance', 'you_may_like', 'model_list',
  'all_products', 'flash_sale', 'editor_pick', 'trending_now', 'limited_edition',
  'back_in_stock', 'shop_by_occasion'
];

const bannerSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: { type: String, default: '' },
  image: { type: String, required: true }, // base64 string
  type: { type: String, enum: BANNER_TYPES, required: true },
  redirect_url: { type: String, default: null },
  is_active: { type: Boolean, default: true },
  priority: { type: Number, default: 0 },
  created_at: { type: Date, default: Date.now },
  updated_at: { type: Date, default: Date.now }
});

const Banner = mongoose.model(
  "Banner",
  bannerSchema
);
export default Banner;
