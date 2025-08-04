"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const introSchema = new mongoose_1.default.Schema({
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
}, {
    timestamps: true,
});
const Intro = mongoose_1.default.model("Intro", introSchema);
exports.default = Intro;
