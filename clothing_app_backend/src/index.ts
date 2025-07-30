import 'dotenv/config';
import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { errorHandler } from './utils/middleware/error.middleware';
import mongoose from 'mongoose'; // Use regular mongoose instead of typegoose
// const eFileUpload = require('express-fileupload');
import mainRoutes from './mainRoutes';

(async () => {
  try {
    const app: Application = express();

    app.use(cors({ origin: '*' }));
    app.use(helmet());
    app.use(express.json({ limit: '5000mb' }));
    app.use(
      express.urlencoded({
        limit: '5000mb',
        extended: true,
        parameterLimit: 50000000,
      })
    );

    const MONGO_URI = process.env.MONGO_URI as string;

    if (!MONGO_URI) {
      console.error('MONGO_URI environment variable is not defined!');
      console.log('Available environment variables:', Object.keys(process.env));
      process.exit(1);
    }

    console.log('Attempting to connect to MongoDB...');

    mongoose
      .connect(MONGO_URI)
      .then(() => {
        console.log('Connected to database!');
      })
      .catch((error) => {
        console.log('Connection failed!', error);
        process.exit(1);
      });

    mongoose.set('debug', false);

    // app.use(eFileUpload());
    app.use('/status', (req, res, next) => {
      res.send({ message: 'Success' });
    });

    app.use('/api', mainRoutes);

    // 
      app.get('/', (req, res) => {
        res.send('API is running!');
      });

    app.use(errorHandler);

    const port = process.env.PORT || 3001;

    var server = app.listen(port, () =>
      console.log(`API server started at http://localhost:${port}`)
    );
  } catch (error) {
    console.error('Server startup error:', error);
    process.exit(1);
  }
})();
