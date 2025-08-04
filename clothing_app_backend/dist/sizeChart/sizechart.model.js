"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SizeChart = exports.MeasurementGuide = void 0;
const mongoose_1 = __importDefault(require("mongoose"));
const measurementGuideSchema = new mongoose_1.default.Schema({
    type: {
        type: String,
        enum: ["tops", "bottoms"],
        required: true,
    },
    image: {
        type: Buffer,
    },
    instructions: [
        {
            label: String,
            description: String,
            number: Number,
        },
    ],
}, { timestamps: true });
const sizeChartSchema = new mongoose_1.default.Schema({
    gender: {
        type: String,
        enum: ["women", "men"],
        required: true,
    },
    category: [
        { type: mongoose_1.default.Schema.Types.ObjectId, ref: 'Category' }
    ],
    fitType: {
        type: String,
        enum: ["regular", "maternity", "petite"],
        required: true,
    },
    sizeRange: {
        type: String,
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
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: 'MeasurementGuide',
        required: true
    },
}, { timestamps: true });
const MeasurementGuide = mongoose_1.default.model("MeasurementGuide", measurementGuideSchema);
exports.MeasurementGuide = MeasurementGuide;
const SizeChart = mongoose_1.default.model("SizeChart", sizeChartSchema);
exports.SizeChart = SizeChart;
