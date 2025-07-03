import express from 'express';
import {
  createFestival,
  getAllFestivals,
  updateFestival,
  deleteFestival
} from './festival.controller';

export const FestivalRouter = express.Router();

FestivalRouter.post('/createFestivals', createFestival);
FestivalRouter.get('/getFestivals', getAllFestivals);
FestivalRouter.put('/updateFestivals/:id', updateFestival);
FestivalRouter.delete('/deleteFestivals/:id', deleteFestival);

export default FestivalRouter;