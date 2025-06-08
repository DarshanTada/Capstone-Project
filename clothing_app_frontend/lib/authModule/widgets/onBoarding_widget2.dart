// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/colors.dart';
import 'package:clothing_app_frontend/common_widgets/asset_svg_icon.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/navigation/navigators.dart';
import 'package:clothing_app_frontend/navigation/routes.dart';
import 'package:provider/provider.dart';

import '../../common_functions.dart';
import '../providers/auth_provider.dart';

class OnBoardingWidget2 extends StatelessWidget {
  OnBoardingWidget2({super.key});

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};
  int screenNumber = 1;

  TextTheme get textTheme => Theme.of(navigatorKey.currentContext!).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      padding: EdgeInsets.only(left: dW * 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/onBoarding2.png', width: dW * 0.43),
          SizedBox(height: dW * 0.06),
          Padding(
            padding: EdgeInsets.only(right: dW * 0.2),
            child: Text(
              language['findTheNearestCafeLocationsUsingOurStoreLocatorFeature'],
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: 'Inria Serif',
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
