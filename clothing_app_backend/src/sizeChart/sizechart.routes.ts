
import express from 'express';
import { upload } from '../utils/common/multer';
import {
  createSizeChart,
  getAllSizeCharts,
  deleteSizeChart,
  getMeasurementGuides,
  addMeasurementGuide
} from './sizechart.controller';


export const SizeChartRouter = express.Router();

SizeChartRouter.post('/createsizechart', upload.none(), createSizeChart);
SizeChartRouter.post('/addmeasurementguide', upload.single('image'), addMeasurementGuide);
SizeChartRouter.get('/all', getAllSizeCharts);
SizeChartRouter.delete('/deletesizechart/:id', deleteSizeChart);
SizeChartRouter.get('/measurementguides', getMeasurementGuides);

export default SizeChartRouter;
