"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.FABRICTYPE = void 0;
const mongoose_1 = __importDefault(require("mongoose"));
exports.FABRICTYPE = {
    COTTON: "Cotton",
    LINEN: "Linen",
    KHADI: "Khadi",
};
const careInstructionSchema = new mongoose_1.default.Schema({
    fabricType: {
        type: String,
        enum: Object.values(exports.FABRICTYPE),
        default: exports.FABRICTYPE.COTTON,
        required: true,
    },
    instructions: [
        {
            instruction: { type: String, required: true },
            image: { type: String },
        },
    ],
}, { timestamps: true });
const CareInstruction = mongoose_1.default.model("CareInstruction", careInstructionSchema);
exports.default = CareInstruction;
