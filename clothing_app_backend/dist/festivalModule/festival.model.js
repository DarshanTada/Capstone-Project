"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const festivalSchema = new mongoose_1.default.Schema({
    festival_name: String,
    isEnable: Boolean
}, { timestamps: true });
const Festival = mongoose_1.default.model("Festival", festivalSchema);
exports.default = Festival;
