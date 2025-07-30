"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.relationProfileSchema = void 0;
const mongoose_1 = __importDefault(require("mongoose"));
exports.relationProfileSchema = new mongoose_1.default.Schema({
    user: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: "User",
        required: true,
    },
    preference: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: "Preference",
        required: true,
        unique: true,
    },
    isActive: {
        type: Boolean,
        default: false,
    }
}, {
    timestamps: true,
});
const RelationProfile = mongoose_1.default.model("RelationProfile", exports.relationProfileSchema);
exports.default = RelationProfile;
