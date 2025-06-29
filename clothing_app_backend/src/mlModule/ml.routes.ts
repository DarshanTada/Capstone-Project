import { Router } from "express";
import multer from "multer";
import { uploadFile, askQuestion } from "./ml.controller";

const upload = multer({ dest: "uploads/" });
const router = Router();

router.post("/upload", upload.single("file"), uploadFile);
router.post("/ask", askQuestion);

export const MlRoutes = router;
