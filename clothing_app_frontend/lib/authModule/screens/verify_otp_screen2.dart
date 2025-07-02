import 'package:clothing_app_frontend/authModule/providers/auth_service_firebase.dart';
import 'package:clothing_app_frontend/colors.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/homeModule/screens/home_screen.dart';
import 'package:clothing_app_frontend/navigation/arguments.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart'
    hide AuthProvider;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VerifyOtpScreen2 extends StatefulWidget {
  final VerifyOtpArguments args;
  const VerifyOtpScreen2({super.key, required this.args});

  @override
  State<VerifyOtpScreen2> createState() => VerifyOtpScreen2State();
}

class VerifyOtpScreen2State extends State<VerifyOtpScreen2> {
  late VideoPlayerController _controller;
  final _otpEditingController = TextEditingController();

  final FirebaseAnalytics analytic = FirebaseAnalytics.instance;

  double dW = 0.0;
  double tS = 0.0;
  double dH = 0.0;

  bool isButtonEnabled = false;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    analytic.setAnalyticsCollectionEnabled(true);

    _controller = VideoPlayerController.asset("assets/videos/v_login.mp4")
      ..initialize().then((_) {
        setState(() {
          _controller.setVolume(0);
          _controller.setLooping(true);
          _controller.play();
          _isVideoInitialized = true;
        });
      });
  }

  String? validateOtp(String value) {
    if (value.isEmpty) {
      return 'Please enter OTP';
    } else if (value.length < 6) {
      return 'Please enter a valid 6-digit OTP';
    }
    return null;
  }

  void handleOtpChange(String value) {
    final isValid = validateOtp(value) == null;
    setState(() {
      isButtonEnabled = isValid;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _otpEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    dH = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: hideKeyBoard,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: SizedBox(
            height: dH,
            child: Stack(
              children: [
                if (_isVideoInitialized)
                  SizedBox.expand(
                    child: Opacity(
                      opacity: 0.8,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                  )
                else
                  Container(color: Colors.black),

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
                      padding: const EdgeInsets.fromLTRB(30, 45, 30, 20),
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
                          TextWidget(title: "Sign In", fontSize: tS * 45),
                          SizedBox(height: dW * 0.02),
                          TextWidget(
                            title: "Your Style, Your Way",
                            fontSize: tS * 17,
                          ),
                          SizedBox(height: dW * 0.1),
                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            onChanged: handleOtpChange,
                            controller: _otpEditingController,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.black,
                            validator: (v) => validateOtp(v ?? ''),
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              activeColor: const Color(0xffBFC0C8),
                              inactiveColor: const Color(0xffBFC0C8),
                              selectedFillColor: const Color(0xffBFC0C8),
                              disabledColor: const Color(0xffBFC0C8),
                              borderWidth: 1,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                          ),
                          GestureDetector(
                            onTap: () {
                              AuthRepo.resendOtp(
                                context,
                                '+1${widget.args.mobileNo}',
                              );
                            },
                            child: TextWidget(
                              title: "Resend Code",
                              color: getGreyColor(),
                            ),
                          ),
                          SizedBox(height: dW * 0.075),
                          ElevatedButton(
                            onPressed: isButtonEnabled
                                ? () {
                                    AuthRepo.submitOtp(
                                      context,
                                      _otpEditingController.text,
                                      '+1${widget.args.mobileNo}',
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
                                const SizedBox(width: 10),
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
                              const Text(
                                "Privacy Policy",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () async {
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
