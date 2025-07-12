import { Request, Response } from 'express';
import CareInstruction from '../careInstructionModule/careInstruction.model';


export const createCareInstruction = async (req: Request, res: Response): Promise<void> => {
  try {
    const { fabricType, instruction } = req.body;
    const files = req.files as Record<string, Express.Multer.File[]> | undefined;

    const imageFile = files?.['image']?.[0];
    const imageBase64 = imageFile
      ? `data:${imageFile.mimetype};base64,${imageFile.buffer.toString('base64')}`
      : undefined;

    if (!fabricType || !instruction) {
      res.status(400).json({
        success: false,
        message: 'fabricType and instruction are required.',
      });
      return;
    }

    let careDoc = await CareInstruction.findOne({ fabricType });

    const newInstruction = imageBase64
      ? { instruction, image: imageBase64 }
      : { instruction };

    if (careDoc) {
      careDoc.instructions.push(newInstruction);
    } else {
      careDoc = new CareInstruction({
        fabricType,
        instructions: [newInstruction]
      });
    }

    await careDoc.save();

    res.status(201).json({
      success: true,
      message: 'Care instruction added successfully',
      data: careDoc
    });

  } catch (error: any) {
    console.error('Error creating care instruction:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};


export const getCareInstructionsByFabricType = async (req: Request, res: Response): Promise<void> => {
  try {
    const { fabricType } = req.body;

    if (!fabricType) {
      res.status(400).json({
        success: false,
        message: 'fabricType is required.',
      });
      return;
    }

    const careDoc = await CareInstruction.findOne({ fabricType });

    if (!careDoc) {
      res.status(404).json({
        success: false,
        message: `No care instructions found for fabric type: ${fabricType}`,
      });
      return;
    }

    res.status(200).json({
      success: true,
      data: careDoc,
    });

  } catch (error: any) {
    console.error('Error fetching care instructions:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};


