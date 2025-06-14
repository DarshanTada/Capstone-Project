import 'package:clothing_app_frontend/authModule/screens/login.dart';
import 'package:flutter/material.dart';

class IntroScreen3 extends StatelessWidget {
  const IntroScreen3({super.key});

  Widget buildColumn(List<String> imagePaths) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: imagePaths.map((path) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 138, // slightly narrower to simulate cropping
              height: 260,
              color: Colors.grey.shade300,
              child: Image.asset(
                path,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          //     child: GridView.count(
          //       crossAxisCount: 3,
          //       mainAxisSpacing: 12,
          //       crossAxisSpacing: 12,
          //       childAspectRatio: 0.66,
          //       physics: const NeverScrollableScrollPhysics(),
          //       children: [
          //         'assets/images/intro_2_1.jpg',
          //         'assets/images/intro_2_2.jpg',
          //         'assets/images/intro_2_3.jpg',
          //         'assets/images/intro_2_4.jpg',
          //         'assets/images/intro_2_5.jpg',
          //         'assets/images/intro_1_3.jpg',
          //       ].map((imagePath) {
          //         return ClipRRect(
          //           borderRadius: BorderRadius.circular(20),
          //           child: Container(
          //             decoration: const BoxDecoration(
          //               color: Colors.blueGrey,
          //             ),
          //             child: Image.asset(
          //               imagePath,
          //               fit: BoxFit.cover,
          //               alignment: const Alignment(0, -0.2),
          //             ),
          //           ),
          //         );
          //       }).toList(),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Center(
              child: OverflowBox(
                maxWidth: MediaQuery.of(context).size.width * 1.15, // wider than screen
                maxHeight: MediaQuery.of(context).size.height * 2, // wider than screen
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildColumn(['assets/images/intro_2_4.jpg', 'assets/images/intro_2_3.jpg']),
                    buildColumn(['assets/images/intro_1_2.jpg', 'assets/images/intro_2_2.jpg']),
                    buildColumn(['assets/images/intro_1_3.jpg', 'assets/images/intro_2_1.jpg']),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 35),
          // Headline
          Text(
            "Curated Just\nfor You",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kardia',
            ),
          ),
          const SizedBox(height: 12),
          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "Discover Trendy Outfits, Chic Accessories,\nCozy Essentials all curated just for You.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Kardia',
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.circle, size: 10, color: Colors.grey),
              SizedBox(width: 8),
              Icon(Icons.circle, size: 10, color: Colors.grey),
              SizedBox(width: 8),
              Icon(Icons.circle, size: 10, color: Colors.black),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 35),
        ],
      ),
    );
  }
}