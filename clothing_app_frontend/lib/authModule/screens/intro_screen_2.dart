import 'package:flutter/material.dart';
import '../../navigation/routes.dart';

class IntroScreen2 extends StatelessWidget {
  const IntroScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Images section takes all available space
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 10,
                        top: 55,
                        child: Container(
                          width: 127,
                          height: 127,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFF0F0F0),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(200),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 19,
                        top: 20,
                        child: Container(
                          width: 118,
                          height: 118,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            color: Color(0xFFCBCBC9),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/intro_2_1.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 38,
                        top: 10,
                        child: Container(
                          width: 161,
                          height: 161,
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F7F7),
                            borderRadius: BorderRadius.circular(200),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 20,
                        child: Container(
                          width: 165,
                          height: 165,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            color: Color(0xFFDEE4EB),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/intro_2_2.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 100,
                        bottom: 0,
                        child: Container(
                          width: 185,
                          height: 185,
                          decoration: BoxDecoration(
                            color: Color(0xFFFBF2EE),
                            borderRadius: BorderRadius.circular(200),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 40,
                        child: Container(
                          width: 136,
                          height: 136,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            color: Color(0xFFDEE4EB),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/intro_2_4.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 5,
                        child: Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            color: Color(0xFFDEE4EB),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/intro_2_5.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 150,
                        top: 137,
                        child: Container(
                          width: 85,
                          height: 85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                            color: Color(0xFFDEE4EB),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/intro_2_3.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Fixed text and button section
              const SizedBox(height: 35),
              Text(
                "1000+\nCollections",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Kardia',
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "From timeless classics to the latest trends — we've got it all.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'Kardia',
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.circle, size: 10, color: Colors.grey),
                  SizedBox(width: 8),
                  Icon(Icons.circle, size: 10, color: Colors.black),
                  SizedBox(width: 8),
                  Icon(Icons.circle, size: 10, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, NamedRoute.onBoardingScreen3);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
