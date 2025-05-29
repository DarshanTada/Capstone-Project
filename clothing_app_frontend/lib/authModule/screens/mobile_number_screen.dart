// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clothing_app_frontend/authModule/model/user_model.dart';
import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/asset_svg_icon.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_button.dart';
import 'package:clothing_app_frontend/common_widgets/custom_text_field.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/navigation/arguments.dart';
import 'package:clothing_app_frontend/navigation/navigators.dart';
import 'package:clothing_app_frontend/navigation/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({super.key});

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  bool isLoading = false;
  bool locationLoading = false;

  TextTheme get textTheme => Theme.of(context).textTheme;
  bool validatePhone = false;
  final _phoneEditingController = TextEditingController();

  bool get validateNumber {
    setState(() {
      validatePhone = false;
    });
    String pattern = r'([6,7,8,9][0-9]{9})';
    RegExp regExp = RegExp(pattern);
    String amount = _phoneEditingController.text.toString();

    if (amount.length < 10 || amount.isEmpty || !regExp.hasMatch(amount)) {
      setState(() {
        validatePhone = false;
      });
      return false;
    }
    setState(() {
      validatePhone = true;
    });
    return true;
  }

  getOTP() async {
    try {
      setState(() {
        isLoading = true;
      });

      final data = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).sendOTPtoUser(_phoneEditingController.text.toString());
      if (!data["success"]) {
        showSnackbar(
          'Something went wrong, Check internet connection',
          Colors.red,
        );
      } else {
        if (data['result']['type'] == 'success') {
          push(
            NamedRoute.verifyOtpScreen,
            arguments: VerifyOtpArguments(
              mobileNo: _phoneEditingController.text.trim(),
            ),
          );
        } else {
          showSnackbar(
            'Something went wrong, Check internet connection',
            Colors.red,
          );
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // String? validateMobile(String value) {
  //   String pattern = r'([6,7,8,9][0-9]{9})';
  //   RegExp regExp = RegExp(pattern);
  //   if (value.isEmpty) {
  //     setState(() {
  //       validatePhone = false;
  //     });
  //     return null;
  //     // return 'Please enter mobile number';
  //   } else if (!regExp.hasMatch(value)) {
  //     setState(() {
  //       validatePhone = false;
  //     });
  //     return null;

  //     // return 'Please enter valid mobile number';
  //   } else if (value.length < 10) {
  //     setState(() {
  //       validatePhone = false;
  //     });
  //   }
  //   setState(() {
  //     validatePhone = true;
  //   });
  //   return null;
  // }

 
  guestUser() {
    Provider.of<AuthProvider>(context, listen: false).setGuestUser();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user.isLocationAllowed) {
      // checkAndGetLocationPermission();
    } else {
      push(NamedRoute.locationScreen);
    }
  }

  @override
  void initState() {
    super.initState();
    // _phoneEditingController.addListener(() {
    //   setState(() {
    //     validateMobile(_phoneEditingController.text);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: Image.asset('assets/images/login_bg.jpg')),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: dW * 0.06),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: dW * 0.22),
                          Row(
                            children: [
                              TextWidget(
                                title: language['welcomeTo'],
                                fontSize: 12,
                              ),
                              const TextWidget(
                                title: ' Iteeha Coffee',
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ],
                          ),
                          SizedBox(height: dW * 0.04),
                          TextWidget(
                            title: language['enterMobileNumber'],
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          SizedBox(height: dW * 0.03),
                          Wrap(
                            children: [
                              TextWidget(
                                title: language['weWillSendYouAn'],
                                fontSize: 12,
                              ),
                              TextWidget(
                                title: language['oneTimePassword'],
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              TextWidget(
                                title: language['onThisMobileNumber'],
                                fontSize: 12,
                              ),
                            ],
                          ),
                          SizedBox(height: dW * 0.08),
                          TextWidget(
                            title: language['mobileNumber'],
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          SizedBox(height: dW * 0.02),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: dW * 0.025,
                                  vertical: dW * 0.028,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xffBFC0C8),
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/india_flag.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: dW * 0.02),
                                    const TextWidget(
                                      title: '+91',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: dW * 0.02),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextFieldWithLabel(
                                        suffixIcon: Icon(
                                          Icons.check_circle_outline,
                                          color: validatePhone
                                              ? const Color(0xff4F4D8B)
                                              : const Color(
                                                  0xff4F4D8B,
                                                ).withOpacity(0.4),
                                        ),
                                        border: 4,
                                        borderColor: const Color(0xffBFC0C8),
                                        label: '',
                                        inputFormatter: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp('[0-9]'),
                                          ),
                                        ],
                                        hintText: '00000 00000',
                                        inputType: TextInputType.phone,
                                        onChanged: (newValue) {
                                          setState(() {
                                            validateNumber;
                                          });
                                        },
                                        controller: _phoneEditingController,
                                        maxLength: 10,
                                        // validator: (v) => validateMobile(v!),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: dW * 0.15),
                          CustomButton(
                            width: dW,
                            height: dW * 0.12,
                            radius: 8,
                            buttonText: language['getOtp'],
                            buttonTextSyle: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  fontSize: tS * 18,
                                  color: validateNumber
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                            onPressed: validateNumber ? getOTP : () {},
                            buttonColor: validateNumber
                                ? const Color(0xff4F4D8B)
                                : const Color(0xff4F4D8B).withOpacity(0.5),
                          ),
                          // SizedBox(
                          //   height: dW * 0.06,
                          // ),
                          // Row(
                          //   children: [
                          //     const Expanded(
                          //       child: Divider(
                          //         thickness: 1,
                          //         color: Color(0xffDBDBDB),
                          //       ),
                          //     ),
                          //     Container(
                          //       padding: EdgeInsets.symmetric(
                          //           horizontal: dW * 0.025, vertical: dW * 0.01),
                          //       child: TextWidget(
                          //         title: language['orLoginWith'],
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.w500,
                          //         color: const Color(0xff6B6C75),
                          //       ),
                          //     ),
                          //     const Expanded(
                          //       child: Divider(
                          //         thickness: 1,
                          //         color: Color(0xffDBDBDB),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: dW * 0.08,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     GestureDetector(
                          //       onTap: () {},
                          //       child: Container(
                          //         margin: EdgeInsets.only(right: dW * 0.1),
                          //         padding: EdgeInsets.symmetric(
                          //             horizontal: dW * 0.07, vertical: dW * 0.015),
                          //         decoration: BoxDecoration(
                          //             border: Border.all(
                          //                 color: const Color(0xff272559), width: 1),
                          //             borderRadius: BorderRadius.circular(25)),
                          //         child: const AssetSvgIcon('apple'),
                          //       ),
                          //     ),
                          //     GestureDetector(
                          //       onTap: () {},
                          //       child: Container(
                          //         padding: EdgeInsets.symmetric(
                          //             horizontal: dW * 0.06, vertical: dW * 0.01),
                          //         decoration: BoxDecoration(
                          //             border: Border.all(
                          //                 color: const Color(0xff272559), width: 1),
                          //             borderRadius: BorderRadius.circular(25)),
                          //         child: const AssetSvgIcon(
                          //           'google',
                          //           height: 30,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: guestUser,
                    child: locationLoading
                        ? const CircularLoader()
                        : TextWidget(
                            title: language['continueAsGuest'],
                            fontWeight: FontWeight.w600,
                            textDecoration: TextDecoration.underline,
                          ),
                  ),
                  SizedBox(height: dW * 0.1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
