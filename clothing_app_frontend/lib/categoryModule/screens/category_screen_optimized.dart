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
    final response = await Provider.of<CategoryProvider>(
      context,
      listen: false,
    ).fetchCategory(query: 'page=1&limit=10');
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
    double topPadding = MediaQuery.of(context).padding.top;
    customTextTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: topPadding),
        child: SizedBox(
          height: dH - topPadding,
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
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: dW * 0.05,
                        right: dW * 0.05,
                        top: dW * 0.02,
                        bottom: dW * 0.25,
                      ),
                      child: Column(
                        children: [
                          Consumer2<CategoryProvider, SubCategoryProvider>(
                            builder: (context, categoryProvider, subCategoryProvider, child) {
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

                              final rawSubCategories =
                                  subCategoryProvider.rawSubCategories;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Static Beautiful Header
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
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(0.4),
                                                  blurRadius: 12,
                                                  spreadRadius: 2,
                                                ),
                                              ],
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

                                  // Dynamic Category sections
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
                                              children: categoryProvider.categories.map((
                                                category,
                                              ) {
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
                                                                            borderRadius: BorderRadius.circular(
                                                                              13,
                                                                            ),
                                                                          ),
                                                                          child: Center(
                                                                            child: Icon(
                                                                              Icons.error_outline,
                                                                              color: Colors.red[600],
                                                                              size:
                                                                                  dW *
                                                                                  0.06,
                                                                            ),
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
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        13,
                                                                      ),
                                                                ),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .image_not_supported,
                                                                    color: Colors
                                                                        .grey[600],
                                                                    size:
                                                                        dW *
                                                                        0.06,
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                      SizedBox(
                                                        height: dW * 0.02,
                                                      ),
                                                      Container(
                                                        width: dW * 0.25,
                                                        child: TextWidget(
                                                          title:
                                                              category
                                                                  .categoryName ??
                                                              'Unknown',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color(
                                                            0xFF76929F,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
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

                                  SizedBox(height: dW * 0.05),

                                  // Products section
                                  if (categoryProvider
                                      .categoryProducts
                                      .isNotEmpty) ...[
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
                                                Icons.shopping_bag,
                                                color: Color(0xFF76929F),
                                                size: 16,
                                              ),
                                              SizedBox(width: dW * 0.02),
                                              TextWidget(
                                                title: "Featured Products",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF76929F),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: dW * 0.03),
                                          CustomBigProductCardGrid(
                                            productData: categoryProvider
                                                .categoryProducts
                                                .take(6)
                                                .map((product) {
                                                  return {
                                                    'product_id':
                                                        product.productId,
                                                    'product_name':
                                                        product.productName,
                                                    'product_price':
                                                        product.productPrice,
                                                    'product_image':
                                                        product.productImage,
                                                    'product_rating':
                                                        double.parse(
                                                          product.productRating
                                                              .toStringAsFixed(
                                                                1,
                                                              ),
                                                        ),
                                                  };
                                                })
                                                .toList(),
                                            onProductTap: (product) {
                                              // Handle product tap
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                        ],
                      ),
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
