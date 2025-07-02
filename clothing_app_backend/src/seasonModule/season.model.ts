import mongoose from "mongoose";


// models/Season.js
const seasonSchema = new mongoose.Schema({
  season_name: String,
  isEnable: Boolean
}, { timestamps: true });

const Season = mongoose.model("Season", seasonSchema);
export default Season;

