import Product, { GENDER, BODYTYPE } from "../productModule/product.model";
import mongoose from "mongoose";

const categorySchema = new mongoose.Schema(
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
    body_type: [
      {
        name: {
          type: String,
          enum: Object.values(BODYTYPE),
          required: true,
        },
        subcategory: [
          { type: mongoose.Schema.Types.ObjectId, ref: 'SubCategory' }
        ],
      }
    ]
  },
  {
    timestamps: true,
  }
);

const Category = mongoose.model("Category", categorySchema);
export default Category;
