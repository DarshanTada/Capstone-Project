import mongoose from "mongoose";

export const relationProfileSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    preference: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Preference",
      required: true,
      unique: true,
    },
    isActive: {
      type: Boolean,
      default: false,
    }
  },
  {
    timestamps: true,
  }
);

const RelationProfile = mongoose.model("RelationProfile", relationProfileSchema);
export default RelationProfile;


// When user profile change the update preference in get user api instead of original useer preference send selected preferece