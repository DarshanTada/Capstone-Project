import mongoose from "mongoose";

const preferenceSchema = new mongoose.Schema({
  user_objectId: { type: Number, required: true },
  gender: String,
  age: Number,
  height: Number,
  body_type: String,
  skin_tone: String,
  style: [String],
  occasion: [String],
  festivals: [String],
  color_tones: [String],
  undertone: String
}, { timestamps: true });

const Preference = mongoose.model("Preference", preferenceSchema);
export default Preference;
