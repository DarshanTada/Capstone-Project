import 'package:flutter/material.dart';

void main() => runApp(IntroApp());

class IntroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IntroScreen extends StatelessWidget {
  final String imagePath = 'assets/image3.png';

  Widget _buildCircle(double size, double left, double top) {
    return Positioned(
      left: left,
      top: top,
      child: ClipOval(
        child: Image.asset(
          imagePath,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 50),
          SizedBox(
            height: 200, // Set a fixed height for the Stack
            width: double.infinity,
            child: Stack(
              children: [
                _buildCircle(80, 50, 0),
                _buildCircle(100, 110, 20),
                _buildCircle(40, 90, 80),
                _buildCircle(90, 30, 90),
                _buildCircle(110, 100, 110),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Headline
          Text(
            "Discover Good\nquality Fashion!",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kardia',
            ),
          ),
          const SizedBox(height: 16),
          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum lorem",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Kardia',
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Page indicators
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
          const SizedBox(height: 32),
          // Circular Button
          Center(
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
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
