import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
import 'package:clothing_app_frontend/common_widgets/custom_big_product_card_grid.dart';
import 'package:clothing_app_frontend/common_widgets/custom_small_product_card_grid.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/homeModule/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
      // appBar: CustomAppBar(
      //   title: '',
      //   dW: dW,
      //   leading: Container(child: Icon(Icons.person)),
      // ),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
          : Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: dW * 0.05),
                      width: 40, // Set width and height to make it a circle
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey, // Grey 6
                        shape: BoxShape.circle, // Circular shape
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ), // Optional: set icon color
                    ),
                  ],
                ),
                SizedBox(height: dW * 0.01),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: dW * 0.05),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextWidget(
                                  title: 'Jeans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductListScreen(),
                                      ),
                                    );
                                  },
                                  child: TextWidget(
                                    title: "View all >",
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: dW * 0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomSmallProductCardGrid(
                                  imageUrl: 'https://tinyurl.com/42s53ezd',
                                  price: '50',
                                  rating: 3.9,
                                  onTap: () {},
                                ),
                                CustomSmallProductCardGrid(
                                  imageUrl: 'https://tinyurl.com/5n8zedmz',
                                  price: '44',
                                  rating: 4.7,
                                  onTap: () {},
                                ),
                                CustomSmallProductCardGrid(
                                  imageUrl:
                                      'https://m.media-amazon.com/images/I/61emW3sXLOL._AC_SX679_.jpg',
                                  price: '90',
                                  rating: 4.5,
                                  onTap: () {},
                                ),
                              ],
                            ),
                            SizedBox(height: dW * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    CustomSmallProductCardGrid(
                                      imageUrl: 'https://tinyurl.com/ek2mf8hb',
                                      price: '90',
                                      rating: 4.5,
                                      onTap: () {},
                                    ),
                                    SizedBox(height: dW * 0.02),

                                    CustomSmallProductCardGrid(
                                      imageUrl: 'https://tinyurl.com/2jjbmthn',
                                      price: '90',
                                      rating: 4.5,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                                SizedBox(width: dW * 0.01),
                                CustomBigProductCardGrid(
                                  imageUrl: 'https://tinyurl.com/2jjbmthn',
                                  price: '90',
                                  rating: 4.5,
                                  onTap: () {},
                                ),
                              ],
                            ),
                            SizedBox(height: dW * 0.05),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextWidget(
                                  title: 'Shorts',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                                Spacer(),
                                TextWidget(title: "View all >", fontSize: 15),
                              ],
                            ),
                            SizedBox(height: dW * 0.05),
                            // shorts
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomSmallProductCardGrid(
                                  imageUrl: 'https://tinyurl.com/5mk4f9jy',
                                  price: '50',
                                  rating: 3.9,
                                  onTap: () {},
                                ),
                                CustomSmallProductCardGrid(
                                  imageUrl: 'https://tinyurl.com/5n8zedmz',
                                  price: '44',
                                  rating: 4.7,
                                  onTap: () {},
                                ),
                                CustomSmallProductCardGrid(
                                  imageUrl:
                                      'https://m.media-amazon.com/images/I/61emW3sXLOL._AC_SX679_.jpg',
                                  price: '90',
                                  rating: 4.5,
                                  onTap: () {},
                                ),
                              ],
                            ),
                            SizedBox(height: dW * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    CustomSmallProductCardGrid(
                                      imageUrl: 'https://tinyurl.com/ek2mf8hb',
                                      price: '90',
                                      rating: 4.5,
                                      onTap: () {},
                                    ),
                                    SizedBox(height: dW * 0.02),

                                    CustomSmallProductCardGrid(
                                      imageUrl: 'https://tinyurl.com/2jjbmthn',
                                      price: '90',
                                      rating: 4.5,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                                SizedBox(width: dW * 0.01),
                                CustomBigProductCardGrid(
                                  imageUrl: 'https://tinyurl.com/2jjbmthn',
                                  price: '90',
                                  rating: 4.5,
                                  onTap: () {},
                                ),
                              ],
                            ),
                            SizedBox(height: dW * 0.05),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset("assets/images/b1.png"),
                                  Image.asset("assets/images/b2.png"),
                                ],
                              ),
                            ),
                            SizedBox(height: dW * 0.04),

                            Image.asset('assets/images/list.png'),
                            SizedBox(height: dW * 0.04),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset("assets/images/b3.png"),
                                  Image.asset("assets/images/b4.png"),
                                  Image.asset("assets/images/b5.png"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Image.asset('assets/images/tabBar1.png'),
              ],
            ),
    );
  }
}
