import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
  {
    phone_number: {
      type: String,
    },
    email: {
      type: String,
    },
    relation: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Relation",
    },
    role: {
      type: String,
      enum: ["user", "admin", "super_admin", "product_manager", "order_manager", "marketing_manager"],
      default: "user",
    },
    token: {
      type: String,
    },
    password: {
      type: String,
    },
    // Optional: reverse reference to preference
    preference: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Preference",
    },
  },
  {
    timestamps: true,
  }
);

const User = mongoose.model("User", userSchema);
export default User;

