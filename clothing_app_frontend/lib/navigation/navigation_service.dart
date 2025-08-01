import 'package:clothing_app_frontend/authModule/screens/capture_face_screen.dart';
import 'package:clothing_app_frontend/authModule/screens/capture_body_screen.dart';
import 'package:clothing_app_frontend/authModule/screens/phone_number_screen.dart';
import 'package:clothing_app_frontend/authModule/screens/verify_otp_screen2.dart';
import 'package:clothing_app_frontend/authModule/screens/intro_screen_1.dart';
import 'package:clothing_app_frontend/authModule/screens/intro_screen_2.dart';
import 'package:clothing_app_frontend/authModule/screens/intro_screen_3.dart';
import 'package:clothing_app_frontend/categoryModule/screens/product_detail_screen.dart';
import 'package:clothing_app_frontend/homeModule/screens/category_relation_screen.dart';
import 'package:clothing_app_frontend/checkoutModule/screens/checkout_screen.dart';
import 'package:clothing_app_frontend/addressModule/screens/addresses_screen.dart';
import 'package:clothing_app_frontend/orderHistoryModule/screens/order_history_screen.dart';
import 'package:clothing_app_frontend/homeModule/widgets/size_chart_screen.dart';
import 'package:clothing_app_frontend/preferenceModule/screen/preference_screen.dart';
import 'package:clothing_app_frontend/cartModule/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/common_widgets/bottom_nav_bar.dart';
import 'arguments.dart';
import 'routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // Intro/Onboarding Screens
    case NamedRoute.onBoardingScreen1:
      return _getPageRoute(const IntroScreen1());

    case NamedRoute.onBoardingScreen2:
      return _getPageRoute(const IntroScreen2());

    case NamedRoute.onBoardingScreen3:
      return _getPageRoute(const IntroScreen3());

    case NamedRoute.phoneNumberScreen:
      return _getPageRoute(const PhoneNumberScreen());

    case NamedRoute.sizeChartScreen:
      return _getPageRoute(const SizeChartScreen());

    case NamedRoute.preferenceScreen:
      final args = settings.arguments as PreferenceScreenArguments?;
      return _getPageRoute(PreferenceScreen());
    case NamedRoute.checkoutScreen:
      return _getPageRoute(const CheckoutScreen());

    case NamedRoute.addressesScreen:
      return _getPageRoute(const AddressesScreen());

    case NamedRoute.orderHistoryScreen:
      return _getPageRoute(const OrderHistoryScreen());

    case NamedRoute.myCartScreen:
      return _getPageRoute(const MyCartScreen());

    case NamedRoute.verifyOtpScreen:
      return _getPageRoute(
        VerifyOtpScreen2(args: settings.arguments as VerifyOtpArguments),
      );

    case NamedRoute.captureFaceScreen:
      return _getPageRoute(CaptureFaceScreen());

    case NamedRoute.captureBodyScreen:
      return _getPageRoute(CaptureBodyScreen());

    // Home Screen
    case NamedRoute.bottomNavBarScreen:
      return _getPageRoute(
        BottomNavBar(args: settings.arguments as BottomNavArgumnets),
      );
    case NamedRoute.productDetailScreen:
      return _getPageRoute(
        ProductDetailScreen(
          args: settings.arguments as ProductDetailScreenArguments,
        ),
      );

    case NamedRoute.categoryRelationScreen:
      return _getPageRoute(
        CategoryRelationScreen(
          args: settings.arguments as CategoryRelationScreenArguments,
        ),
      );

    // case NamedRoute.walletScreen:
    //   return _getPageRoute(const WalletScreen());

    // case NamedRoute.editProfileScreen:
    //   return _getPageRoute(EditProfileScreen(
    //     args: settings.arguments as EditProfileScreenArguments,
    //   ));

    // case NamedRoute.faqsScreen:
    //   return _getPageRoute(
    //       FaqsScreen(args: settings.arguments as FaqsScreenArguments));

    default:
      return _getPageRoute(const PhoneNumberScreen());
  }
}

PageRoute _getPageRoute(Widget screen) {
  return MaterialPageRoute(builder: (context) => screen);
}
