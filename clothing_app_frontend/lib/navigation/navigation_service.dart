import 'package:clothing_app_frontend/authModule/screens/capture_face_screen.dart';
import 'package:clothing_app_frontend/authModule/screens/phone_number_screen.dart';
import 'package:clothing_app_frontend/authModule/screens/verify_otp_screen2.dart';
import 'package:clothing_app_frontend/homeModule/screens/size_chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/common_widgets/bottom_nav_bar.dart';
import 'arguments.dart';
import 'routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case NamedRoute.phoneNumberScreen:
      return _getPageRoute(const PhoneNumberScreen());

    case NamedRoute.sizeChartScreen:
      return _getPageRoute(const SizeChartScreen());

    case NamedRoute.verifyOtpScreen:
      return _getPageRoute(
        VerifyOtpScreen2(args: settings.arguments as VerifyOtpArguments),
      );

    case NamedRoute.captureFaceScreen:
      return _getPageRoute(CaptureFaceScreen());

    // Home Screen
    case NamedRoute.bottomNavBarScreen:
      return _getPageRoute(
        BottomNavBar(args: settings.arguments as BottomNavArgumnets),
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
