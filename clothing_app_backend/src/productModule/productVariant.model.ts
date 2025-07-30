import mongoose from "mongoose";

export const SIZE = {
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

const productVariantSchema = new mongoose.Schema(
  {
    productObjectId: { type: mongoose.Schema.Types.ObjectId, ref: "Product" },
    size: {
      type: String,
      enum: Object.values(SIZE),
      default: SIZE.L,
      required: true,
    },
    available_status: {
      type: String,
      enum: Object.values(AVAILABLE_STATUS),
      default: AVAILABLE_STATUS.IN_STOCK,
      required: true,
    },
    avatarUrl:String,
    ageGroup: String,
    skin_tone:[String],
    under_tone:[String],
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
  },
  { timestamps: true }
);

const ProductVariant = mongoose.model("ProductVariant", productVariantSchema);
export default ProductVariant;
