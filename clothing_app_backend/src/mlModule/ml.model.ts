import mongoose from "mongoose";

// ML Request Types
export const ML_REQUEST_TYPES = [
  'preference_analysis',
  'style_recommendation',
  'color_analysis',
  'general_query',
  'document_upload'
];

// ML Analysis Results Schema
const mlAnalysisSchema = new mongoose.Schema({
  user_objectId: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User',
    required: true 
  },
  request_type: { 
    type: String, 
    enum: ML_REQUEST_TYPES, 
    required: true 
  },
  input_data: {
    question: { type: String },
    system_prompt: { type: String },
    image_base64: { type: String },
    additional_params: { type: mongoose.Schema.Types.Mixed }
  },
  analysis_result: {
    response: { type: String },
    confidence_score: { type: Number, min: 0, max: 1 },
    processing_time_ms: { type: Number },
    extracted_data: { type: mongoose.Schema.Types.Mixed }
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

// ML Session Schema for tracking user interactions
const mlSessionSchema = new mongoose.Schema({
  user_objectId: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User',
    required: true 
  },
  session_id: { type: String, required: true, unique: true },
  interactions: [{
    request_id: { type: mongoose.Schema.Types.ObjectId, ref: 'MLAnalysis' },
    timestamp: { type: Date, default: Date.now },
    request_type: { type: String, enum: ML_REQUEST_TYPES },
    success: { type: Boolean, default: false }
  }],
  total_requests: { type: Number, default: 0 },
  successful_requests: { type: Number, default: 0 },
  started_at: { type: Date, default: Date.now },
  last_activity: { type: Date, default: Date.now },
  is_active: { type: Boolean, default: true }
});

// Indexes for better performance
mlAnalysisSchema.index({ user_objectId: 1, created_at: -1 });
mlAnalysisSchema.index({ request_type: 1, status: 1 });
mlSessionSchema.index({ user_objectId: 1, is_active: 1 });

export const MLAnalysis = mongoose.model("MLAnalysis", mlAnalysisSchema);
export const MLSession = mongoose.model("MLSession", mlSessionSchema);

export default { MLAnalysis, MLSession };
