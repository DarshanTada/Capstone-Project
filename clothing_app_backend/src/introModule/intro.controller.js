import express from 'express';
import multer from 'multer';
import fs from 'fs';
import path from 'path';
import Intro from './intro.model';



const router = express.Router();
// Multer config for temporary memory storage (not saving to disk)
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

export const createIntro = async (req, res) => {
  upload.fields([{ name: "images", maxCount: 10 }])(req, res, async (err) => {
    if (err) {
      console.error("Multer Error:", err);
      return res.status(400).json({ success: false, message: err.message });
    }

    const { intro_title, intro_description } = req.body;

    const imageFiles = req.files["images"] || [];

    const base64Images = imageFiles.map(file =>
      `data:${file.mimetype};base64,${file.buffer.toString("base64")}`
    );

    try {
      const newIntro = new Intro({
        intro_title,
        intro_description,
        images: base64Images,
      });

      await newIntro.save();

      res.status(201).json({ success: true, data: newIntro });
    } catch (error) {
      console.error("Error saving intro:", error);
      res.status(500).json({ success: false, message: error.message });
    }
  });
};
