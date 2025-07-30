"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MLSession = exports.MLAnalysis = exports.ML_REQUEST_TYPES = void 0;
const mongoose_1 = __importDefault(require("mongoose"));
exports.ML_REQUEST_TYPES = [
    'preference_analysis',
    'style_recommendation',
    'color_analysis',
    'general_query',
    'document_upload'
];
const mlAnalysisSchema = new mongoose_1.default.Schema({
    user_objectId: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    request_type: {
        type: String,
        enum: exports.ML_REQUEST_TYPES,
        required: true
    },
    input_data: {
        question: { type: String },
        system_prompt: { type: String },
        image_base64: { type: String },
        additional_params: { type: mongoose_1.default.Schema.Types.Mixed }
    },
    analysis_result: {
        response: { type: String },
        confidence_score: { type: Number, min: 0, max: 1 },
        processing_time_ms: { type: Number },
        extracted_data: { type: mongoose_1.default.Schema.Types.Mixed }
    },
    status: {
        type: String,
        enum: ['pending', 'processing', 'completed', 'failed'],
        default: 'pending'
    },
    error_message: { type: String },
    created_at: { type: Date, default: Date.now },
    updated_at: { type: Date, default: Date.now }
});
const mlSessionSchema = new mongoose_1.default.Schema({
    user_objectId: {
        type: mongoose_1.default.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    session_id: { type: String, required: true, unique: true },
    interactions: [{
            request_id: { type: mongoose_1.default.Schema.Types.ObjectId, ref: 'MLAnalysis' },
            timestamp: { type: Date, default: Date.now },
            request_type: { type: String, enum: exports.ML_REQUEST_TYPES },
            success: { type: Boolean, default: false }
        }],
    total_requests: { type: Number, default: 0 },
    successful_requests: { type: Number, default: 0 },
    started_at: { type: Date, default: Date.now },
    last_activity: { type: Date, default: Date.now },
    is_active: { type: Boolean, default: true }
});
mlAnalysisSchema.index({ user_objectId: 1, created_at: -1 });
mlAnalysisSchema.index({ request_type: 1, status: 1 });
mlSessionSchema.index({ user_objectId: 1, is_active: 1 });
exports.MLAnalysis = mongoose_1.default.model("MLAnalysis", mlAnalysisSchema);
exports.MLSession = mongoose_1.default.model("MLSession", mlSessionSchema);
exports.default = { MLAnalysis: exports.MLAnalysis, MLSession: exports.MLSession };
