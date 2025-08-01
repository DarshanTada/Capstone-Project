import 'dart:convert';
import 'dart:typed_data';

import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/homeModule/provider/category_provider.dart';
import 'package:clothing_app_frontend/homeModule/screens/category_relation_screen.dart';
import 'package:clothing_app_frontend/homeModule/widgets/custom_big_product_card_grid.dart';
import 'package:clothing_app_frontend/homeModule/widgets/custom_small_product_card_grid.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/navigation/arguments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;

  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String.split(',').last);
  }

  fetchCategories() async {
    final response = await Provider.of<CategoryProvider>(context, listen: false)
        .fetchCategory(
          // accessToken: User.accessToken,
          query: 'page=1&limit=10',
        );
    if (!response['success']) {
      showSnackbar(response['message']);
    }
  }

  fetchProductsByCategory({String? bodyType}) async {
    setState(() {
      isLoading = true;
    });
    final response = await Provider.of<CategoryProvider>(
      context,
      listen: false,
    ).getProductsByCategory(bodyType: '');
    if (!response['success']) {
      showSnackbar(response['message']);
    }
    setState(() {
      isLoading = false;
    });
  }

  fetchData() async {
    await fetchCategories();
    await fetchProductsByCategory();
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

    // Get the top padding (notch height)
    double topPadding = MediaQuery.of(context).padding.top;

    customTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(
          top: topPadding, // This prevents content from going into notch area
        ),
        child: SizedBox(
          height: dH - topPadding, // Adjust height to account for top margin
          width: dW,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  clipBehavior:
                      Clip.hardEdge, // This prevents scrolling beyond bounds
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: dW * 0.05,
                      right: dW * 0.05,
                      top: dW * 0.02, // Small top spacing
                      bottom: dW * 0.25, // Space for floating nav bar
                    ),
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
                                            CategoryRelationScreen(
                                              args:
                                                  CategoryRelationScreenArguments(
                                                    category: 'Jeans',
                                                  ),
                                            ),
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
                                      Icon(Icons.arrow_forward_ios, size: 14),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: dW * 0.05),

                            // JEANS SECTION - USING ACTUAL ASSET IMAGES
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // First jeans product - Baggy jeans
                                CustomSmallProductCardGrid(
                                  imageUrl:
                                      'assets/products/6_jeans/baggy/product_6_1.png',
                                  price: '89',
                                  rating: 4.5,
                                  onTap: () {},
                                ),

                                // Second jeans product - Skinny jeans
                                CustomSmallProductCardGrid(
                                  imageUrl:
                                      'assets/products/6_jeans/skinny_jeans/product_6_2.png',
                                  price: '95',
                                  rating: 4.7,
                                  onTap: () {},
                                ),

                                // Third jeans product - Ripped jeans
                                CustomSmallProductCardGrid(
                                  imageUrl:
                                      'assets/products/6_jeans/ripped_jeans/product_6_1.png',
                                  price: '78',
                                  rating: 4.3,
                                  onTap: () {},
                                ),
                              ],
                            ),
                            SizedBox(height: dW * 0.02),

                            // Second row for Jeans
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    // Fourth jeans product - Wide leg jeans
                                    CustomSmallProductCardGrid(
                                      imageUrl:
                                          'assets/products/6_jeans/wide_leg_jeans/product_6_1.png',
                                      price: '110',
                                      rating: 4.8,
                                      onTap: () {},
                                    ),
                                    SizedBox(height: dW * 0.02),

                                    // Fifth jeans product - Splatter loose fit
                                    CustomSmallProductCardGrid(
                                      imageUrl:
                                          'assets/products/6_jeans/splatter_loose_fit_jeans/product_6_1.png',
                                      price: '92',
                                      rating: 4.4,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                                SizedBox(width: dW * 0.01),

                                // Big jeans product card - Featured baggy jeans
                                CustomBigProductCardGridWidget(
                                  productName: 'Premium Baggy Jeans',
                                  imageUrl:
                                      'assets/products/6_jeans/baggy/product_6_2.png',
                                  price: '125',
                                  rating: 4.9,
                                  onTap: () {},
                                ),
                              ],
                            ),

                            SizedBox(height: dW * 0.08),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextWidget(
                                  title: 'Shorts',
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
                                            CategoryRelationScreen(
                                              args:
                                                  CategoryRelationScreenArguments(
                                                    category: 'Shorts',
                                                  ),
                                            ),
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
                                      Icon(Icons.arrow_forward_ios, size: 14),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: dW * 0.05),

                            // SHORTS SECTION - USING ACTUAL ASSET IMAGES
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // First shorts product - Jeans shorts
                                CustomSmallProductCardGrid(
                                  imageUrl:
                                      'assets/products/4_shorts/jeans_shorts/product_4_1.png',
                                  price: '45',
                                  rating: 4.2,
                                  onTap: () {},
                                ),

                                // Second shorts product - Linen shorts
                                CustomSmallProductCardGrid(
                                  imageUrl:
                                      'assets/products/4_shorts/linen_shorts/product_4_1.png',
                                  price: '52',
                                  rating: 4.6,
                                  onTap: () {},
                                ),

                                // Third shorts product - Another jeans shorts
                                CustomSmallProductCardGrid(
                                  imageUrl:
                                      'assets/products/4_shorts/jeans_shorts/product_4_2.png',
                                  price: '38',
                                  rating: 4.1,
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
                                    // Fourth shorts product - Jeans shorts variant
                                    CustomSmallProductCardGrid(
                                      imageUrl:
                                          'assets/products/4_shorts/jeans_shorts/product_4_2.png',
                                      price: '65',
                                      rating: 4.5,
                                      onTap: () {},
                                    ),
                                    SizedBox(height: dW * 0.02),

                                    // Fifth shorts product - Linen shorts variant
                                    CustomSmallProductCardGrid(
                                      imageUrl:
                                          'assets/products/5_skirts/glitter_skirt/product_5_1.png',
                                      price: '42',
                                      rating: 4.0,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                                SizedBox(width: dW * 0.01),

                                // Big shorts product card
                                CustomBigProductCardGridWidget(
                                  productName: 'Summer Denim Shorts',
                                  imageUrl:
                                      'assets/products/4_shorts/jeans_shorts/product_4_2.png',
                                  price: '75',
                                  rating: 4.7,
                                  onTap: () {},
                                ),
                              ],
                            ),

                            SizedBox(height: dW * 0.08),

                            // T-SHIRTS SECTION
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextWidget(
                                  title: 'T-Shirts',
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
                                            CategoryRelationScreen(
                                              args:
                                                  CategoryRelationScreenArguments(
                                                    category: 'T-Shirts',
                                                  ),
                                            ),
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
                                      Icon(Icons.arrow_forward_ios, size: 14),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: dW * 0.05),

                            // T-SHIRTS SECTION - USING ACTUAL ASSET IMAGES WITH FALLBACK
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // First t-shirt - Collar t-shirt
                                CustomSmallProductCardGrid(
                                  imageUrl:
                                      'assets/products/8_t-shirts/collar_tshirts/product_8_1.png',
                                  price: '25',
                                  rating: 4.3,
                                  onTap: () {},
                                ),

                                // Second t-shirt - Wide t-shirt
                                CustomSmallProductCardGrid(
                                  imageUrl:
                                      'assets/products/8_t-shirts/wide_tshirts/product_8_4.png',
                                  price: '30',
                                  rating: 4.5,
                                  onTap: () {},
                                ),

                                // Third t-shirt - Another collar t-shirt or fallback to cotton shirt
                                CustomSmallProductCardGrid(
                                  imageUrl:
                                      'assets/products/8_t-shirts/collar_tshirts/product_8_2.png',
                                  price: '28',
                                  rating: 4.2,
                                  onTap: () {},
                                ),
                              ],
                            ),
                            SizedBox(height: dW * 0.02),

                            // Second row for T-shirts with fallback to shirts
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    // Fourth item - Wide t-shirt
                                    CustomSmallProductCardGrid(
                                      imageUrl:
                                          'assets/products/8_t-shirts/wide_tshirts/product_8_5.png',
                                      price: '32',
                                      rating: 4.4,
                                      onTap: () {},
                                    ),
                                    SizedBox(height: dW * 0.02),

                                    // Fifth item - Fallback to cotton shirt since we need more items
                                    CustomSmallProductCardGrid(
                                      imageUrl:
                                          'assets/products/7_shirts/cotton_shirts/product_7_1.png',
                                      price: '35',
                                      rating: 4.6,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                                SizedBox(width: dW * 0.01),

                                // Big t-shirt product card - Featured collar t-shirt
                                CustomBigProductCardGridWidget(
                                  productName: 'Premium Collar T-Shirt',
                                  imageUrl:
                                      'assets/products/8_t-shirts/collar_tshirts/product_8_3.png',
                                  price: '40',
                                  rating: 4.8,
                                  onTap: () {},
                                ),
                              ],
                            ),

                            // Rest of your existing UI (banners, categories, etc.)
                            SizedBox(height: dW * 0.08),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset("assets/images/b1.png"),
                                  SizedBox(width: dW * 0.02),
                                  Image.asset("assets/images/b2.png"),
                                ],
                              ),
                            ),
                            SizedBox(height: dW * 0.06),

                            // Category buttons with actual asset images
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoryRelationScreen(
                                          args: CategoryRelationScreenArguments(
                                            category: 'Jeans',
                                          ),
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFF76929F),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: dW * 0.04,
                                  vertical: dW * 0.02,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.asset(
                                        "assets/products/6_jeans/baggy/product_6_1.png",
                                        fit: BoxFit.cover,
                                        width: dW * 0.15,
                                        height: dW * 0.15,
                                      ),
                                    ),
                                    SizedBox(width: dW * 0.03),
                                    TextWidget(
                                      title: language['jeans'] ?? 'Jeans',
                                      fontSize: tS * 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: dW * 0.025),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoryRelationScreen(
                                          args: CategoryRelationScreenArguments(
                                            category: 'T-Shirts',
                                          ),
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFF76929F),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: dW * 0.04,
                                  vertical: dW * 0.02,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.asset(
                                        "assets/products/8_t-shirts/collar_tshirts/product_8_1.png",
                                        fit: BoxFit.cover,
                                        width: dW * 0.15,
                                        height: dW * 0.15,
                                      ),
                                    ),
                                    SizedBox(width: dW * 0.03),
                                    TextWidget(
                                      title: language['shirts'] ?? 'T-Shirts',
                                      fontSize: tS * 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: dW * 0.025),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoryRelationScreen(
                                          args: CategoryRelationScreenArguments(
                                            category: 'Shorts',
                                          ),
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFF76929F),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: dW * 0.04,
                                  vertical: dW * 0.02,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.asset(
                                        "assets/products/4_shorts/jeans_shorts/product_4_1.png",
                                        fit: BoxFit.cover,
                                        width: dW * 0.15,
                                        height: dW * 0.15,
                                      ),
                                    ),
                                    SizedBox(width: dW * 0.03),
                                    TextWidget(
                                      title: language['pants'] ?? 'Shorts',
                                      fontSize: tS * 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: dW * 0.04),

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    // height: dW * 0.675,
                                    child: Image.asset(
                                      "assets/images/b3.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: dW * 0.02),
                                  Image.asset("assets/images/b4.png"),
                                  SizedBox(width: dW * 0.02),
                                  Image.asset("assets/images/b5.png"),
                                ],
                              ),
                            ),
                            SizedBox(height: dW * 0.05),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
