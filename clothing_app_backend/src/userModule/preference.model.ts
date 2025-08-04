import mongoose from "mongoose";
import Product, { BODYTYPE, GENDER } from "../productModule/product.model";
import ProductVarient, { SIZE } from "../productModule/productVariant.model";

const preferenceSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      unique: true, // Ensures one-to-one relation
    },
    username: {
      type: String,
    },
    gender: {
      type: String,
      enum: Object.values(GENDER),
      default: GENDER.MALE
    },
    age: {
      type: Number
    },
    height: {
      type: Number
    },
    body_type: {
      type: String,
      enum: Object.values(BODYTYPE),
      default: BODYTYPE.HOURGLASS
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
      enum: Object.values(SIZE),
      default: SIZE.L
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
  },
  {
    timestamps: true,
  }
);

const Preference = mongoose.model("Preference", preferenceSchema);
export default Preference;
