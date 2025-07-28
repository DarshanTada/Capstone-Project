import express from 'express';
import { upload } from '../utils/common/multer';
import { 
  uploadFile, 
  askQuestion, 
  analyzeUserPreferences,
  getAnalysisHistory,
  getUserSessions,
  deleteAnalysis,
  getMLStats
} from './ml.controller';

export const MlRouter = express.Router();

// Core ML functionality
MlRouter.post('/upload', upload.single("file"), uploadFile);
MlRouter.post('/ask', askQuestion);
MlRouter.post('/analyze-preferences', analyzeUserPreferences);

// Analysis management
MlRouter.get('/analysis-history/:userId', getAnalysisHistory);
MlRouter.get('/sessions/:userId', getUserSessions);
MlRouter.delete('/analysis/:id', deleteAnalysis);
MlRouter.get('/stats', getMLStats);

export default MlRouter;
