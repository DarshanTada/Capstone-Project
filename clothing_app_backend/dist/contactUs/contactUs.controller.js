"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteInquiry = exports.getInquiries = exports.sendInquiry = exports.replyInquiry = void 0;
const sendMail_1 = require("../utils/sendMail");
const contactUs_model_1 = __importDefault(require("./contactUs.model"));
const replyInquiry = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { id } = req.params;
        const { subject, text } = req.body;
        const inquiry = yield contactUs_model_1.default.findById(id);
        if (!inquiry) {
            res.status(404).json({ success: false, message: 'Inquiry not found.' });
            return;
        }
        if (!inquiry.email || typeof inquiry.email !== 'string') {
            res.status(400).json({ success: false, message: 'Inquiry email is missing or invalid.' });
            return;
        }
        yield (0, sendMail_1.sendMail)({
            to: inquiry.email,
            subject: subject || `Reply to your inquiry: ${inquiry.subject}`,
            text: text || 'Thank you for contacting us. Here is our reply.',
        });
        res.status(200).json({ success: true, message: 'Reply sent to user.' });
    }
    catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.replyInquiry = replyInquiry;
const sendInquiry = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { name, email, category, subject, message } = req.body;
        if (!name || !email || !category || !subject || !message) {
            res.status(400).json({ success: false, message: 'All fields are required.' });
            return;
        }
        const inquiry = new contactUs_model_1.default({ name, email, category, subject, message });
        yield inquiry.save();
        const { sendMail } = yield Promise.resolve().then(() => __importStar(require('../utils/sendMail')));
        yield sendMail({
            to: email,
            subject: `Thank you for your inquiry: ${subject}`,
            text: `Hi ${name},\n\nWe received your inquiry regarding "${category}".\n\n${message}\n\nWe will get back to you soon!\n\nBest,\nYoloChic Team`,
        });
        res.status(201).json({ success: true, data: inquiry });
    }
    catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.sendInquiry = sendInquiry;
const getInquiries = (_req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const inquiries = yield contactUs_model_1.default.find().sort({ createdAt: -1 });
        res.status(200).json({ success: true, data: inquiries });
    }
    catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getInquiries = getInquiries;
const deleteInquiry = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { id } = req.params;
        const deleted = yield contactUs_model_1.default.findByIdAndDelete(id);
        if (!deleted) {
            res.status(404).json({ success: false, message: 'Inquiry not found.' });
            return;
        }
        res.status(200).json({ success: true, message: 'Inquiry deleted.' });
    }
    catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.deleteInquiry = deleteInquiry;
