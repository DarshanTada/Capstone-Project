import 'package:clothing_app_frontend/authModule/screens/verify_otp_screen.dart';
import 'package:clothing_app_frontend/colors.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/custom_text_field.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/navigation/arguments.dart';
import 'package:country_flags/country_flags.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class VerifyOtpScreen2 extends StatefulWidget {
  const VerifyOtpScreen2({super.key});

  @override
  State<VerifyOtpScreen2> createState() => VerifyOtpScreen2State();
}

class VerifyOtpScreen2State extends State<VerifyOtpScreen2> {
  //
  late VideoPlayerController _controller;
  final _otpEditingController = TextEditingController();
  bool validateotp = false;

  final FirebaseAnalytics analytic = FirebaseAnalytics.instance;
  bool _termsAccepted = false;

  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  double dH = 0.0;
  String otp = '123456';

  TextTheme get textTheme => Theme.of(context).textTheme;
  // final VideoPlayerController controller = VideoPlayerController.asset(
  //   'assets/videos/v_login.mp4',
  //   // viewType: widget.viewType,
  // );
  late VideoViewType viewType;

  //   void startTimer() {
  //   _start = 30;
  //   const oneSec = Duration(seconds: 1);
  //   _timer = Timer.periodic(oneSec, (Timer timer) {
  //     if (_start == 0) {
  //       setState(() {
  //         timer.cancel();
  //         isReadyToResend = true;
  //       });
  //     } else {
  //       setState(() {
  //         _start--;
  //       });
  //     }
  //   });
  // }

  String? validateOtp(String value) {
    if (value.isEmpty) {
      validateotp = false;
      return 'Please enter OTP';
      return null;
    } else if (value.length < 6) {
      validateotp = false;
      // return showSnackbar('Please enter valid OTP');
      return 'Please enter valid OTP';
      return null;
      // } else if (value != otp) {
      //   validateotp = false;
      //   // return showSnackbar('Please enter valid OTP');
      //   // return 'Please enter valid OTP';
      //   return null;
    }
    // else if (value != otp) {
    //   validateotp = false;
    //   // return showSnackbar('Please enter valid OTP');
    //   // return 'Please enter valid OTP';
    //   return null;
    // }
    validateotp = true;
    return null;
  }

  // Future<void> verifyOTP() async {
  //   // if(_otpEditingController.text.trim() == otp ) {}
  //   final data = await Provider.of<AuthProvider>(context, listen: false)
  //       .verifyOTPofUser(
  //         widget.args.mobileNo.toString(),
  //         _otpEditingController.text,
  //       );
  //   if (data == 'success') {
  //     final response = await Provider.of<AuthProvider>(
  //       context,
  //       listen: false,
  //     ).login(query: '?phone=${widget.args.mobileNo}');

  //     if (response['success'] && response['login']) {
  //       pushAndRemoveUntil(
  //         NamedRoute.bottomNavBarScreen,
  //         arguments: BottomNavArgumnets(),
  //       );
  //     } else if (!response['success']) {
  //       showSnackbar(language['somethingWentWrong']);
  //     } else if (!response['login']) {
  //       pushAndRemoveUntil(
  //         NamedRoute.registerUserScreen,
  //         arguments: RegistrationArguments(mobileNo: widget.args.mobileNo),
  //       );
  //     }

  //     //
  //   } else {
  //     showSnackbar('Incorrect OTP', Colors.red);

  //     setState(() {
  //       inCorrect = true;
  //     });
  //   }

  //   if (mounted) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    analytic.setAnalyticsCollectionEnabled(true);
    _controller = VideoPlayerController.asset("assets/videos/v_login.mp4");
    initialze().then((_) {
      setState(() {
        _controller.setVolume(0);
        _controller.setLooping(true);
        _controller.play();
      });
    });
  }

  Future<void> initialze() async {
    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    dH = MediaQuery.of(context).size.height;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    // return SafeArea(
    //   child: Scaffold(
    //     body: Column(children: [Text('Login'), VideoPlayer(controller)]),
    //   ),
    // );
    return GestureDetector(
      onTap: hideKeyBoard,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Container(
            height: dH,
            child: Stack(
              children: [
                SizedBox.expand(
                  child: _controller.value.isInitialized
                      ? Opacity(
                          opacity: 0.8,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _controller.value.isInitialized
                                  ? _controller.value.size.width
                                  : 0,
                              height: _controller.value.isInitialized
                                  ? _controller.value.size.height
                                  : 0,

                              child: Opacity(
                                opacity: 0.8,

                                child: VideoPlayer(_controller),
                              ),
                            ),
                          ),
                        )
                      : Container(color: Colors.black),
                ),

                Column(
                  children: [
                    const Spacer(flex: 2),
                    Center(
                      child: Column(
                        children: [
                          TextWidget(
                            title: "YOLO",
                            color: Colors.white70,
                            fontSize: tS * 51,
                          ),
                          TextWidget(
                            title: "chic",
                            color: Colors.white70,
                            fontSize: tS * 34,
                          ),
                          SizedBox(height: dH * 0.02),
                          TextWidget(
                            title: "Styling Made Simple",
                            color: Colors.white70,
                            fontSize: tS * 12,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 45, 30, 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextWidget(
                            title: "Sign In",
                            fontSize: tS * 45,
                            // fontWeight: FontWeight.w600,
                          ),

                          SizedBox(height: dW * 0.02),
                          TextWidget(
                            title: "Your Style, Your Way",
                            fontSize: tS * 17,
                            // fontWeight: FontWeight.w500,
                          ),

                          SizedBox(height: dW * 0.1),
                          Row(
                            children: [
                              // const SizedBox(width: 10),
                              Expanded(
                                child: PinCodeTextField(
                                  errorTextMargin: EdgeInsets.only(
                                    left: dW * 0.025,
                                    top: dW * 0.025,
                                  ),
                                  appContext: context,
                                  length: 6,
                                  onChanged: (value) {
                                    setState(() {
                                      validateotp = validateOtp(value) != null;
                                    });
                                  },
                                  controller: _otpEditingController,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.black,
                                  validator: (v) => validateOtp(v!),
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    activeColor: const Color(0xffBFC0C8),
                                    inactiveColor: const Color(0xffBFC0C8),
                                    selectedFillColor: const Color(0xffBFC0C8),
                                    disabledColor: const Color(0xffBFC0C8),
                                    borderWidth: 1,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                ),
                              ),
                            ],
                          ),
                          TextWidget(
                            title: "Resend Code",
                            color: getGreyColor(),
                          ),
                          SizedBox(height: dW * 0.075),
                          ElevatedButton(
                            onPressed: _otpEditingController.text == otp
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Verify",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: getOffWhiteColor(),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.arrow_forward,
                                  color: getOffWhiteColor(),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Privacy Policy",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () async {
                                  // Skip logic
                                  await analytic.logEvent(
                                    name: "login_pressed",
                                    parameters: {
                                      "page": "Login",
                                      "isButton": "Skip",
                                    },
                                  );
                                },
                                child: const Text(
                                  "Skip",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
