import express from 'express';
import { getHomeData } from './home.controller';

export const HomeRouter = express.Router();

// Home API
HomeRouter.get('/home', getHomeData);


export default HomeRouter;