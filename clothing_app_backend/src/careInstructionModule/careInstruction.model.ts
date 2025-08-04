import mongoose from "mongoose";

export const FABRICTYPE = {
  COTTON: "Cotton",
  LINEN: "Linen",
  KHADI: "Khadi",
};

// models/CareInstruction.js
const careInstructionSchema = new mongoose.Schema(
  {
    fabricType: {
      type: String,
      enum: Object.values(FABRICTYPE),
      default: FABRICTYPE.COTTON,
      required: true,
    },
    instructions: [
      {
        instruction: { type: String, required: true },
        image: { type: String }, // optional image per instruction
      },
    ],
  },
  { timestamps: true }
);

const CareInstruction = mongoose.model(
  "CareInstruction",
  careInstructionSchema
);
export default CareInstruction;
