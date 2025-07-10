import mongoose from "mongoose";

export const GENDER = {
  MALE: "male",
  FEMALE: "female",
  OTHER: "other",
};

export const BODYTYPE = {
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

const productSchema = new mongoose.Schema(
  {
    name: String,
    description: String,
    fabric_type: String,
    category_id: { type: mongoose.Schema.Types.ObjectId, ref: "Category" },
    reviewObjectId: { type: mongoose.Schema.Types.ObjectId, ref: "Review" },
    gender: {
      type: String,
      enum: Object.values(GENDER),
      default: GENDER.MALE,
      required: true,
    },
    bodyType: {
      type: String,
      enum: Object.values(BODYTYPE),
      default: BODYTYPE.HOURGLASS,
      required: true,
    },
    season_objectId: [{ type: mongoose.Schema.Types.ObjectId, ref: "Season" }],
    festival_objectId: [{
      type: mongoose.Schema.Types.ObjectId,
      ref: "Festival",
    }],
    care_instruction_objectId: [{
      type: mongoose.Schema.Types.ObjectId,
      ref: "CareInstruction",
    }],
    weight: String,
    productType: {
      type: String,
      enum: Object.values(PRODUCTTYPE),
      default: PRODUCTTYPE.TOP,
      required: true,
    },
    style: [String],
  },
  { timestamps: true }
);

const Product = mongoose.model("Product", productSchema);
export default Product;
