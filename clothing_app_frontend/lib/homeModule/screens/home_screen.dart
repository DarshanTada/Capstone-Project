import 'dart:convert';
import 'dart:typed_data';

import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/homeModule/provider/home_provider.dart';
import 'package:clothing_app_frontend/homeModule/widgets/custom_big_product_card_grid.dart';
import 'package:clothing_app_frontend/homeModule/widgets/custom_small_product_card_grid.dart';
import 'package:clothing_app_frontend/navigation/arguments.dart';
import 'package:clothing_app_frontend/navigation/navigators.dart';
import 'package:clothing_app_frontend/navigation/routes.dart';
import 'package:clothing_app_frontend/searchModule/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authModule/providers/auth_provider.dart';
import '../../common_functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
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
  int selectedCategoryIndex = 0;
  final TextEditingController searchController = TextEditingController();
  // final List<String> categories = ['all', 'men', 'women', 'boys', 'girls'];
  final List<String> productImages = [
    'assets/images/g1.png',
    'assets/images/g2.png',
    'assets/images/g3.png',
    'assets/images/g4.png',
    'assets/images/g5.png',
    'assets/images/g6.png',
    'assets/images/g1.png',
    'assets/images/g2.png',
    'assets/images/g3.png',
  ];

  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String.split(',').last);
  }

  fetchHomeData() async {
    final response = await Provider.of<HomeProvider>(
      context,
      listen: false,
    ).fetchHomeData();
    if (!response['success']) {
      showSnackbar(response['message']);
    }
  }

  fetchData() async {
    await fetchHomeData();
  }

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

    // Get the top padding (notch height)
    double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: isLoading
          ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
          : GestureDetector(
              onTap: () => hideKeyBoard(),
              child: Container(
                margin: EdgeInsets.only(
                  top:
                      topPadding, // This prevents content from going into notch area
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  clipBehavior:
                      Clip.hardEdge, // This prevents scrolling beyond bounds
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: dW * 0.02, // Just a small top spacing now
                      bottom: dW * 0.25, // Space for floating nav bar
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: dW * 0.05),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SearchScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xffF2F2F2),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: dW * 0.04,
                                          ),
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: dW * 0.02),
                                        Expanded(
                                          child: Text(
                                            language['personalizedSearch'] ??
                                                'Personalized Search',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: dW * 0.025),
                              GestureDetector(
                                onTap: () {
                                  pushAndRemoveUntil(
                                    NamedRoute.bottomNavBarScreen,
                                    arguments: BottomNavArgumnets(index: 4),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 22,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: dW * 0.49,
                              width: dW,
                              margin: EdgeInsets.only(
                                top: dW * 0.03,
                                bottom: dW * 0.05,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.asset(
                                'assets/images/corousel/home_section_1.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        TextWidget(
                          textAlign: TextAlign.center,
                          title: language['chicStartsHere'],
                          fontSize: tS * 22,
                        ),
                        SizedBox(height: dW * 0.05),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
                          child: Wrap(
                            spacing: dW * 0.025,
                            runSpacing: dW * 0.04,
                            children: [
                              SizedBox(
                                width: dW * 0.275,
                                height: dW * 0.3125,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                  ),
                                  child: Image.asset(
                                    "assets/images/jeans/pant1.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: dW * 0.275,
                                height: dW * 0.3125,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(70),
                                    bottomLeft: Radius.circular(70),
                                    bottomRight: Radius.circular(70),
                                  ),
                                  child: Image.asset(
                                    "assets/images/tops/top1.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: dW * 0.275,
                                height: dW * 0.3125,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(70),
                                    bottomRight: Radius.circular(70),
                                  ),
                                  child: Image.asset(
                                    "assets/images/jeans/pant2.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: dW * 0.275,
                                height: dW * 0.3125,
                                child: Image.asset(
                                  "assets/images/product_1_4.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: dW * 0.275,
                                height: dW * 0.3125,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(70),
                                    bottomLeft: Radius.circular(70),
                                    bottomRight: Radius.circular(70),
                                  ),
                                  child: Image.asset(
                                    "assets/images/jeans/pant5.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 56,
                                backgroundImage: AssetImage(
                                  'assets/images/g5.png',
                                ),
                              ),
                              SizedBox(
                                width: dW * 0.275,
                                height: dW * 0.3125,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(70),
                                    bottomLeft: Radius.circular(70),
                                    bottomRight: Radius.circular(70),
                                  ),
                                  child: Image.asset(
                                    "assets/images/tops/top2.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: dW * 0.275,
                                height: dW * 0.3125,
                                child: Image.asset(
                                  'assets/images/intro_1_3.jpg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(
                                width: dW * 0.275,
                                height: dW * 0.3125,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(70),
                                    bottomLeft: Radius.circular(70),
                                  ),
                                  child: Image.asset(
                                    'assets/images/intro_2_5.jpg',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: dW * 0.08),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Image.asset("assets/images/b1.png"),
                              SizedBox(width: dW * 0.02),
                              Image.asset("assets/images/b2.png"),
                            ],
                          ),
                        ),
                        SizedBox(height: dW * 0.05),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: dW * 0.05,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TextWidget(
                                        title: 'You may like',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          push(
                                            NamedRoute.categoryRelationScreen,
                                            arguments:
                                                CategoryRelationScreenArguments(
                                                  category: 'Tops',
                                                ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            TextWidget(
                                              title: "View all",
                                              fontSize: 15,
                                            ),
                                            SizedBox(width: dW * 0.01),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: dW * 0.05),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomSmallProductCardGrid(
                                        imageUrl:
                                            'assets/products/6_jeans/wide_leg_jeans/product_6_1.png',

                                        price: '50',
                                        rating: 3.9,
                                        onTap: () {
                                          push(
                                            NamedRoute.productDetailScreen,
                                            arguments:
                                                ProductDetailScreenArguments(
                                                  productId:
                                                      '689152132a5e3b6ee475dd87',
                                                ),
                                          );

                                          //   }
                                        },
                                      ),
                                      CustomSmallProductCardGrid(
                                        imageUrl:
                                            'assets/products/6_jeans/baggy/product_6_3.png',

                                        price: '44',
                                        rating: 4.7,
                                        onTap: () {},
                                      ),
                                      CustomSmallProductCardGrid(
                                        imageUrl:
                                            'assets/products/2_tops/bodyfit_tops/product_2_2.png',

                                        price: '90',
                                        rating: 4.5,
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: dW * 0.02),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          CustomSmallProductCardGrid(
                                            imageUrl:
                                                'assets/products/7_shirts/cotton_shirts/product_7_2.png',
                                            price: '90',
                                            rating: 4.5,
                                            onTap: () {},
                                          ),
                                          SizedBox(height: dW * 0.02),

                                          CustomSmallProductCardGrid(
                                            imageUrl:
                                                'assets/products/8_t-shirts/collar_tshirts/product_8_3.png',

                                            price: '90',
                                            rating: 4.5,
                                            onTap: () {},
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: dW * 0.01),
                                      CustomBigProductCardGridWidget(
                                        productName: 'Charcoal Fade Jeans',
                                        imageUrl:
                                            'assets/products/7_shirts/jeans_shirts/product_7_1.png',

                                        price: '90',
                                        rating: 4.5,
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: dW * 0.05),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
