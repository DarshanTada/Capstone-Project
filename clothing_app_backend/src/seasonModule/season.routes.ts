import express from 'express';
import {
  createSeason,
  getAllSeasons,
  updateSeason,
  deleteSeason
} from './season.controller';

export const SeasonRoute = express.Router();

SeasonRoute.post('/createSeasons', createSeason);
SeasonRoute.get('/getSeasons', getAllSeasons);
SeasonRoute.put('/updateSeasons/:id', updateSeason);
SeasonRoute.delete('/deleteSeasons/:id', deleteSeason);

export default SeasonRoute;
