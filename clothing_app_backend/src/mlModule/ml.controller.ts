import { Request, Response } from "express";
import axios from "axios";
import fs from "fs";
import FormData from "form-data";

const baseURL = process.env.PYTHON_SERVER_URL || "http://localhost:8000"; // fallback

export const uploadFile = async (req: Request, res: Response) => {
  if (!req.file) return res.status(400).json({ error: "File is required." });

  try {
    const form = new FormData();
    form.append("file", fs.createReadStream(req.file.path));

    const response = await axios.post(`${baseURL}/upload/`, form, {
      headers: form.getHeaders(),
    });

    res.status(200).json(response.data);
    return;
  } catch (err: any) {
    console.error(err.message);
    res.status(500).json({ error: "Upload failed." });
    return;
  }
};

export const askQuestion = async (req: Request, res: Response) => {
  const { question, system_prompt, image } = req.body;

  if (!question) return res.status(400).json({ error: "Question is required." });

  try {
    const response = await axios.post(
      `${baseURL}/ask/`,
      {
        question,
        system_prompt: system_prompt || "",
        image_base64: image || null, // <-- key changed here
      },
      { timeout: 120000 }
    );
    res.status(200).json(response.data);
    return;
  } catch (err: any) {
    console.error(err);
    res.status(500).json({ error: "Query failed." });
    return;
  }
};
