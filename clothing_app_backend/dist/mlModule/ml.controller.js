"use strict";
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
exports.getMLStats = exports.deleteAnalysis = exports.getUserSessions = exports.getAnalysisHistory = exports.analyzeUserPreferences = exports.askQuestion = exports.uploadFile = exports.checkPythonServerHealth = void 0;
const axios_1 = __importDefault(require("axios"));
const fs_1 = __importDefault(require("fs"));
const form_data_1 = __importDefault(require("form-data"));
const mongoose_1 = __importDefault(require("mongoose"));
const preference_model_1 = __importDefault(require("../preferenceModule/preference.model"));
const ml_model_1 = require("./ml.model");
const baseURL = process.env.PYTHON_SERVER_URL || "http://localhost:8000";
const checkPythonServerHealth = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        console.log(`Checking Python server health at: ${baseURL}`);
        const response = yield axios_1.default.get(`${baseURL}/health`, { timeout: 10000 });
        res.status(200).json({
            status: "healthy",
            python_server: baseURL,
            response: response.data
        });
    }
    catch (err) {
        console.error('Python server health check failed:', {
            message: err.message,
            code: err.code,
            status: (_a = err.response) === null || _a === void 0 ? void 0 : _a.status
        });
        res.status(503).json({
            status: "unhealthy",
            python_server: baseURL,
            error: err.message,
            code: err.code
        });
    }
});
exports.checkPythonServerHealth = checkPythonServerHealth;
const uploadFile = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    if (!req.file) {
        res.status(400).json({ error: "File is required." });
        return;
    }
    try {
        const form = new form_data_1.default();
        form.append("file", fs_1.default.createReadStream(req.file.path));
        const response = yield axios_1.default.post(`${baseURL}/upload/`, form, {
            headers: form.getHeaders(),
        });
        res.status(200).json(response.data);
    }
    catch (err) {
        console.error(err.message);
        res.status(500).json({ error: "Upload failed." });
    }
});
exports.uploadFile = uploadFile;
const askQuestion = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a, _b, _c;
    const { question, system_prompt, image, user_id } = req.body;
    if (!question) {
        res.status(400).json({ error: "Question is required." });
        return;
    }
    try {
        console.log(`Making request to: ${baseURL}/ask/`);
        console.log('Request body:', {
            question,
            system_prompt: system_prompt || "",
            image_provided: !!image,
            user_id: user_id || null
        });
        const response = yield axios_1.default.post(`${baseURL}/ask/`, {
            question,
            system_prompt: system_prompt || "",
            image_base64: image || null,
            user_id: user_id || null,
        }, { timeout: 120000 });
        console.log('Response received:', response.status);
        res.status(200).json(response.data);
    }
    catch (err) {
        console.error('Error details:', {
            message: err.message,
            status: (_a = err.response) === null || _a === void 0 ? void 0 : _a.status,
            statusText: (_b = err.response) === null || _b === void 0 ? void 0 : _b.statusText,
            data: (_c = err.response) === null || _c === void 0 ? void 0 : _c.data,
            code: err.code,
            baseURL
        });
        if (err.response) {
            res.status(err.response.status || 500).json({
                error: "Query failed.",
                details: err.response.data || err.message,
                python_server_status: err.response.status
            });
        }
        else if (err.code === 'ECONNREFUSED' || err.code === 'ENOTFOUND') {
            res.status(503).json({
                error: "Python ML server is not accessible.",
                details: `Cannot connect to ${baseURL}`,
                code: err.code
            });
        }
        else {
            res.status(500).json({
                error: "Query failed.",
                details: err.message,
                code: err.code
            });
        }
    }
});
exports.askQuestion = askQuestion;
const analyzeUserPreferences = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { user_id, image_base64 } = req.body;
    if (!user_id || !image_base64) {
        res.status(400).json({ error: "user_id and image_base64 are required." });
        return;
    }
    try {
        const systemPrompt = `You are a fashion and style analysis expert. Analyze the person in the image and provide specific details about their characteristics that would help determine clothing preferences.

    CRITICAL: You MUST respond with ONLY a valid JSON object. Do not include any explanatory text before or after the JSON.

    Return EXACTLY this JSON structure with your analysis:
    {
      "gender": "male/female/other",
      "age": 25,
      "height": 170,
      "body_type": "ectomorph/mesomorph/endomorph/hourglass/pear/apple/rectangle/inverted_triangle",
      "skin_tone": "very_fair/fair/light/medium/tan/dark/very_dark",
      "style": ["casual", "formal", "sporty", "bohemian", "classic", "trendy"],
      "color_tones": ["warm", "cool", "neutral"],
      "undertone": "warm/cool/neutral"
    }

    Analysis guidelines:
    - gender: Determine from visible characteristics
    - age: Estimate age as a number
    - height: Estimate height in centimeters (e.g., 170)
    - body_type: Choose the most appropriate body type
    - skin_tone: Analyze skin color depth
    - style: List 2-3 applicable style categories from the options
    - color_tones: List applicable color temperature preferences
    - undertone: Determine warm, cool, or neutral undertones

    IMPORTANT: Return ONLY the JSON object, no other text whatsoever.`;
        const question = "Analyze this person's characteristics and return only the JSON response with their style profile.";
        const response = yield axios_1.default.post(`${baseURL}/ask/`, {
            question,
            system_prompt: systemPrompt,
            image_base64: image_base64,
            user_id: user_id,
        }, { timeout: 120000 });
        let analysisResult;
        try {
            const responseText = response.data.response || response.data;
            console.log("Raw LLaVA response:", responseText);
            let jsonString = responseText;
            const jsonMatch = responseText.match(/\{[\s\S]*\}/);
            if (jsonMatch) {
                jsonString = jsonMatch[0];
            }
            jsonString = jsonString
                .replace(/^.*?(\{)/, '$1')
                .replace(/(\}).*$/, '$1')
                .trim();
            console.log("Extracted JSON string:", jsonString);
            analysisResult = JSON.parse(jsonString);
            const requiredFields = ['gender', 'age', 'height', 'body_type', 'skin_tone', 'style', 'color_tones', 'undertone'];
            const missingFields = requiredFields.filter(field => !analysisResult.hasOwnProperty(field));
            if (missingFields.length > 0) {
                throw new Error(`Missing required fields: ${missingFields.join(', ')}`);
            }
        }
        catch (parseError) {
            console.error("Failed to parse LLaVA response:", parseError);
            console.error("Raw response:", response.data);
            analysisResult = createFallbackAnalysis(response.data.response || response.data);
            console.log("Using fallback analysis:", analysisResult);
        }
        const existingPreference = yield preference_model_1.default.findOne({ user_objectId: user_id });
        let savedPreference;
        if (existingPreference) {
            savedPreference = yield preference_model_1.default.findOneAndUpdate({ user_objectId: user_id }, Object.assign(Object.assign({}, analysisResult), { user_objectId: user_id }), { new: true });
        }
        else {
            const newPreference = new preference_model_1.default(Object.assign(Object.assign({}, analysisResult), { user_objectId: user_id }));
            savedPreference = yield newPreference.save();
        }
        try {
            const mlAnalysis = new ml_model_1.MLAnalysis({
                user_objectId: user_id,
                request_type: 'preference_analysis',
                input_data: {
                    question,
                    system_prompt: systemPrompt,
                    image_base64: image_base64.substring(0, 100) + '...',
                },
                analysis_result: {
                    response: JSON.stringify(analysisResult),
                    confidence_score: 0.8,
                    processing_time_ms: Date.now() - Date.now(),
                    extracted_data: analysisResult
                },
                status: 'completed'
            });
            yield mlAnalysis.save();
        }
        catch (logError) {
            console.error("Failed to log ML analysis:", logError);
        }
        const responseMessage = existingPreference
            ? "User preferences updated successfully"
            : "User preferences created successfully";
        res.status(existingPreference ? 200 : 201).json({
            success: true,
            data: savedPreference,
            message: responseMessage,
            analysis_details: {
                raw_response: response.data.response || response.data,
                parsed_data: analysisResult
            }
        });
    }
    catch (err) {
        console.error("Preference analysis error:", err);
        res.status(500).json({ error: "Failed to analyze user preferences." });
        return;
    }
});
exports.analyzeUserPreferences = analyzeUserPreferences;
function createFallbackAnalysis(responseText) {
    console.log("Creating fallback analysis from:", responseText);
    const defaultAnalysis = {
        gender: "other",
        age: 25,
        height: 170,
        body_type: "rectangle",
        skin_tone: "medium",
        style: ["casual"],
        color_tones: ["neutral"],
        undertone: "neutral"
    };
    try {
        const text = responseText.toLowerCase();
        if (text.includes("male") && !text.includes("female")) {
            defaultAnalysis.gender = "male";
        }
        else if (text.includes("female") && !text.includes("male")) {
            defaultAnalysis.gender = "female";
        }
        if (text.includes("inverted triangle")) {
            defaultAnalysis.body_type = "inverted_triangle";
        }
        else if (text.includes("pear") || text.includes("triangle")) {
            defaultAnalysis.body_type = "pear";
        }
        else if (text.includes("apple")) {
            defaultAnalysis.body_type = "apple";
        }
        else if (text.includes("hourglass")) {
            defaultAnalysis.body_type = "hourglass";
        }
        else if (text.includes("rectangle")) {
            defaultAnalysis.body_type = "rectangle";
        }
        else if (text.includes("ectomorph")) {
            defaultAnalysis.body_type = "ectomorph";
        }
        else if (text.includes("mesomorph")) {
            defaultAnalysis.body_type = "mesomorph";
        }
        else if (text.includes("endomorph")) {
            defaultAnalysis.body_type = "endomorph";
        }
        const styles = [];
        if (text.includes("casual"))
            styles.push("casual");
        if (text.includes("formal"))
            styles.push("formal");
        if (text.includes("sporty") || text.includes("athletic"))
            styles.push("sporty");
        if (text.includes("bohemian") || text.includes("boho"))
            styles.push("bohemian");
        if (text.includes("classic"))
            styles.push("classic");
        if (text.includes("trendy") || text.includes("modern"))
            styles.push("trendy");
        if (styles.length > 0) {
            defaultAnalysis.style = styles.slice(0, 3);
        }
        const colorTones = [];
        if (text.includes("warm"))
            colorTones.push("warm");
        if (text.includes("cool"))
            colorTones.push("cool");
        if (text.includes("neutral"))
            colorTones.push("neutral");
        if (colorTones.length > 0) {
            defaultAnalysis.color_tones = colorTones;
            defaultAnalysis.undertone = colorTones[0];
        }
        const ageMatch = text.match(/(\d{1,2})\s*(years?\s*old|age)/);
        if (ageMatch) {
            const age = parseInt(ageMatch[1]);
            if (age >= 10 && age <= 100) {
                defaultAnalysis.age = age;
            }
        }
        const heightMatch = text.match(/(\d{3})\s*(cm|centimeter)/);
        if (heightMatch) {
            const height = parseInt(heightMatch[1]);
            if (height >= 140 && height <= 220) {
                defaultAnalysis.height = height;
            }
        }
    }
    catch (error) {
        console.error("Error in fallback analysis:", error);
    }
    return defaultAnalysis;
}
const getAnalysisHistory = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { userId } = req.params;
        const { type, limit = 10, page = 1 } = req.query;
        if (!userId) {
            res.status(400).json({ success: false, message: 'userId is required in params.' });
            return;
        }
        const filter = { user_objectId: userId };
        if (type && ml_model_1.ML_REQUEST_TYPES.includes(type)) {
            filter.request_type = type;
        }
        const skip = (Number(page) - 1) * Number(limit);
        const analyses = yield ml_model_1.MLAnalysis.find(filter)
            .sort({ created_at: -1 })
            .limit(Number(limit))
            .skip(skip)
            .populate('user_objectId', 'name email');
        const total = yield ml_model_1.MLAnalysis.countDocuments(filter);
        res.status(200).json({
            success: true,
            data: analyses,
            pagination: {
                total,
                page: Number(page),
                limit: Number(limit),
                totalPages: Math.ceil(total / Number(limit))
            }
        });
    }
    catch (error) {
        console.error('Get analysis history error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getAnalysisHistory = getAnalysisHistory;
const getUserSessions = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { userId } = req.params;
        if (!userId) {
            res.status(400).json({ success: false, message: 'userId is required in params.' });
            return;
        }
        const sessions = yield ml_model_1.MLSession.find({ user_objectId: userId })
            .sort({ last_activity: -1 })
            .populate('interactions.request_id');
        res.status(200).json({
            success: true,
            data: sessions
        });
    }
    catch (error) {
        console.error('Get user sessions error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getUserSessions = getUserSessions;
const deleteAnalysis = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { id } = req.params;
        if (!id) {
            res.status(400).json({ success: false, message: 'Analysis ID is required.' });
            return;
        }
        const deletedAnalysis = yield ml_model_1.MLAnalysis.findByIdAndDelete(id);
        if (!deletedAnalysis) {
            res.status(404).json({ success: false, message: 'Analysis record not found.' });
            return;
        }
        res.status(200).json({
            success: true,
            message: 'Analysis record deleted successfully'
        });
    }
    catch (error) {
        console.error('Delete analysis error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.deleteAnalysis = deleteAnalysis;
const getMLStats = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { userId } = req.query;
        let matchFilter = {};
        if (userId) {
            matchFilter.user_objectId = new mongoose_1.default.Types.ObjectId(userId);
        }
        const stats = yield ml_model_1.MLAnalysis.aggregate([
            { $match: matchFilter },
            {
                $group: {
                    _id: "$request_type",
                    count: { $sum: 1 },
                    avgProcessingTime: { $avg: "$analysis_result.processing_time_ms" },
                    successRate: {
                        $avg: {
                            $cond: [{ $eq: ["$status", "completed"] }, 1, 0]
                        }
                    }
                }
            }
        ]);
        const totalRequests = yield ml_model_1.MLAnalysis.countDocuments(matchFilter);
        const completedRequests = yield ml_model_1.MLAnalysis.countDocuments(Object.assign(Object.assign({}, matchFilter), { status: "completed" }));
        res.status(200).json({
            success: true,
            data: {
                totalRequests,
                completedRequests,
                overallSuccessRate: totalRequests > 0 ? completedRequests / totalRequests : 0,
                typeStats: stats
            }
        });
    }
    catch (error) {
        console.error('Get ML stats error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
});
exports.getMLStats = getMLStats;
