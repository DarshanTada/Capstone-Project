import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authModule/providers/auth_provider.dart';
import '../../common_functions.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.brown.shade300),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.brown.shade300),
            onPressed: () {
              // Add filter functionality
            },
          ),
        ],
      ),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  Widget screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
          : orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(dW * 0.1),
                        decoration: BoxDecoration(
                          color: Color(0xFFD2B193).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: dW * 0.15,
                          color: Color(0xFFB8956A),
                        ),
                      ),
                      SizedBox(height: dH * 0.03),
                      Text(
                        'No Orders Yet',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: dH * 0.01),
                      Text(
                        'Start shopping to see your orders here',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: dH * 0.02),
                      Text(
                        '${orders.length} Orders',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: dH * 0.02),
                      ...orders.map((order) => orderCard(order)),
                      SizedBox(height: dH * 0.1),
                    ],
                  ),
                ),
    );
  }

  Widget orderCard(Map<String, dynamic> order) {
    return Container(
      margin: EdgeInsets.only(bottom: dH * 0.02),
      padding: EdgeInsets.all(dW * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    order['image'],
                    height: dW * 0.24,
                    width: dW * 0.24,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: dW * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            order['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: order['status'] == 'Receipt' 
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            order['status'] == 'Receipt' 
                                ? Icons.check_circle_outline 
                                : Icons.schedule,
                            size: 18, 
                            color: order['status'] == 'Receipt' 
                                ? Colors.green.shade600
                                : Colors.orange.shade600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: dH * 0.012),
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Color(0xFFD2B193),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFFB8956A),
                              width: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Size ${order['size']}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: dH * 0.015),
                    Text(
                      "\$${order['price'].toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Color(0xFFB8956A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: dH * 0.02),
          Container(
            padding: EdgeInsets.symmetric(vertical: dH * 0.015, horizontal: dW * 0.04),
            decoration: BoxDecoration(
              color: order['status'] == 'Receipt' 
                  ? Colors.green.withOpacity(0.05)
                  : Colors.orange.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: order['status'] == 'Receipt' 
                    ? Colors.green.withOpacity(0.2)
                    : Colors.orange.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['status'] == 'Receipt' ? 'Delivered' : 'Order Status',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      order['status'] == 'Receipt' 
                          ? order['date'] ?? 'Delivered'
                          : order['status'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: order['status'] == 'Receipt' 
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: order['status'] == 'Receipt' 
                        ? Colors.green.shade600
                        : Colors.orange.shade600,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order['status'] == 'Receipt' ? 'View Receipt' : 'Track Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
