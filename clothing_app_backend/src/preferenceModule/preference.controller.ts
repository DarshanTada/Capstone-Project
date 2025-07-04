import { Request, Response } from 'express';
import Preference from './preference.model';
import dotenv from "dotenv";
import { upload } from "../utils/common/multer";

dotenv.config();

// Create Preference
export const createPreference = [
  upload.none(),
  async (req: Request, res: Response): Promise<void> => {
    try {
      const data = req.body;

      // Required field check
      if (!data.user_objectId) {
        res.status(400).json({ success: false, message: 'user_objectId is required.' });
        return;
      }

      // Convert string arrays (if sent as comma-separated string) to array
      const parseArrayFields = ['style', 'occasion', 'festivals', 'color_tones'];
      parseArrayFields.forEach((key) => {
        if (data[key] && typeof data[key] === 'string') {
          data[key] = data[key].split(',').map((item: string) => item.trim());
        }
      });

      const newPref = new Preference(data);
      await newPref.save();

      res.status(201).json({ success: true, data: newPref });
    } catch (error: any) {
      console.error('Create Preference Error:', error);
      res.status(500).json({ success: false, message: error.message });
    }
  }
];

// Get All Preferences
export const getAllPreferences = async (_req: Request, res: Response): Promise<void> => {
  try {
    const prefs = await Preference.find();
    res.status(200).json({ success: true, data: prefs });
  } catch (error: any) {
    console.error('Get Preferences Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Update Preference
export const updatePreference = [
  upload.none(),
  async (req: Request, res: Response): Promise<void> => {
    try {
      const { id } = req.params;
      const data = req.body;

      // Handle comma-separated arrays
      const parseArrayFields = ['style', 'occasion', 'festivals', 'color_tones'];
      parseArrayFields.forEach((key) => {
        if (data[key] && typeof data[key] === 'string') {
          data[key] = data[key].split(',').map((item: string) => item.trim());
        }
      });

      const updated = await Preference.findByIdAndUpdate(id, data, { new: true });

      if (!updated) {
        res.status(404).json({ success: false, message: 'Preference not found.' });
        return;
      }

      res.status(200).json({ success: true, data: updated });
    } catch (error: any) {
      console.error('Update Preference Error:', error);
      res.status(500).json({ success: false, message: error.message });
    }
  }
];

// Delete Preference
export const deletePreference = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const deleted = await Preference.findByIdAndDelete(id);
    if (!deleted) {
      res.status(404).json({ success: false, message: 'Preference not found.' });
      return;
    }

    res.status(200).json({ success: true, message: 'Preference deleted.' });
  } catch (error: any) {
    console.error('Delete Preference Error:', error);
    res.status(500).json({ success: false, message: error.message });
  }
};
