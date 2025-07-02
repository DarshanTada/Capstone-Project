import { Request, Response } from 'express';
import Season from '../seasonModule/season.model';
import dotenv from "dotenv";
import { upload } from "../utils/common/multer";

dotenv.config();

// Create Season
export const createSeason = [
  upload.none(), // Handles form-data with only text fields
  async (req: Request, res: Response): Promise<void> => { 
    try {
        const { season_name, isEnable } = req.body;

        if (!season_name || isEnable === undefined) {
        res.status(400).json({ success: false, message: 'season_name and isEnable are required.' });
        return;
        }

        const newSeason = new Season({ season_name, isEnable });
        await newSeason.save();

        res.status(201).json({ success: true, data: newSeason });
    } catch (error: any) {
        console.error('Create Season Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
}
];

// Get All Seasons
export const getAllSeasons = async (_req: Request, res: Response): Promise<void> => {
    try {
        const seasons = await Season.find();
        res.status(200).json({ success: true, data: seasons });
    } catch (error: any) {
        console.error('Get Seasons Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
};

// Update Season
export const updateSeason = [
  upload.none(),
  async (req: Request, res: Response): Promise<void> => {
    try {
        const { id } = req.params;
        const { season_name, isEnable } = req.body;

        const updatedSeason = await Season.findByIdAndUpdate(
        id,
        { season_name, isEnable },
        { new: true }
        );

        if (!updatedSeason) {
        res.status(404).json({ success: false, message: 'Season not found.' });
        return;
        }

        res.status(200).json({ success: true, data: updatedSeason });
    } catch (error: any) {
        console.error('Update Season Error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
    }
];

// Delete Season
export const deleteSeason = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const deletedSeason = await Season.findByIdAndDelete(id);
    if (!deletedSeason) {
      res.status(404).json({ success: false, message: 'Season not found.' });
      return;
    }

    res.status(200).json({ success: true, message: 'Season deleted.' });
  } catch (error: any) {
    console.error('Delete Season Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};
