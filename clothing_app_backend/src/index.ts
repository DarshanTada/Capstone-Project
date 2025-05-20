import 'dotenv/config';
import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { errorHandler } from './utils/middleware/error.middleware';
import { mongoose } from '@typegoose/typegoose';
const eFileUpload = require('express-fileupload');

(async () => {
  const mainRoutes = require('./mainRoutes');

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

  mongoose
    .connect( 
      'mongodb+srv://darshantada7:gWvTubWMosngksUV@capstone-project.esjmjci.mongodb.net/?retryWrites=true&w=majority&appName=capstone-project',
    
    )
    .then(() => {
      console.log('Connected to database!');
    })
    .catch((error) => {
      console.log('Connection failed!', error);
    });

  mongoose.set('debug', false);

  app.use(eFileUpload());
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
  // try {
  //   app.listen(port, () =>
  //     console.log(`API server started at http://localhost:${port}`)
  //   );
  // } catch (err) {
  //   console.log(err);
  // }

  var server = app.listen(port, () =>
    console.log(`API server started at http://localhost:${port}`)
  );
})();
