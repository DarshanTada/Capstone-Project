import mongoose from "mongoose";

const introSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
    },
    intro_description: {
      type: String,
      required: true,
    },
    image: {
      type: Buffer,
    }
  },
  {
    timestamps: true,
  }
);

const Intro = mongoose.model("Intro", introSchema);
export default Intro;
