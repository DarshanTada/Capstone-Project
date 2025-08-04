import express from 'express';
import { uploadCareImage, upload } from '../utils/common/multer';
import { createCareInstruction, getCareInstructionsByFabricType } from '../careInstructionModule/careInstruction.controller';

export const CareInstructorRouter = express.Router();

CareInstructorRouter.post('/create-care-instructions', uploadCareImage, createCareInstruction);
CareInstructorRouter.post(
  '/get-care-instructions/by-fabric',
  upload.none(),
  getCareInstructionsByFabricType
);

export default CareInstructorRouter;