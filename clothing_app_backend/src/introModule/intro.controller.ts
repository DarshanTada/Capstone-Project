import { Request, Response } from 'express';
import Intro from './intro.model';
import multer from 'multer';

const storage = multer.memoryStorage();
const upload = multer({ storage });

export const uploadIntroImage = upload.fields([{ name: 'image', maxCount: 1 }]);

export const createIntro = async (req: Request, res: Response): Promise<void> => {
  console.error('Adeesh First');
  try {
    console.log('BODY:', req.body);
    console.log('FILES:', req.files);

    const { title, intro_description } = req.body;

    const files = req.files as Record<string, Express.Multer.File[]> | undefined;
    const imageBuffer = files?.['image']?.[0]?.buffer;
    console.error(imageBuffer);
    if (!title || !intro_description || !imageBuffer) {
      console.error('Adeesh Second');
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
    console.error('Adeesh');
    console.error('Error saving intro:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};
