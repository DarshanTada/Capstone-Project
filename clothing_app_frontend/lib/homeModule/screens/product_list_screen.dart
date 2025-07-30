import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends State<ProductListScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
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
      // appBar: CustomAppBar(title: 'Title', dW: dW),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              // padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/images/header.png'),

                  SizedBox(height: dW * 0.05),
                  Image.asset('assets/images/p1.png'),
                  SizedBox(height: dW * 0.05),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
                    child: Image.asset('assets/images/filter.png'),
                  ),
                  SizedBox(height: dW * 0.05),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: dW * 0.4,
                              child: Image.asset('assets/images/g1.png'),
                            ),
                            SizedBox(width: dW * 0.02),

                            SizedBox(
                              width: dW * 0.4,
                              child: Image.asset('assets/images/g2.png'),
                            ),
                          ],
                        ),
                        SizedBox(height: dW * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: dW * 0.4,
                              child: Image.asset('assets/images/g3.png'),
                            ),
                            SizedBox(width: dW * 0.02),

                            SizedBox(
                              width: dW * 0.4,
                              child: Image.asset('assets/images/g4.png'),
                            ),
                          ],
                        ),
                        SizedBox(height: dW * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: dW * 0.4,
                              child: Image.asset('assets/images/g5.png'),
                            ),
                            SizedBox(width: dW * 0.02),

                            SizedBox(
                              width: dW * 0.4,
                              child: Image.asset('assets/images/g6.png'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
