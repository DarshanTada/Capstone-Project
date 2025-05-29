// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/authModule/widgets/onBoarding_widget1.dart';
import 'package:clothing_app_frontend/authModule/widgets/onBoarding_widget2.dart';
import 'package:clothing_app_frontend/authModule/widgets/onBoarding_widget3.dart';
import 'package:clothing_app_frontend/colors.dart';
import 'package:clothing_app_frontend/common_widgets/asset_svg_icon.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/navigation/navigators.dart';
import 'package:clothing_app_frontend/navigation/routes.dart';
import 'package:provider/provider.dart';

import '../../common_functions.dart';
import '../providers/auth_provider.dart';

class OnBoardingScreen1 extends StatefulWidget {
  OnBoardingScreen1({super.key});

  @override
  State<OnBoardingScreen1> createState() => _OnBoardingScreen1State();
}

class _OnBoardingScreen1State extends State<OnBoardingScreen1> {
  double dW = 0.0;
  double dH = 0.0;

  double tS = 0.0;

  Map language = {};

  int screenNumber = 1;

  TextTheme get textTheme => Theme.of(bContext).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Scaffold(
      backgroundColor: getScaffoldBgColor(context),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    Widget currentWidget = OnBoardingWidget1();

    switch (screenNumber) {
      case 2:
        currentWidget = OnBoardingWidget2();
        break;
      case 3:
        currentWidget = OnBoardingWidget3();
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: dW * 0.1),
                      child: Image.asset(
                        'assets/images/onBoarding_background.png',
                        height: dW * 1.05,
                        width: dW,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: dW * 0.09, right: dW * 0.09),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              push(NamedRoute.mobileNumberScreen);
                            },
                            child: TextWidget(
                              title: language['skip'],
                              color: const Color(0xff1DA3CF),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                currentWidget,
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: dW * 0.08,
            right: dW * 0.08,
            bottom: dW * 0.07,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AssetSvgIcon('corousel$screenNumber'),
              GestureDetector(
                onTap: () {
                  if (screenNumber < 3) {
                    setState(() {
                      screenNumber++;
                    });
                  } else {
                    push(NamedRoute.mobileNumberScreen);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(dW * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
