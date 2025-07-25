import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authModule/providers/auth_provider.dart';
import '../../common_functions.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;

  final List<Map<String, dynamic>> orders = [
    {
      "name": "Charcoal Fade Jeans",
      "size": "M",
      "price": 50.0,
      "image": "assets/images/intro_1_3.jpg",
      "status": "Order Placed",
      "date": null,
    },
    {
      "name": "Charcoal Fade Jeans",
      "size": "M",
      "price": 50.0,
      "image": "assets/images/intro_1_3.jpg",
      "status": "Receipt",
      "date": "March 25, 2025",
    },
    {
      "name": "Charcoal Fade Jeans",
      "size": "M",
      "price": 50.0,
      "image": "assets/images/intro_1_3.jpg",
      "status": "Order Placed",
      "date": null,
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
      appBar: CustomAppBar(title: 'Order History', dW: dW),
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
                  ...orders.map((order) => orderCard(order)).toList(),
                  SizedBox(height: dW * 0.1),
                ],
              ),
            ),
    );
  }

  Widget orderCard(Map<String, dynamic> order) {
    return Container(
      margin: EdgeInsets.only(bottom: dW * 0.04),
      padding: EdgeInsets.all(dW * 0.035),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(dW * 0.04),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(dW * 0.025),
            child: Image.asset(
              order['image'],
              height: dW * 0.22,
              width: dW * 0.22,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: dW * 0.035),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        order['name'],
                        style: customTextTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: tS * 15.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      order['status'] == 'Receipt' 
                          ? Icons.check_circle_outline 
                          : Icons.schedule,
                      size: dW * 0.05, 
                      color: order['status'] == 'Receipt' 
                          ? Colors.green 
                          : Colors.orange,
                    ),
                  ],
                ),
                SizedBox(height: dW * 0.01),
                Row(
                  children: [
                    Container(
                      height: dW * 0.035,
                      width: dW * 0.035,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4C372C),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: dW * 0.015),
                    Text("${order['size']}",
                        style: customTextTheme.bodyMedium?.copyWith(
                          fontSize: tS * 13.5,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
                SizedBox(height: dW * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${order['price'].toStringAsFixed(2)}",
                      style: customTextTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: tS * 18,
                      ),
                    ),
                    order['status'] != 'Receipt'
                        ? Text(
                            order['status'],
                            style: customTextTheme.bodySmall?.copyWith(
                              fontSize: tS * 12.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                if (order['status'] == 'Receipt') ...[
                  SizedBox(height: dW * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order['date'],
                        style: customTextTheme.bodySmall?.copyWith(
                          fontSize: tS * 12,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "Delivered",
                        style: customTextTheme.bodySmall?.copyWith(
                          fontSize: tS * 12.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
