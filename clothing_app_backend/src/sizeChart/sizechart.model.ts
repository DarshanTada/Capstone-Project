import mongoose from "mongoose";

const measurementGuideSchema = new mongoose.Schema(
  {
    type: {
      type: String,
      enum: ["tops", "bottoms"],
      required: true,
    },
    image: {
      type: Buffer, // if you store images in MongoDB
      // type: String, // if you store image as URL (e.g., from S3 or Firebase)
    },
    instructions: [
      {
        label: String,
        description: String,
        number: Number,
      },
    ],
  },
  { timestamps: true }
);

const sizeChartSchema = new mongoose.Schema(
  {
    gender: {
      type: String,
      enum: ["women", "men"],
      required: true,
    },
    category: [
              { type: mongoose.Schema.Types.ObjectId, ref: 'Category' }
            ],
    fitType: {
      type: String,
      enum: ["regular", "maternity", "petite"],
      required: true,
    },
    sizeRange: {
      type: String, // e.g., "0-4", "6-10", "XXS/P - S/P"
      required: true,
    },
    sizes: [
      {
        usSize: Number,
        eurSize: Number,
        measurements: {
          waistInch: String,
          waistCm: String,
          lowHipInch: String,
          lowHipCm: String,
          bustInch: String,
          bustCm: String,
          armLength: String,
          insideLegLength: String,
          lowHipCurvyInch: String,
          lowHipCurvyCm: String,
        },
      },
    ],
    measurementGuide: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'MeasurementGuide',
      required: true
    },
  },
  { timestamps: true }
);

const MeasurementGuide = mongoose.model(
  "MeasurementGuide",
  measurementGuideSchema
);

const SizeChart = mongoose.model("SizeChart", sizeChartSchema);

export { MeasurementGuide, SizeChart };
