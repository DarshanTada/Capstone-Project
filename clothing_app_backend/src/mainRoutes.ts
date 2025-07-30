import express, { Router } from 'express';

// import { AuthRoutes } from './utils/generic/auth/auth.routes';
import { UserRoutes } from './userModule/user.routes';
import { IntroRoute } from './introModule/intro.routes';
import { CategoryRoute } from './categoryModule/category.routes';
import { MlRouter } from './mlModule/ml.routes';
import { SeasonRoute } from './seasonModule/season.routes';
import { PreferenceRoute } from './preferenceModule/preference.routes';
import { FestivalRouter } from './festivalModule/festival.routes';
import { SubCategoryRoute } from './subCategoryModule/subCategory.routes';
import { CareInstructorRouter } from './careInstructionModule/careInstruction.router';
import { ProductRouter } from './productModule/product.routes';
import { BannerRouter } from './bannerModule/banner.router';
import { AddressRouter } from './addressModule/address.router';
import { ContactUsRouter } from './contactUs/contactUs.routes';
import { HomeRouter } from './homeModule/home.routes';
import { SizeChartRouter } from './sizeChart/sizechart.routes';
import { OrderRouter } from './orderModule/order.routes';
import { CartRouter } from './cartModel/cart.routes';

const app = express();

app.use('/user', UserRoutes);
app.use('/intro', IntroRoute);
app.use('/category', CategoryRoute);
app.use('/ml', MlRouter);
app.use('/seasons', SeasonRoute);
app.use('/preferences', PreferenceRoute);
app.use('/festival', FestivalRouter);
app.use('/subCategory', SubCategoryRoute);
app.use('/careInstruction', CareInstructorRouter);
app.use('/product', ProductRouter);
app.use('/banner', BannerRouter);
app.use('/address', AddressRouter);
app.use('/contactUs', ContactUsRouter);
app.use('/home', HomeRouter);
app.use('/sizechart', SizeChartRouter);
app.use('/order', OrderRouter);
app.use('/cart', CartRouter);


export default app;

