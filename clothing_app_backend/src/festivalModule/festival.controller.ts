import { Request, Response, NextFunction } from 'express';
import Festival from '../festivalModule/festival.model';
import dotenv from "dotenv";

dotenv.config()

// Create Festival
export const createFestival = async (req: Request, res: Response): Promise<void> => {
  try {
    const { festival_name, isEnable } = req.body;

    if (!festival_name || isEnable === undefined) {
      res.status(400).json({ success: false, message: 'festival_name and isEnable are required.' });
      return;
    }

    const newFestival = new Festival({ festival_name, isEnable });
    await newFestival.save();

    res.status(201).json({ success: true, data: newFestival });
  } catch (error: any) {
    console.error('Create Festival Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get All Festivals
export const getAllFestivals = async (_req: Request, res: Response): Promise<void> => {
  try {
    const festivals = await Festival.find();
    res.status(200).json({ success: true, data: festivals });
  } catch (error: any) {
    console.error('Get Festivals Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Update Festival
export const updateFestival = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { festival_name, isEnable } = req.body;

    const updatedFestival = await Festival.findByIdAndUpdate(
      id,
      { festival_name, isEnable },
      { new: true }
    );

    if (!updatedFestival) {
      res.status(404).json({ success: false, message: 'Festival not found.' });
      return;
    }

    res.status(200).json({ success: true, data: updatedFestival });
  } catch (error: any) {
    console.error('Update Festival Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Delete Festival
export const deleteFestival = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const deleted = await Festival.findByIdAndDelete(id);
    if (!deleted) {
      res.status(404).json({ success: false, message: 'Festival not found.' });
      return;
    }

    res.status(200).json({ success: true, message: 'Festival deleted.' });
  } catch (error: any) {
    console.error('Delete Festival Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};