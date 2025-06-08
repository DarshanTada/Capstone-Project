import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  late VideoPlayerController _controller;
  final TextEditingController _phoneController = TextEditingController();
  bool _termsAccepted = false;

  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  double th = 0.0;
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
    th = MediaQuery.of(context).size.height;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    // return SafeArea(
    //   child: Scaffold(
    //     body: Column(children: [Text('Login'), VideoPlayer(controller)]),
    //   ),
    // );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox.expand(
            child: _controller.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : Container(color: Colors.black),
          ),
          Container(color: Colors.black.withOpacity(0.8)),
          //Overlay content
          Column(
            children: [
              const Spacer(flex: 1),
              const Center(
                child: Column(
                  children: [
                    Text(
                      "YOLO",
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "chic",
                      style: TextStyle(fontSize: 24, color: Colors.white70),
                    ),
                    Text(
                      "Styling Made Simple",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Sign In",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Your Style, Your Way",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: dW * 0.04),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      15,
                                    ), // half of height/width to make it round
                                    child: CountryFlag.fromCountryCode(
                                      'CA',
                                      height: 30,
                                      width:
                                          30, // make width and height equal for perfect circle
                                    ),
                                  ),
                                  SizedBox(width: dW * 0.01),
                                  Text("+1"),
                                ],
                              ),
                              hintText: "000-000-0000",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _termsAccepted,
                          onChanged: (val) =>
                              setState(() => _termsAccepted = val ?? false),
                          activeColor: Colors.black,
                        ),
                        const Text("I accept the "),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Terms and Conditions",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _termsAccepted
                          ? () {
                              // Send OTP logic
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Send OTP", style: TextStyle(fontSize: 16)),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Privacy Policy",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            // Skip logic
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
    );
  }
}
