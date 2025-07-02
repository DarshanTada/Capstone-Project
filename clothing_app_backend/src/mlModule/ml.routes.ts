import { Router } from "express";
// import multer from "multer";
import { uploadFile, askQuestion } from "./ml.controller";
import { upload } from '../utils/common/multer'

// const upload = multer({ dest: "uploads/" });
const router = Router();

router.post("/upload", upload.single("file"), async (req, res, next) => {
	try {
		await uploadFile(req, res);
	} catch (err) {
		next(err);
	}
});
router.post("/ask", async (req, res, next) => {
	try {
		await askQuestion(req, res);
	} catch (err) {
		next(err);
	}
});

export const MlRoutes = router;
