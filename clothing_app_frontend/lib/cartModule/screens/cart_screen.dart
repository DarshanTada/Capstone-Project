import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authModule/providers/auth_provider.dart';
import '../../common_functions.dart';
import '../../checkoutModule/screens/checkout_screen.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({Key? key}) : super(key: key);

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;

  // Sample cart data
  List<Map<String, dynamic>> cartItems = [
    {
      "name": "Black OverCoat",
      "size": "36",
      "price": 50.00,
      "quantity": 1,
      "image": "assets/images/intro_1_3.jpg"
    },
    {
      "name": "Long Sleeve Leather Coat",
      "size": "L",
      "price": 29.99,
      "quantity": 2,
      "image": "assets/images/intro_1_3.jpg"
    },
  ];

  fetchData() async {}

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    customTextTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'My Cart', dW: dW),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  Widget screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
              child: Column(
                children: [
                  SizedBox(height: dW * 0.05),
                  ...cartItems.map((item) => cartItemCard(item)).toList(),
                  SizedBox(height: dW * 0.05),
                  discountBox(),
                  SizedBox(height: dW * 0.04),
                  orderSummarySection(),
                  SizedBox(height: dW * 0.06),
                  checkoutButton(),
                  SizedBox(height: dW * 0.1),
                ],
              ),
            ),
    );
  }

  Widget cartItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: dW * 0.25,
            height: dW * 0.28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(item['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: dW * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'],
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text("Size: ${item['size']}", style: const TextStyle(fontSize: 13)),
                SizedBox(height: 4),
                Text("\$${item['price'].toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 13)),
                SizedBox(height: dW * 0.025),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (item['quantity'] > 1) item['quantity']--;
                        });
                      },
                      child: const Icon(Icons.remove_circle_outline),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(item['quantity'].toString(),
                          style: const TextStyle(fontSize: 15)),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          item['quantity']++;
                        });
                      },
                      child: const Icon(Icons.add_circle_outline),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          cartItems.remove(item);
                        });
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget discountBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text("Enter a discount coupon", style: TextStyle(fontSize: 14)),
          ),
          Text("APPLY",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Widget orderSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        orderRow("Sub-total", "\$79.99"),
        orderRow("Delivery Fee", "\$5.99"),
        orderRow("Discount", "- \$4.99", color: Colors.green),
        const Divider(),
        orderRow("Total", "\$80.99", isBold: true),
      ],
    );
  }

  Widget orderRow(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : null)),
          Text(value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : null,
                color: color,
              )),
        ],
      ),
    );
  }

  Widget checkoutButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CheckoutScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB08C6E),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: Size(double.infinity, dW * 0.13),
      ),
      child: const Text(
        'Checkout',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
