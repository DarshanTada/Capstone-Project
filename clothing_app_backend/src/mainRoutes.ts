import express, { Router } from 'express';

// import { AuthRoutes } from './utils/generic/auth/auth.routes';
import { UserRoutes } from './userModule/user.routes';
import { IntroRoute } from './introModule/intro.routes';
import { CategoryRoute } from './categoryModule/category.routes';
import { MlRoutes } from './mlModule/ml.routes';
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


// import { UserRoutes } from './userModule/user.routes';
// import { CafeRoutes } from './cafeModule/cafe.routes';
// import { LoyalLevelRoutes } from './loyaltyProgramModule/loyalty.routes';
// import { OffersRoutes } from './offersModule/offers.routes';
// import { TransactionRoutes } from './transactionModule/transaction.routes';
// import { editProfile } from './userModule/user.controller';
// import { FaqRoutes, FaqTopicRoutes } from './faqModule/faq.routes';
// import { LikeRoutes } from './likeModule/like.routes';
// import { PetPoojaRouter } from './petpoojaModule/petpooja.routes';
// import { AppConfigRoutes } from './appGeneralInfo/routes/appConfig.routes';
// import { EmployeeRoutes } from './adminModule/employeeModule/employee.routes';
// import { OfferRoutes } from './adminModule/offersBannersModule/offers/offer.routes';
// import { Banner } from './adminModule/offersBannersModule/banners/banners.model';
// import { BannerRoutes } from './adminModule/offersBannersModule/banners/banners.routes';
// import { TransactionAdminRoutes } from './adminModule/transaction/transaction.routes';
// import { AmenityRoutes } from './adminModule/amenities/amenities.routes';
// import { StoreRoutes } from './adminModule/store/store.routes';
// import { LoyaltyLevelRoutes } from './adminModule/loyaltyProgram/loyalty-program.routes';
// import { ReportRoutes } from './adminModule/report/report.routes';
// import { UsersRoutes } from './adminModule/user/users.routes';
// import { DashboardRoutes } from './adminModule/dashboard/dashboard.routes';
// import { ItemRoutes } from './itemModule/item.routes';
// import { WalletRouter } from './petpoojaModule/wallet.routes';
const app = express();

// // ---------------------------------- Auth Routes ----------------------------------

// // api/auth
// app.use('/auth', AuthRoutes);

// // ---------------------------------- Admin Routes ----------------------------------

// // ---------------------------------- App Routes ----------------------------------

// // api/user
app.use('/user', UserRoutes);
app.use('/intro', IntroRoute);
app.use('/category', CategoryRoute);
app.use('/ml', MlRoutes);
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


// // api/appConfig
// app.use('/appConfig', AppConfigRoutes);

// //api/cafe
// app.use('/cafe', CafeRoutes);

// //api/loyalty
// app.use('/loyalty', LoyalLevelRoutes);

// //api/offers
// app.use('/offers', OffersRoutes);

// //api/transaction
// app.use('/transaction', TransactionRoutes);

// //api/faqTopic
// app.use('/faqTopic', FaqTopicRoutes);

// //api/faq
// app.use('/faq', FaqRoutes);

// // api/like
// app.use('/like', LikeRoutes);

// // api/petpooja
// app.use('/petpooja', PetPoojaRouter);

// // api/wallet
// app.use('/wallet', WalletRouter);

// // Admin Module routes

// // api/employee
// app.use('/employee', EmployeeRoutes);

// // api/offer
// app.use('/offer', OfferRoutes);

// // api/banner
// app.use('/banner', BannerRoutes);

// // api/transaction
// app.use('/transaction', TransactionAdminRoutes);

// // api/amenity
// app.use('/amenity', AmenityRoutes);

// // api/store
// app.use('/store', StoreRoutes);

// // menu
// app.use('/loyalty-level', LoyaltyLevelRoutes);

// // menu
// app.use('/report', ReportRoutes);

// users
// app.use('/users', UsersRoutes);

// // dashboard
// app.use('/dashboard', DashboardRoutes);

// // item
// app.use('/item', ItemRoutes);

export default app;
// module.exports = app;
