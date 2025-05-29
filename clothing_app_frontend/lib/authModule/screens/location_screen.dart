// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/authModule/model/user_model.dart';
import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/colors.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/custom_button.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/navigation/arguments.dart';
import 'package:clothing_app_frontend/navigation/navigators.dart';
import 'package:clothing_app_frontend/navigation/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Map language = {};
  double dW = 0.0;
  double dH = 0.0;

  double tS = 0.0;
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;
  bool validatePhone = false;
  User? user;

  // checkAndGetLocationPermission() async {
  //   setState(() => isLoading = true);
  //   try {
  //     await handlePermissionsFunction();

  //     if (await Permission.location.isGranted) {
  //       final _authProvider = Provider.of<AuthProvider>(context, listen: false);

  //       await _authProvider.fetchMyLocation();

  //       final coord = _authProvider.user.coordinates;
  //       if (coord != null) {
  //         final User user = Provider.of<AuthProvider>(
  //           context,
  //           listen: false,
  //         ).user;
  //         String coordString = [coord.longitude, coord.latitude].toString();
  //         final response =
  //             await Provider.of<CafeProvider>(context, listen: false).fetchCafe(
  //               accessToken: user.accessToken,
  //               query: 'coordinates=$coordString',
  //             );

  //         if (response['success']) {
  //           if (!user.isLocationAllowed) {
  //             if (!user.isGuest) {
  //               await Provider.of<AuthProvider>(
  //                 context,
  //                 listen: false,
  //               ).editProfile(body: {'isLocationAllowed': 'true'}, files: {});
  //             } else {
  //               user.isLocationAllowed = true;
  //             }
  //           }
  //           pushAndRemoveUntil(
  //             NamedRoute.bottomNavBarScreen,
  //             arguments: BottomNavArgumnets(),
  //           );
  //         } else {
  //           push(NamedRoute.searchCafeScreen);
  //         }
  //       } else {
  //         push(NamedRoute.searchCafeScreen);
  //       }
  //     } else {
  //       showSnackbar('Please enable location access');
  //       return;
  //     }
  //     //
  //   } catch (e) {
  //     showSnackbar('Please enable location access');
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dW * horizontalPaddingFactor,
          vertical: dW * 0.04,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: dH * 0.065),
              padding: EdgeInsets.only(right: dW * 0.04),
              child: TextWidget(
                title: language['locationAccessPermissionIsRequired'],
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Column(
              children: [
                Image.asset('assets/images/location_bg.png', scale: 1.8),
                SizedBox(height: dW * 0.1),
                TextWidget(
                  textAlign: TextAlign.center,
                  title:
                      language['pleaseEnableYourLocationToFindTheNearestIteehaCafe'],
                ),
              ],
            ),
            Column(
              children: [
                CustomButton(
                  isLoading: isLoading,
                  width: dW,
                  height: dW * 0.13,
                  buttonText: language['allowLocationAccess'],
                  buttonColor: buttonColor,
                  radius: 8,
                  onPressed:
                  //  isLoading 
                  // ?
                   () {}
                  //  : 
                  // checkAndGetLocationPermission,
                ),
                SizedBox(height: dW * 0.04),
                CustomButton(
                  width: dW,
                  height: dW * 0.13,
                  buttonText: language['enterLocationManually'],
                  buttonColor: Colors.white,
                  radius: 8,
                  onPressed: () => push(NamedRoute.searchCafeScreen),
                  borderColor: buttonColor,
                  buttonTextSyle: Theme.of(context).textTheme.displayLarge!
                      .copyWith(fontSize: tS * 16, color: buttonColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
