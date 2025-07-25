import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authModule/providers/auth_provider.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/circular_loader.dart';
import '../../common_widgets/text_widget.dart';
import '../../common_functions.dart';
import '../../navigation/routes.dart';
import '../../homeModule/screens/product_list_screen.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({Key? key}) : super(key: key);

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  bool showGif = true;

  fetchData() async {}

  @override
  void initState() {
    super.initState();
    fetchData();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showGif = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    customTextTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(title: 'Order Status', dW: dW),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  Widget screenBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dW * 0.07),
      child: isLoading
          ? Center(
              child: CircularLoader(android: dW * 0.08, iOS: dW * 0.035),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: showGif
                      ? Image.asset(
                          'assets/videos/order_success.gif',
                          height: dH * 0.2,
                          key: const ValueKey('gif'),
                          fit: BoxFit.contain,
                        )
                      : Icon(
                          Icons.check_circle,
                          size: dH * 0.2,
                          color: const Color(0xFFA06B3A), // Dark brown
                          key: const ValueKey('icon'),
                        ),
                ),
                SizedBox(height: dH * 0.03),
                TextWidget(
                  title: "Order Placed Successfully!",
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  textAlign: TextAlign.center,
                  color: Colors.black87,
                ),
                SizedBox(height: dH * 0.02),
                TextWidget(
                  title: "Thank you for your purchase.",
                  fontSize: 16,
                  textAlign: TextAlign.center,
                  color: Colors.black54,
                ),
                SizedBox(height: dH * 0.06),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA06B3A), // Primary button
                    minimumSize: Size(double.infinity, dH * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      NamedRoute.orderHistoryScreen,
                    );
                  },
                  child: const Text(
                    'View Order Status',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(height: dH * 0.025),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFA06B3A),
                    side: const BorderSide(color: Color(0xFFA06B3A)),
                    minimumSize: Size(double.infinity, dH * 0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProductListScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Shop More',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
    );
  }
}
