import mongoose from "mongoose";

// models/CareInstruction.js
const careInstructionSchema = new mongoose.Schema({
  instruction: String,
  image: String
}, { timestamps: true });

const CareInstruction = mongoose.model("CareInstruction", careInstructionSchema);
export default CareInstruction;