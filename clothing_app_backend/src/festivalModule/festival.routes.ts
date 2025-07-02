import express from 'express';
import {
  createFestival,
  getAllFestivals,
  updateFestival,
  deleteFestival
} from './festival.controller';

export const router = express.Router();

router.post('/createFestivals', createFestival);
router.get('/getFestivals', getAllFestivals);
router.put('/updateFestivals/:id', updateFestival);
router.delete('/deleteFestivals/:id', deleteFestival);

export default router;