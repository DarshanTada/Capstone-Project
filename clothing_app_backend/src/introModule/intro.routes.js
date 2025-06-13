import express from 'express';
import { createIntro } from '../introModule/intro.controller.js';

const router = express.Router();

// POST /api/intro
router.post('/intro', createIntro);

export default router;