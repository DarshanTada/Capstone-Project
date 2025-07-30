"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const seasonSchema = new mongoose_1.default.Schema({
    season_name: String,
    isEnable: Boolean
}, { timestamps: true });
const Season = mongoose_1.default.model("Season", seasonSchema);
exports.default = Season;
