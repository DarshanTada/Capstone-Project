// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:clothing_app_frontend/authModule/model/user_model.dart';
// import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
// import 'package:clothing_app_frontend/colors.dart';
// import 'package:clothing_app_frontend/common_functions.dart';
// import 'package:clothing_app_frontend/common_widgets/custom_button.dart';
// import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
// import 'package:clothing_app_frontend/navigation/arguments.dart';
// import 'package:clothing_app_frontend/navigation/navigators.dart';
// import 'package:clothing_app_frontend/navigation/routes.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider, User;

// class VerifyOtpScreen extends StatefulWidget {
//   final VerifyOtpArguments args;
//   const VerifyOtpScreen({super.key, required this.args});

//   @override
//   State<VerifyOtpScreen> createState() => VerifyOtpScreenState();
// }

// class VerifyOtpScreenState extends State<VerifyOtpScreen> {
//   //
//   Map language = {};
//   double dW = 0.0;
//   double tS = 0.0;
//   bool _isLoading = false;
//   bool inCorrect = false;
//   bool isReadyToResend = false;

//   TextTheme get textTheme => Theme.of(context).textTheme;
//   bool validateotp = false;
//   final _otpEditingController = TextEditingController();

//   late Timer _timer;
//   int _start = 30;
//   int otpSentCount = 1;
//   late User user;
//   String otp = '123456';

