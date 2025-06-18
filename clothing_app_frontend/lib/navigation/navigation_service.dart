import 'package:clothing_app_frontend/authModule/screens/login.dart';
import 'package:clothing_app_frontend/authModule/screens/phone_number_screen.dart';
import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/common_widgets/bottom_nav_bar.dart';
import 'package:clothing_app_frontend/common_widgets/loading_screen.dart';
// import '../authModule/screens/onBoarding_screen1.dart';
import '../authModule/screens/splash_screen.dart';
import 'arguments.dart';
import 'routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // Auth Screens
    case NamedRoute.onBoardingScreen:
      // TODO It used to be splash screen
      return _getPageRoute(const PhoneNumberScreen());

    case NamedRoute.loadingScreen:
      return _getPageRoute(
        LoadingScreen(args: settings.arguments as LoadingScreenArguments),
      );

    // case NamedRoute.onBoardingScreen1:
    //   return _getPageRoute(OnBoardingScreen1());

    case NamedRoute.loginScreen:
      return _getPageRoute(const PhoneNumberScreen());

    // case NamedRoute.verifyOtpScreen:
    //   return _getPageRoute(VerifyOtpScreen(
    //     args: settings.arguments as VerifyOtpArguments,
    //   ));

    // case NamedRoute.registerUserScreen:
    //   return _getPageRoute(RegisterUserScreen(
    //       args: settings.arguments as RegistrationArguments));

    // case NamedRoute.privacyPolicyAndTcScreen:
    //   return _getPageRoute(PrivacyPolicyAndTcScreen(
    //     args: settings.arguments as PrivacyPolicyAndTcScreenArguments,
    //   ));

    // case NamedRoute.termsOfServicesScreen:
    //   return _getPageRoute(const TermsOfServicesScreen());

    // Home Screen
    // case NamedRoute.bottomNavBarScreen:
    //   return _getPageRoute(BottomNavBar(
    //     args: settings.arguments as BottomNavArgumnets,
    //   ));

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
