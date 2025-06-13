// import express from "express";
// import { createIntro } from './intro.controller';

// export const IntroRoute = express.Router();

// IntroRoute.post('/createintro', createIntro);

// export default IntroRoute;

import express from 'express';
import { createIntro, uploadIntroImage } from '../introModule/intro.controller';

export const IntroRoute = express.Router();

IntroRoute.post('/intro', uploadIntroImage, createIntro);

     
export default IntroRoute;