//   void startTimer() {
//     _start = 30;
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(oneSec, (Timer timer) {
//       if (_start == 0) {
//         setState(() {
//           timer.cancel();
//           isReadyToResend = true;
//         });
//       } else {
//         setState(() {
//           _start--;
//         });
//       }
//     });
//   }

//   String? validateOtp(String value) {
//     if (value.isEmpty) {
//       validateotp = false;
//       // return 'Please enter OTP';
//       return null;
//     } else if (value.length < 6) {
//       validateotp = false;
//       // return showSnackbar('Please enter valid OTP');
//       // return 'Please enter valid OTP';
//       return null;
//       // } else if (value != otp) {
//       //   validateotp = false;
//       //   // return showSnackbar('Please enter valid OTP');
//       //   // return 'Please enter valid OTP';
//       //   return null;
//     }
//     // else if (value != otp) {
//     //   validateotp = false;
//     //   // return showSnackbar('Please enter valid OTP');
//     //   // return 'Please enter valid OTP';
//     //   return null;
//     // }
//     validateotp = true;
//     return null;
//   }

//   Future<void> verifyOTP() async {
//     // if(_otpEditingController.text.trim() == otp ) {}
//     final data = await Provider.of<AuthProvider>(context, listen: false)
//         .verifyOTPofUser(
//           widget.args.mobileNo.toString(),
//           _otpEditingController.text,
//         );

//     if (data == 'success') {
//       final response = await Provider.of<AuthProvider>(
//         context,
//         listen: false,
//       ).login(query: '?phone=${widget.args.mobileNo}');

//       if (response['success'] && response['login']) {
//         pushAndRemoveUntil(
//           NamedRoute.bottomNavBarScreen,
//           arguments: BottomNavArgumnets(),
//         );
//       } else if (!response['success']) {
//         showSnackbar("somethingWentWrong");
//       } else if (!response['login']) {
//         pushAndRemoveUntil(
//           NamedRoute.registerUserScreen,
//           arguments: RegistrationArguments(mobileNo: widget.args.mobileNo),
//         );
//       }

//       //
//     } else {
//       showSnackbar('Incorrect OTP', Colors.red);

//       setState(() {
//         inCorrect = true;
//       });
//     }

//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   resendOTPToUser() async {
//     try {
//       setState(() {
//         otpSentCount += 1;
//         if (otpSentCount > 3) {
//           isReadyToResend = false;
//         }
//       });
//       if (isReadyToResend) {
//         setState(() {
//           _timer.cancel();
//           isReadyToResend = false;
//           startTimer();
//         });
//         final data = await Provider.of<AuthProvider>(
//           context,
//           listen: false,
//         ).resendOTPtoUser(widget.args.mobileNo.toString(), 'text');
//         if (data != "success") {
//           showSnackbar("somethingWentWrong", Colors.red);
//         }
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     _timer.cancel();
//   }

//   @override
//   void initState() {
//     super.initState();

//     startTimer();
//   }

//   void onEnd() {
//     setState(() {
//       isReadyToResend = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     dW = MediaQuery.of(context).size.width;
//     tS = MediaQuery.of(context).textScaleFactor;
//     language = Provider.of<AuthProvider>(context).selectedLanguage;

//     return Scaffold(
//       body: Stack(
//         children: [
//           Center(child: Image.asset('assets/images/login_bg.jpg')),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: dW * 0.06),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: dW * 0.15),
//                         GestureDetector(
//                           onTap: () => pop(),
//                           child: const Icon(Icons.arrow_back),
//                         ),
//                         SizedBox(height: dW * 0.1),
//                         TextWidget(
//                           title: "otpVerification",
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           color: const Color(0xff6B6C75),
//                         ),
//                         SizedBox(height: dW * 0.03),
//                         TextWidget(
//                           title: "enterTheOtpSendTo",
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xff6B6C75),
//                           fontSize: 16,
//                         ),
//                         SizedBox(height: dW * 0.03),
//                         Row(
//                           children: [
//                             const Icon(Icons.phone_android, size: 20),
//                             SizedBox(width: dW * 0.01),
//                             TextWidget(
//                               title: '+91 ${widget.args.mobileNo}',
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: dW * 0.09),
//                         PinCodeTextField(
//                           errorTextMargin: EdgeInsets.only(
//                             left: dW * 0.025,
//                             top: dW * 0.025,
//                           ),
//                           appContext: context,
//                           length: 6,
//                           onChanged: (value) {
//                             setState(() {
//                               validateotp = validateOtp(value) != null;
//                             });
//                           },
//                           controller: _otpEditingController,
//                           keyboardType: TextInputType.number,
//                           cursorColor: Colors.black,
//                           validator: (v) => validateOtp(v!),
//                           pinTheme: PinTheme(
//                             shape: PinCodeFieldShape.box,
//                             activeColor: const Color(0xffBFC0C8),
//                             inactiveColor: const Color(0xffBFC0C8),
//                             selectedFillColor: const Color(0xffBFC0C8),
//                             disabledColor: const Color(0xffBFC0C8),
//                             borderWidth: 1,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         ),
//                         SizedBox(height: dW * 0.05),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               alignment: Alignment.bottomCenter,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.symmetric(
//                                       vertical: dW * 0.024,
//                                     ),
//                                     child: InkWell(
//                                       onTap: !isReadyToResend
//                                           ? null
//                                           : otpSentCount > 3
//                                           ? () {
//                                               showSnackbar(
//                                                 "outOfAttempts",
//                                                 Colors.red,
//                                               );
//                                               return;
//                                             }
//                                           : () {
//                                               resendOTPToUser();
//                                             },
//                                       child: RichText(
//                                         textAlign: TextAlign.center,
//                                         text: TextSpan(
//                                           children: [
//                                             TextSpan(
//                                               text: "didntGetOtp",
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: tS * 12,
//                                                 color: const Color(0xff6B6C75),
//                                                 fontFamily: 'Inter',
//                                               ),
//                                             ),
//                                             TextSpan(
//                                               text: "resend",
//                                               style: TextStyle(
//                                                 fontSize: tS * 12,
//                                                 fontWeight: FontWeight.w600,
//                                                 color: buttonColor,
//                                                 fontFamily: 'Inter',
//                                               ),
//                                             ),
//                                             if (_start != 0 && otpSentCount < 3)
//                                               TextSpan(
//                                                 text: _start == 0
//                                                     ? '0:00'
//                                                     : _start > 9
//                                                     ? " ${['in']} : 0:$_start Sec"
//                                                     : " ${['in']} : 0:0$_start Sec",
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.w600,
//                                                   fontSize: tS * 12,
//                                                   color: const Color(
//                                                     0xff6B6C75,
//                                                   ),
//                                                   fontFamily: 'Inter',
//                                                 ),
//                                               ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Wrap(
//                   alignment: WrapAlignment.center,
//                   children: [
//                     TextWidget(
//                       title: "byContinuingYouAgreeToThe",
//                       fontSize: 12,
//                       color: const Color(0xff6B6C75),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         push(
//                           NamedRoute.privacyPolicyAndTcScreen,
//                           arguments: PrivacyPolicyAndTcScreenArguments(
//                             title: "tos",
//                             contentType: 'TERMSANDCONDITIONS',
//                           ),
//                         );
//                       },
//                       child: Text(
//                         "tos",
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontFamily: 'Montserrat',
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     TextWidget(
//                       title: "and",
//                       fontSize: 12,
//                       color: const Color(0xff6B6C75),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         push(
//                           NamedRoute.privacyPolicyAndTcScreen,
//                           arguments: PrivacyPolicyAndTcScreenArguments(
//                             title: "privacyPolicy",
//                             contentType: 'PRIVACYPOLICY',
//                           ),
//                         );
//                       },
//                       child: Text(
//                         "privacyPolicy",
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontFamily: 'Montserrat',
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: dW * 0.04),
//                 CustomButton(
//                   width: dW,
//                   height: dW * 0.12,
//                   isLoading: _isLoading,
//                   radius: 8,
//                   buttonText: "continue",
//                   buttonTextSyle: Theme.of(context).textTheme.displayLarge!
//                       .copyWith(
//                         fontSize: tS * 18,
//                         color: validateotp ? Colors.white : Colors.grey,
//                       ),
//                   onPressed: validateotp ? verifyOTP : () {},
//                   buttonColor: validateotp
//                       ? const Color(0xff4F4D8B)
//                       : const Color(0xff4F4D8B).withOpacity(0.5),
//                 ),
//                 SizedBox(height: dW * 0.1),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
