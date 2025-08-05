import 'dart:convert';
import 'dart:typed_data';

import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/homeModule/provider/category_provider.dart';
import 'package:clothing_app_frontend/homeModule/provider/subcategory_provider.dart';
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

  late ScrollController _scrollController;

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

  fetchAllSubCategories() async {
    final response = await Provider.of<SubCategoryProvider>(
      context,
      listen: false,
    ).fetchAllSubCategories();
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
    await fetchAllSubCategories();
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                child: RefreshIndicator(
                  onRefresh: () async {
                    await fetchData();
                  },
                  color: Color(0xFF76929F),
                  child: SingleChildScrollView(
                    controller: _scrollController,
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
                          Consumer2<CategoryProvider, SubCategoryProvider>(
                            builder: (context, categoryProvider, subCategoryProvider, child) {
                              // Show loading state with enhanced animation
                              if (isLoading ||
                                  categoryProvider.categories.isEmpty) {
                                return Column(
                                  children: [
                                    SizedBox(height: dH * 0.25),
                                    Container(
                                      padding: EdgeInsets.all(dW * 0.08),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(
                                              0xFF76929F,
                                            ).withOpacity(0.1),
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF76929F),
                                                  Color(0xFF8BA5B1),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                              strokeWidth: 3,
                                            ),
                                          ),
                                          SizedBox(height: dW * 0.04),
                                          TextWidget(
                                            title: "Loading Categories...",
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF76929F),
                                          ),
                                          SizedBox(height: dW * 0.02),
                                          TextWidget(
                                            title:
                                                "Discovering amazing products for you",
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }

                              // Get raw subcategory data
                              final rawSubCategories =
                                  subCategoryProvider.rawSubCategories;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Static Page Header with Clothing Theme
                                  Container(
                                    margin: EdgeInsets.only(bottom: dW * 0.05),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF76929F),
                                          Color(0xFF8BA5B1),
                                          Color(0xFF9CB8C4),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(
                                            0xFF76929F,
                                          ).withOpacity(0.4),
                                          blurRadius: 15,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(dW * 0.04),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: dW * 0.1,
                                            height: dW * 0.1,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.25,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                color: Colors.white.withOpacity(
                                                  0.4,
                                                ),
                                                width: 2,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.checkroom,
                                              color: Colors.white,
                                              size: dW * 0.06,
                                            ),
                                          ),
                                          SizedBox(width: dW * 0.03),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextWidget(
                                                  title: "Fashion Categories",
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(height: dW * 0.005),
                                                TextWidget(
                                                  title:
                                                      "Discover your perfect style",
                                                  fontSize: 14,
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: dW * 0.05),

                                  // Dynamic Category sections using raw data
                                  Container(
                                    padding: EdgeInsets.all(dW * 0.03),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.category,
                                              color: Color(0xFF76929F),
                                              size: 16,
                                            ),
                                            SizedBox(width: dW * 0.02),
                                            TextWidget(
                                              title: "Categories",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF76929F),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: dW * 0.02),
                                        Container(
                                          height: dW * 0.35,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            child: Row(
                                              children: categoryProvider.categories.asMap().entries.map((
                                                entry,
                                              ) {
                                                final category = entry.value;

                                                return Container(
                                                  margin: EdgeInsets.only(
                                                    right: dW * 0.03,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: dW * 0.25,
                                                        height: dW * 0.25,
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                    0xFF76929F,
                                                                  ).withOpacity(
                                                                    0.1,
                                                                  ),
                                                                  Color(
                                                                    0xFF8BA5B1,
                                                                  ).withOpacity(
                                                                    0.05,
                                                                  ),
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                          border: Border.all(
                                                            color: Color(
                                                              0xFF76929F,
                                                            ).withOpacity(0.3),
                                                            width: 2,
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                    0.1,
                                                                  ),
                                                              blurRadius: 10,
                                                              offset: Offset(
                                                                0,
                                                                5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        child:
                                                            category.decodedImage !=
                                                                null
                                                            ? ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      13,
                                                                    ),
                                                                child: Image.memory(
                                                                  category
                                                                      .decodedImage!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder:
                                                                      (
                                                                        context,
                                                                        error,
                                                                        stackTrace,
                                                                      ) {
                                                                        return Container(
                                                                          decoration: BoxDecoration(
                                                                            gradient: LinearGradient(
                                                                              colors: [
                                                                                Colors.red[100]!,
                                                                                Colors.red[50]!,
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          child: Icon(
                                                                            Icons.error_outline,
                                                                            color:
                                                                                Colors.red[400],
                                                                            size:
                                                                                30,
                                                                          ),
                                                                        );
                                                                      },
                                                                ),
                                                              )
                                                            : Container(
                                                                decoration: BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                    colors: [
                                                                      Colors
                                                                          .grey[200]!,
                                                                      Colors
                                                                          .grey[100]!,
                                                                    ],
                                                                  ),
                                                                ),
                                                                child: Icon(
                                                                  Icons
                                                                      .image_not_supported_outlined,
                                                                  color: Colors
                                                                      .grey[400],
                                                                  size: 30,
                                                                ),
                                                              ),
                                                      ),
                                                      SizedBox(
                                                        height: dW * 0.02,
                                                      ),
                                                      Container(
                                                        width: dW * 0.25,
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal:
                                                                  dW * 0.02,
                                                              vertical:
                                                                  dW * 0.01,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Color(
                                                            0xFF76929F,
                                                          ).withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: TextWidget(
                                                          title: category.name,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          color: Color(
                                                            0xFF76929F,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: dW * 0.03),

                                  // Enhanced subcategory images section
                                  Container(
                                    padding: EdgeInsets.all(dW * 0.03),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.grid_view,
                                              color: Color(0xFF76929F),
                                              size: 16,
                                            ),
                                            SizedBox(width: dW * 0.02),
                                            TextWidget(
                                              title: "Subcategories",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF76929F),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: dW * 0.02),
                                        Container(
                                          height: dW * 0.4,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            child: Row(
                                              children: rawSubCategories.asMap().entries.map((
                                                entry,
                                              ) {
                                                final subcat = entry.value;
                                                final subcatName =
                                                    subcat['name']
                                                        ?.toString() ??
                                                    'Unknown';
                                                final subcatImage =
                                                    subcat['image']
                                                        ?.toString() ??
                                                    '';
                                                final categoryName =
                                                    subcat['category']?['name']
                                                        ?.toString() ??
                                                    'No category';

                                                Uint8List? decodedImage;
                                                if (subcatImage.isNotEmpty) {
                                                  try {
                                                    final base64Part =
                                                        subcatImage.contains(
                                                          ',',
                                                        )
                                                        ? subcatImage
                                                              .split(',')
                                                              .last
                                                        : subcatImage;
                                                    decodedImage = base64Decode(
                                                      base64Part,
                                                    );
                                                  } catch (e) {
                                                    decodedImage = null;
                                                  }
                                                }

                                                return Container(
                                                  margin: EdgeInsets.only(
                                                    right: dW * 0.03,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: dW * 0.25,
                                                        height: dW * 0.25,
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                    0xFF8BA5B1,
                                                                  ).withOpacity(
                                                                    0.1,
                                                                  ),
                                                                  Color(
                                                                    0xFF76929F,
                                                                  ).withOpacity(
                                                                    0.05,
                                                                  ),
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                          border: Border.all(
                                                            color: Color(
                                                              0xFF8BA5B1,
                                                            ).withOpacity(0.3),
                                                            width: 2,
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                    0.1,
                                                                  ),
                                                              blurRadius: 10,
                                                              offset: Offset(
                                                                0,
                                                                5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        child:
                                                            decodedImage != null
                                                            ? ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      13,
                                                                    ),
                                                                child: Image.memory(
                                                                  decodedImage,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder:
                                                                      (
                                                                        context,
                                                                        error,
                                                                        stackTrace,
                                                                      ) {
                                                                        return Container(
                                                                          decoration: BoxDecoration(
                                                                            gradient: LinearGradient(
                                                                              colors: [
                                                                                Colors.red[100]!,
                                                                                Colors.red[50]!,
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          child: Icon(
                                                                            Icons.error_outline,
                                                                            color:
                                                                                Colors.red[400],
                                                                            size:
                                                                                30,
                                                                          ),
                                                                        );
                                                                      },
                                                                ),
                                                              )
                                                            : Container(
                                                                decoration: BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                    colors: [
                                                                      Colors
                                                                          .grey[200]!,
                                                                      Colors
                                                                          .grey[100]!,
                                                                    ],
                                                                  ),
                                                                ),
                                                                child: Icon(
                                                                  Icons
                                                                      .image_not_supported_outlined,
                                                                  color: Colors
                                                                      .grey[400],
                                                                  size: 30,
                                                                ),
                                                              ),
                                                      ),
                                                      SizedBox(
                                                        height: dW * 0.01,
                                                      ),
                                                      Container(
                                                        width: dW * 0.25,
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal:
                                                                  dW * 0.02,
                                                              vertical:
                                                                  dW * 0.01,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Color(
                                                            0xFF8BA5B1,
                                                          ).withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: TextWidget(
                                                          title: subcatName,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          color: Color(
                                                            0xFF76929F,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: dW * 0.005,
                                                      ),
                                                      Container(
                                                        width: dW * 0.25,
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal:
                                                                  dW * 0.01,
                                                              vertical:
                                                                  dW * 0.005,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey[100],
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6,
                                                              ),
                                                        ),
                                                        child: TextWidget(
                                                          title: categoryName,
                                                          fontSize: 8,
                                                          textAlign:
                                                              TextAlign.center,
                                                          color:
                                                              Colors.grey[600],
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: dW * 0.06),

                                  // Dynamic Category sections using raw data
                                  ...categoryProvider.categories.map((
                                    category,
                                  ) {
                                    // Filter subcategories for this category using raw data
                                    final categorySubcategories = rawSubCategories
                                        .where((subcat) {
                                          try {
                                            final categoryName =
                                                subcat['category']?['name']
                                                    ?.toString()
                                                    .toLowerCase() ??
                                                '';
                                            return categoryName ==
                                                category.name.toLowerCase();
                                          } catch (e) {
                                            return false;
                                          }
                                        })
                                        .take(6)
                                        .toList(); // Take 6 max (5 small + 1 big)

                                    return Column(
                                      children: [
                                        // Category header with "View all" button
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            TextWidget(
                                              title: category.name,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                // Filter subcategories for this specific category
                                                final categorySubcategories =
                                                    rawSubCategories.where((
                                                      subcat,
                                                    ) {
                                                      try {
                                                        final categoryName =
                                                            subcat['category']?['name']
                                                                ?.toString()
                                                                .toLowerCase() ??
                                                            '';
                                                        return categoryName ==
                                                            category.name
                                                                .toLowerCase();
                                                      } catch (e) {
                                                        return false;
                                                      }
                                                    }).toList();

                                                // Get products for this category
                                                final categoryProducts = categoryProvider
                                                    .categoryProducts
                                                    .where((product) {
                                                      try {
                                                        final productCategory =
                                                            product['category']?['name']
                                                                ?.toString()
                                                                .toLowerCase() ??
                                                            '';
                                                        return productCategory ==
                                                            category.name
                                                                .toLowerCase();
                                                      } catch (e) {
                                                        return false;
                                                      }
                                                    })
                                                    .toList();

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CategoryRelationScreen(
                                                          args: CategoryRelationScreenArguments(
                                                            category:
                                                                category.name,
                                                            subcategories:
                                                                categorySubcategories,
                                                            products:
                                                                categoryProducts,
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

                                        // Category image button
                                        GestureDetector(
                                          onTap: () {
                                            // Filter subcategories for this specific category
                                            final categorySubcategories =
                                                rawSubCategories.where((
                                                  subcat,
                                                ) {
                                                  try {
                                                    final categoryName =
                                                        subcat['category']?['name']
                                                            ?.toString()
                                                            .toLowerCase() ??
                                                        '';
                                                    return categoryName ==
                                                        category.name
                                                            .toLowerCase();
                                                  } catch (e) {
                                                    return false;
                                                  }
                                                }).toList();

                                            // Get products for this category
                                            final categoryProducts = categoryProvider
                                                .categoryProducts
                                                .where((product) {
                                                  try {
                                                    final productCategory =
                                                        product['category']?['name']
                                                            ?.toString()
                                                            .toLowerCase() ??
                                                        '';
                                                    return productCategory ==
                                                        category.name
                                                            .toLowerCase();
                                                  } catch (e) {
                                                    return false;
                                                  }
                                                })
                                                .toList();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoryRelationScreen(
                                                      args: CategoryRelationScreenArguments(
                                                        category: category.name,
                                                        subcategories:
                                                            categorySubcategories,
                                                        products:
                                                            categoryProducts,
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: dW * 0.04,
                                              vertical: dW * 0.02,
                                            ),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child:
                                                      category.decodedImage !=
                                                          null
                                                      ? Image.memory(
                                                          category
                                                              .decodedImage!,
                                                          fit: BoxFit.cover,
                                                          width: dW * 0.15,
                                                          height: dW * 0.15,
                                                          errorBuilder:
                                                              (
                                                                context,
                                                                error,
                                                                stackTrace,
                                                              ) {
                                                                return Container(
                                                                  width:
                                                                      dW * 0.15,
                                                                  height:
                                                                      dW * 0.15,
                                                                  color: Colors
                                                                      .grey[200],
                                                                  child: Icon(
                                                                    Icons
                                                                        .category,
                                                                  ),
                                                                );
                                                              },
                                                        )
                                                      : Container(
                                                          width: dW * 0.15,
                                                          height: dW * 0.15,
                                                          decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey[200],
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  30,
                                                                ),
                                                          ),
                                                          child: Icon(
                                                            Icons.category,
                                                          ),
                                                        ),
                                                ),
                                                SizedBox(width: dW * 0.03),
                                                Expanded(
                                                  child: TextWidget(
                                                    title: category.name,
                                                    fontSize: tS * 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: dW * 0.03),

                                        // Subcategories display using raw data
                                        if (categorySubcategories
                                            .isNotEmpty) ...[
                                          // First row of subcategories (3 small cards)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: categorySubcategories.take(3).toList().asMap().entries.map((
                                              entry,
                                            ) {
                                              final subcat = entry.value;

                                              // Extract data from raw subcategory
                                              final subcatName =
                                                  subcat['name']?.toString() ??
                                                  'Unknown';
                                              final subcatImage =
                                                  subcat['image']?.toString() ??
                                                  '';
                                              final subcatId =
                                                  subcat['_id']?.toString() ??
                                                  '';

                                              Uint8List? decodedImage;
                                              if (subcatImage.isNotEmpty) {
                                                try {
                                                  final base64Part =
                                                      subcatImage.contains(',')
                                                      ? subcatImage
                                                            .split(',')
                                                            .last
                                                      : subcatImage;
                                                  decodedImage = base64Decode(
                                                    base64Part,
                                                  );
                                                } catch (e) {
                                                  decodedImage = null;
                                                }
                                              }

                                              return Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: dW * 0.01,
                                                  ),
                                                  child: CustomSmallProductCardGrid(
                                                    imageUrl:
                                                        decodedImage != null
                                                        ? null
                                                        : 'assets/images/placeholder.png',
                                                    imageBytes: decodedImage,
                                                    price:
                                                        '${(50 + (subcatId.hashCode % 100))}',
                                                    rating: double.parse(
                                                      (4.0 +
                                                              (subcatId.hashCode %
                                                                      10) /
                                                                  10)
                                                          .toStringAsFixed(1),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CategoryRelationScreen(
                                                                args: CategoryRelationScreenArguments(
                                                                  category:
                                                                      subcatName,
                                                                ),
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),

                                          SizedBox(height: dW * 0.02),

                                          // Second row with 2 small cards and 1 big card
                                          if (categorySubcategories.length > 3)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                // Column with 2 small cards
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    children: categorySubcategories.skip(3).take(2).map((
                                                      subcat,
                                                    ) {
                                                      final subcatName =
                                                          subcat['name']
                                                              ?.toString() ??
                                                          'Unknown';
                                                      final subcatImage =
                                                          subcat['image']
                                                              ?.toString() ??
                                                          '';
                                                      final subcatId =
                                                          subcat['_id']
                                                              ?.toString() ??
                                                          '';

                                                      Uint8List? decodedImage;
                                                      if (subcatImage
                                                          .isNotEmpty) {
                                                        try {
                                                          final base64Part =
                                                              subcatImage
                                                                  .contains(',')
                                                              ? subcatImage
                                                                    .split(',')
                                                                    .last
                                                              : subcatImage;
                                                          decodedImage =
                                                              base64Decode(
                                                                base64Part,
                                                              );
                                                        } catch (e) {
                                                          decodedImage = null;
                                                        }
                                                      }

                                                      return Column(
                                                        children: [
                                                          CustomSmallProductCardGrid(
                                                            imageUrl:
                                                                decodedImage !=
                                                                    null
                                                                ? null
                                                                : 'assets/images/placeholder.png',
                                                            imageBytes:
                                                                decodedImage,
                                                            price:
                                                                '${(60 + (subcatId.hashCode % 80))}',
                                                            rating: double.parse(
                                                              (4.2 +
                                                                      (subcatId.hashCode %
                                                                              8) /
                                                                          10)
                                                                  .toStringAsFixed(
                                                                    1,
                                                                  ),
                                                            ),
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (
                                                                        context,
                                                                      ) => CategoryRelationScreen(
                                                                        args: CategoryRelationScreenArguments(
                                                                          category:
                                                                              subcatName,
                                                                        ),
                                                                      ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          if (categorySubcategories
                                                                  .indexOf(
                                                                    subcat,
                                                                  ) <
                                                              categorySubcategories
                                                                      .length -
                                                                  1)
                                                            SizedBox(
                                                              height: dW * 0.02,
                                                            ),
                                                        ],
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                SizedBox(width: dW * 0.02),

                                                // Big card featuring the category
                                                Expanded(
                                                  flex: 2,
                                                  child: CustomBigProductCardGridWidget(
                                                    productName:
                                                        'Featured ${category.name}',
                                                    imageUrl:
                                                        category.decodedImage !=
                                                            null
                                                        ? null
                                                        : 'assets/images/placeholder.png',
                                                    imageBytes:
                                                        category.decodedImage,
                                                    price:
                                                        '${(100 + (category.id.hashCode % 50))}',
                                                    rating: double.parse(
                                                      (4.5 +
                                                              (category.id.hashCode %
                                                                      5) /
                                                                  10)
                                                          .toStringAsFixed(1),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CategoryRelationScreen(
                                                                args: CategoryRelationScreenArguments(
                                                                  category:
                                                                      category
                                                                          .name,
                                                                ),
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ] else ...[
                                          // Show placeholder when no subcategories
                                          Container(
                                            padding: EdgeInsets.all(dW * 0.04),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.grey[300]!,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.category_outlined,
                                                  size: dW * 0.1,
                                                  color: Colors.grey[400],
                                                ),
                                                SizedBox(height: dW * 0.02),
                                                TextWidget(
                                                  title:
                                                      'No subcategories available for ${category.name}',
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],

                                        SizedBox(height: dW * 0.08),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ), // This closes RefreshIndicator child
                  ), // This closes RefreshIndicator
                ),
              ), // This closes Expanded
            ],
          ),
        ),
      ),
    );
  }
}
