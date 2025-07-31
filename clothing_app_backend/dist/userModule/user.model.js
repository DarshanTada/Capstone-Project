"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const userSchema = new mongoose_1.default.Schema({
    phone_number: {
        type: String,
    },
    email: {
        type: String,
    },
    relation: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: "Relation",
    },
    role: {
        type: String,
        enum: ["user", "admin", "super_admin", "product_manager", "order_manager", "marketing_manager"],
        default: "user",
    },
    token: {
        type: String,
    },
    password: {
        type: String,
    },
    preference: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: "Preference",
    },
}, {
    timestamps: true,
});
const User = mongoose_1.default.model("User", userSchema);
exports.default = User;
