import express, { Router } from 'express';

// import { AuthRoutes } from './utils/generic/auth/auth.routes';
import { UserRoutes } from './userModule/user.routes';
import { IntroRoute } from './introModule/intro.routes';
import { CategoryRouter } from './categoryModule/category.routes';
import { LlavaRoute } from './llavaModule/llava.routes'

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
app.use('/category', CategoryRouter)
app.use('/llava', LlavaRoute)

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

module.exports = app;
