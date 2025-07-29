import Product, { GENDER, BODYTYPE } from "../productModule/product.model";
import mongoose from "mongoose";

const subCategorySchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    image: {
      type: Buffer,
    },
    gender: {
      type: String,
      enum: Object.values(GENDER),
      default: GENDER.MALE,
      required: true,
    },
    body_type: {
      type: String,
      enum: Object.values(BODYTYPE),
      required: true,
    },
    category:{ type: mongoose.Schema.Types.ObjectId, ref: 'Category' }
  },
  {
    timestamps: true,
  }
);

const SubCategory = mongoose.model("SubCategory", subCategorySchema);
export default SubCategory;
