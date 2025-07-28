import { Request, Response } from 'express';
import { SizeChart, MeasurementGuide } from './sizechart.model';

// Create Size Chart
export const createSizeChart = async (req: Request, res: Response): Promise<void> => {
  try {
    // If using multer, req.body will have fields and req.file/req.files will have files
    // Parse sizes and measurements if sent as JSON string in form-data
    let sizes = req.body.sizes;
    if (typeof sizes === 'string') {
      try {
        sizes = JSON.parse(sizes);
      } catch {
        sizes = [];
      }
    }
    // category should be an array of ObjectIds
    let category = req.body.category;
    if (typeof category === 'string') {
      try {
        category = JSON.parse(category);
      } catch {
        category = [category];
      }
    }
    const sizeChartData = {
      gender: req.body.gender,
      category,
      fitType: req.body.fitType,
      sizeRange: req.body.sizeRange,
      sizes,
      measurementGuide: req.body.measurementGuide,
    };
    const sizeChart = await SizeChart.create(sizeChartData);
    res.status(200).json({ success: true, data: sizeChart });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get All Size Charts
export const getAllSizeCharts = async (_req: Request, res: Response): Promise<void> => {
  try {
    const sizeCharts = await SizeChart.find().populate('measurementGuide');
    res.status(200).json({ success: true, data: sizeCharts });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Delete Size Chart
export const deleteSizeChart = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const deleted = await SizeChart.findByIdAndDelete(id);
    if (!deleted) {
      res.status(404).json({ success: false, message: 'Size chart not found.' });
      return;
    }
    res.status(200).json({ success: true, message: 'Size chart deleted.' });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get Measurement Guides
export const getMeasurementGuides = async (_req: Request, res: Response): Promise<void> => {
  try {
    const guides = await MeasurementGuide.find();
    res.status(200).json({ success: true, data: guides });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Add Measurement Guide
export const addMeasurementGuide = async (req: Request, res: Response): Promise<void> => {
  try {
    // If using multer, req.file contains the uploaded image
    const { type, instructions } = req.body;
    let parsedInstructions = instructions;
    if (typeof instructions === 'string') {
      try {
        parsedInstructions = JSON.parse(instructions);
      } catch {
        parsedInstructions = [];
      }
    }
    const imageBuffer = req.file ? req.file.buffer : undefined;
    const guide = await MeasurementGuide.create({
      type,
      image: imageBuffer,
      instructions: parsedInstructions,
    });
    res.status(200).json({ success: true, data: guide });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};
