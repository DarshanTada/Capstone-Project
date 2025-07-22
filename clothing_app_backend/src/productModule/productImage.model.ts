import mongoose from "mongoose";

const productImageSchema = new mongoose.Schema({
  productObjectId: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
  variantObjectid: { type: mongoose.Schema.Types.ObjectId, ref: 'ProductVariant' },
  image: {
    base64: String,
    contentType: String,
  },
  is_primary: Boolean,
  sort_order: Number
}, { timestamps: true });


const ProductImage = mongoose.model("ProductImage", productImageSchema);
export default ProductImage;