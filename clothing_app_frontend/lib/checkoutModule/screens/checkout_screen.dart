import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../authModule/providers/auth_provider.dart';
import '../../common_functions.dart';
import '../../addressModule/screens/addresses_screen.dart';
import './order_placed_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;

  String selectedPayment = 'Card';

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
      appBar: CustomAppBar(title: 'Checkout', dW: dW),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: dW * 0.05),
                  TextWidget(title: 'Delivery Address', fontSize: 16, fontWeight: FontWeight.bold),
                  SizedBox(height: dW * 0.015),
                  Row(
                    children: [
                      const Icon(Icons.home, size: 20),
                      SizedBox(width: dW * 0.02),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Home", style: TextStyle(fontWeight: FontWeight.w600)),
                            Text("108, University Ave, Waterloo, Canada N2J 2W2",
                                style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddressesScreen(),
                            ),
                          );
                        },
                        child: Text("Change", style: TextStyle(color: Colors.grey.shade600)),
                      ),
                    ],
                  ),
                  SizedBox(height: dW * 0.07),
                  TextWidget(title: 'Payment Method', fontSize: 16, fontWeight: FontWeight.bold),
                  SizedBox(height: dW * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Card', 'PayPal', 'ApplePay'].map((method) {
                      bool isSelected = selectedPayment == method;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: GestureDetector(
                            onTap: () => setState(() => selectedPayment = method),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.black : Colors.white,
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  method == 'ApplePay' ? 'Pay' : method,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: dW * 0.05),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selectedPayment == 'Card' 
                            ? Icons.credit_card 
                            : selectedPayment == 'PayPal'
                            ? Icons.account_balance_wallet
                            : Icons.apple,
                          color: Colors.black54
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            selectedPayment == 'Card'
                              ? "**** **** **** 1234"
                              : selectedPayment == 'PayPal'
                              ? "john.doe@email.com"
                              : "Touch ID / Face ID",
                            style: const TextStyle(fontSize: 16)
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                  SizedBox(height: dW * 0.08),
                  TextWidget(title: 'Order Summary', fontSize: 16, fontWeight: FontWeight.bold),
                  SizedBox(height: dW * 0.03),
                  orderSummaryRow("Sub-total", "\$79.99"),
                  orderSummaryRow("Delivery Fee", "\$5.99"),
                  orderSummaryRow("Discount", "- \$4.99", color: Colors.green),
                  orderSummaryRow("Tax", "\$4.99"),
                  const Divider(),
                  orderSummaryRow("Total", "\$84.99", isBold: true),
                  SizedBox(height: dW * 0.08),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderPlacedScreen(),
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
                      'Place Order',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: dW * 0.12),
                ],
              ),
            ),
    );
  }

  Widget orderSummaryRow(String label, String value,
      {bool isBold = false, Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              )),
          Text(value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color,
              )),
        ],
      ),
    );
  }
}
