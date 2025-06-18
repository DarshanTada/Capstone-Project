import 'package:clothing_app_frontend/authModule/providers/auth_service_firebase.dart';
import 'package:clothing_app_frontend/authModule/screens/verify_otp_screen.dart';
import 'package:clothing_app_frontend/authModule/screens/verify_otp_screen2.dart';
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
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => PhoneNumberScreenState();
}

class PhoneNumberScreenState extends State<PhoneNumberScreen> {
  //
  late VideoPlayerController _controller;
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAnalytics analytic = FirebaseAnalytics.instance;
  bool _termsAccepted = false;
  bool isgettingOTP = false;

  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  double dH = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;
  // final VideoPlayerController controller = VideoPlayerController.asset(
  //   'assets/videos/v_login.mp4',
  //   // viewType: widget.viewType,
  // );
  late VideoViewType viewType;

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

  void getOTP() {
    String phoneNumber = _phoneController.text;
    if (RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber)) {
      setState(() {
        isgettingOTP = true;
      });
      AuthRepo.verifyPhoneNumber(context, phoneNumber);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid phone number")),
      );
    }
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
        body: Stack(
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
                Expanded(
                  child: Column(
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
                                  child: CustomTextFieldWithLabel(
                                    controller: _phoneController,
                                    hintText: "000-000-0000",
                                    prefixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(width: dW * 0.04),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ), // half of height/width to make it round
                                          child: CountryFlag.fromCountryCode(
                                            'CA',
                                            height: 30,
                                            width:
                                                30, // make width and height equal for perfect circle
                                          ),
                                        ),
                                        SizedBox(width: dW * 0.02),
                                        TextWidget(
                                          title: '+1',
                                          color: getGreyColor(),
                                          fontSize: tS * 20,
                                        ),
                                        SizedBox(width: dW * 0.04),
                                      ],
                                    ),
                                    label: "Phone Number",
                                    hintFS: 20,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: _termsAccepted,
                                  onChanged: (val) => setState(
                                    () => _termsAccepted = val ?? false,
                                  ),
                                ),
                                TextWidget(
                                  title: "I accept the ",
                                  color: getGreyColor(),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: TextWidget(
                                    title: "Terms and Conditions",
                                    // letterSpacing: 0.1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: dW * 0.075),
                            ElevatedButton(
                              onPressed: _termsAccepted ? getOTP : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Send OTP",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
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
                            const SizedBox(height: 10),
                            const Text(
                              "Privacy Policy",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
