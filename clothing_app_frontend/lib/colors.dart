import 'package:flutter/material.dart';
import 'common_functions.dart';

Color get themeColor => Theme.of(bContext).primaryColor;

//OnBoarding screen
Color getScaffoldBgColor(BuildContext context) {
  final themeMode = Theme.of(context).brightness;

  if (themeMode == Brightness.light) {
    return const Color(0xFF5ECBEE); // Light mode color
  } else {
    return const Color(0xFF212B1E); // Dark mode color
  }
}

Color getThemeColor(BuildContext context) {
  final themeMode = Theme.of(context).brightness;

  if (themeMode == Brightness.light) {
    return const Color(0xff434343); // Light mode color
  } else {
    return const Color(0xFFFFFFFF); // Dark mode color
  }
}

const Color offWhite = Color(0xFFF1F1F1);
const Color lightGray = Color(0xFFACACB4);
const Color backButtonColor = Color(0xff636363);
const Color appBarTitleColor = Color(0xFF5E5E5E);
const Color grayColor = Color(0xFF5E5E5E);
const Color disabledColor = Color(0xFFFAE1CD);
const Color greyBorderColor = Color(0xFFD9D9D9);
const Color redColor = Color(0xFFDD4F4D);
const Color yellowColor = Color(0xFFFFB200);
const Color greenColor = Color(0xFF34B53A);
const Color dividerColor = Color(0xFFEAEAEA);
const Color blackColor3 = Color(0xFF3E3E3E);
const Color placeholderColor = Color(0xFFAAABB5);
const Color highlightColor = Color(0xFFD7FEFF);
const Color white = Colors.white;
const Color lueLine = Color(0xFF9AFCFF);
const Color lightBlue = Color(0xFF8DA4FF);
const Color darkBlue = Color(0xFF6580EE);
const Color lightGreenBg = Color(0xFFE4FFE6);

const Color buttonColor = Color(0xff272559);

Color getUnselectedLabelColor(BuildContext context) {
  final themeMode = Theme.of(context).brightness;

  if (themeMode == Brightness.light) {
    return const Color(0xFF8A8A8A); // Light mode color
  } else {
    // Handle dark mode color here
    return const Color(0xFF8A8A8A); // Example dark mode color
  }
}
