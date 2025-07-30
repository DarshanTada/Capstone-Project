"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.REASONS = void 0;
const mongoose_1 = __importDefault(require("mongoose"));
exports.REASONS = {
    GENERAL: "General Inquiry",
    ORDER_SUPPORT: "Order Suppor",
    TECHNICAL_ISSUE: "Technical Issue",
    RETURN_EXCHANGE: "Return Exchange",
    ACCOUNT_HELP: "Account Help",
    FEEDBACK: "Feedback"
};
const contactUsSchema = new mongoose_1.default.Schema({
    name: String,
    email: String,
    category: {
        type: String,
        enum: Object.values(exports.REASONS),
        default: exports.REASONS.GENERAL,
        required: true,
    },
    subject: String,
    message: String
}, { timestamps: true });
const ContactUs = mongoose_1.default.model("ContactUs", contactUsSchema);
exports.default = ContactUs;
