import mongoose from "mongoose";

const productVariantSchema = new mongoose.Schema({
  productObjectId: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
  size: String,
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
  isTryOn: Boolean
}, { timestamps: true });

const ProductVariant = mongoose.model("ProductVariant", productVariantSchema);
export default ProductVariant;
