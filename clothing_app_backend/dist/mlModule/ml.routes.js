"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MlRouter = void 0;
const express_1 = __importDefault(require("express"));
const multer_1 = require("../utils/common/multer");
const ml_controller_1 = require("./ml.controller");
exports.MlRouter = express_1.default.Router();
exports.MlRouter.get('/health', ml_controller_1.checkPythonServerHealth);
exports.MlRouter.post('/upload', multer_1.upload.single("file"), ml_controller_1.uploadFile);
exports.MlRouter.post('/ask', ml_controller_1.askQuestion);
exports.MlRouter.post('/analyze-preferences', ml_controller_1.analyzeUserPreferences);
exports.MlRouter.get('/analysis-history/:userId', ml_controller_1.getAnalysisHistory);
exports.MlRouter.get('/sessions/:userId', ml_controller_1.getUserSessions);
exports.MlRouter.delete('/analysis/:id', ml_controller_1.deleteAnalysis);
exports.MlRouter.get('/stats', ml_controller_1.getMLStats);
exports.default = exports.MlRouter;
