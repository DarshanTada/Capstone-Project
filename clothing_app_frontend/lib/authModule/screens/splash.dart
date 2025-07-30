import 'dart:convert';

import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/navigation/navigators.dart';
import 'package:clothing_app_frontend/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class SplashScreenMain extends StatefulWidget {
  const SplashScreenMain({super.key});

  @override
  State<SplashScreenMain> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenMain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final LocalStorage storage = LocalStorage('yolochec');

  getLanguage() async {
    await storage.ready;
    var languageMap = storage.getItem('language');
    String language = 'english';

    if (languageMap != null) {
      languageMap = json.decode(languageMap);
      language = languageMap['language'];
    } else {
      Provider.of<AuthProvider>(
        context,
        listen: false,
      ).setLanguageInStorage(language);
    }

    final response = await Provider.of<AuthProvider>(context, listen: false);
    // .getAppConfig(['user-$language', 'delete_feature']);

    return response;
  }

  makeStorage() async {
    await storage.ready;
  }

  @override
  void initState() {
    super.initState();
    makeStorage();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _loadApp(); // Start loading app resources
  }

  Future<void> _loadApp() async {
    // Simulate loading (e.g., Firebase.init(), shared prefs, API calls, etc.)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    // // pushAndRemoveUntil(NamedRoute.phoneNumberScreen);
    // // Navigate to test screen instead of AddressDemoScreen for debugging
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const TestScreen()),
    // );
    pushAndRemoveUntil(NamedRoute.checkoutScreen);
    // pushAndRemoveUntil(
    //   NamedRoute.bottomNavBarScreen,
    //   arguments: BottomNavArgumnets(),
    // );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/images/logo.png',
                width: 160,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: Colors.white70,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
