import { Router } from "express";
import { uploadFile, askQuestion } from "./ml.controller";
import { upload } from '../utils/common/multer'

const router = Router();

router.post("/upload", upload.single("file"), async (req, res, next) => {
  try {
    await uploadFile(req, res);
  } catch (err) {
    next(err);
  }
});

// Accepts JSON body: { question, system_prompt, image }
router.post("/ask", async (req, res, next) => {
  try {
    await askQuestion(req, res);
  } catch (err) {
    next(err);
  }
});

export const MlRoutes = router;
