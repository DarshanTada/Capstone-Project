import Product, { BODYTYPE } from '../productModule/product.model';
import mongoose from "mongoose";

const preferenceSchema = new mongoose.Schema({
  user_objectId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  gender: String,
  age: Number,
  height: Number,
  body_type: {
    type: String,
    enum: Object.values(BODYTYPE),
    default: BODYTYPE.HOURGLASS,
    required: true,
  },
  skin_tone: String,
  style: [String],
  occasion: [String],
  festivals: [String],
  color_tones: [String],
  undertone: String
}, { timestamps: true });

const Preference = mongoose.model("Preference", preferenceSchema);
export default Preference;
