import express from 'express';
import {
  createPreference,
  getAllPreferences,
  updatePreference,
  deletePreference
} from './preference.controller';

export const PreferenceRoute = express.Router();

PreferenceRoute.post('/createPreference', createPreference);
PreferenceRoute.get('/getPreferences', getAllPreferences);
PreferenceRoute.put('/updatePreference/:id', updatePreference);
PreferenceRoute.delete('/deletePreference/:id', deletePreference);

export default PreferenceRoute;
