import express from 'express';
import {
  createPreference,
  getAllPreferences,
  updatePreference,
  deletePreference,
  getPreferencesByUserId
} from './preference.controller';

export const PreferenceRoute = express.Router();

PreferenceRoute.post('/createPreference', createPreference);
PreferenceRoute.get('/getPreferences', getAllPreferences);
PreferenceRoute.get('/user/:userId', getPreferencesByUserId);
PreferenceRoute.put('/updatePreference/:id', updatePreference);
PreferenceRoute.delete('/deletePreference/:id', deletePreference);

export default PreferenceRoute;
