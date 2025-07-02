import mongoose from "mongoose";

// models/Festival.js
const festivalSchema = new mongoose.Schema({
  festival_name: String,
  isEnable: Boolean
}, { timestamps: true });

const Festival = mongoose.model("Festival", festivalSchema);
export default Festival;