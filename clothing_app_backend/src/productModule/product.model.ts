import mongoose from "mongoose";


const productSchema = new mongoose.Schema({
  name: String,
  description: String,
  fabric_type: String,
  category_id: String,
  availabe_status: String,
  reviewObjectId: String,
  gender: String,
  bodyType: String,
  season_objectId: { type: mongoose.Schema.Types.ObjectId, ref: 'Season' },
  festival_objectId: { type: mongoose.Schema.Types.ObjectId, ref: 'Festival' },
  care_instruction_objectId: { type: mongoose.Schema.Types.ObjectId, ref: 'CareInstruction' },
  weight: String,
  productType: String
}, { timestamps: true });

const Product = mongoose.model("Product", productSchema);
export default Product;

