import { Request, Response } from 'express';
import Intro from './intro.model';
import multer from 'multer';

const storage = multer.memoryStorage();
const upload = multer({ storage });

export const uploadIntroImage = upload.fields([{ name: 'image', maxCount: 1 }]);

export const createIntro = async (req: Request, res: Response): Promise<void> => {
  console.error('Adeesh First');
  try {

    const { title, intro_description } = req.body;

    const files = req.files as Record<string, Express.Multer.File[]> | undefined;
    const imageBuffer = files?.['image']?.[0]?.buffer;
    console.error(imageBuffer);

    if (!title || !intro_description || !imageBuffer) {
      res.status(400).json({
        success: false,
        message: 'Title, intro description, and an image file are required.',
      });
      return;
    }

    const newIntro = new Intro({
      title,
      intro_description,
      image: imageBuffer,
    });

    await newIntro.save();

    res.status(201).json({ success: true, data: newIntro });
  } catch (error: any) {
    console.error('Error saving intro:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};



// Get All Categories (with image as base64)
export const getAllIntro = async (_req: Request, res: Response): Promise<void> => {
  try {
    const categories = await Intro.find();

    const formatted = categories.map((cat) => ({
      _id: cat._id,
      title: cat.title,
      intro_description: cat.intro_description,
      image: cat.image?.toString('base64') || null,
    }));

    res.status(200).json({ success: true, data: formatted });
  } catch (error: any) {
    console.error('Get Introduction Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};