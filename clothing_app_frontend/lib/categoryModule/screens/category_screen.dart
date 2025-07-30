import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/homeModule/provider/category_provider.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/homeModule/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:typed_data';

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

  fetchProductsByCategory({String? bodyType, String? gender}) async {
    final response = await Provider.of<CategoryProvider>(context, listen: false)
        .getProductsByCategory(
          bodyType: bodyType ?? 'ectomorph',
          gender: gender ?? 'male',
        );
    if (!response['success']) {
      showSnackbar(response['message']);
    }
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

    customTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final topProducts = categoryProvider.topProducts;
        final bottomProducts = categoryProvider.bottomProducts;
        final banners = categoryProvider.banners;
        final isLoadingProducts = categoryProvider.isLoadingProducts;

        return Container(
          height: dH,
          width: dW,
          color: Colors.grey[50], // Light background like in the image
          child: isLoading || isLoadingProducts
              ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Top section with padding
                      Container(
                        padding: EdgeInsets.all(dW * 0.04),
                        child: Column(
                          children: [
                            // Top Products Section
                            if (topProducts.isNotEmpty) ...[
                              _buildModernProductSection(
                                'Top',
                                topProducts,
                                categoryProvider,
                              ),
                              SizedBox(height: dW * 0.08),
                            ],

                            // Bottom Products Section
                            if (bottomProducts.isNotEmpty) ...[
                              _buildModernProductSection(
                                'Bottom',
                                bottomProducts,
                                categoryProvider,
                              ),
                              SizedBox(height: dW * 0.08),
                            ],

                            // Banners Section
                            if (banners.isNotEmpty) ...[
                              _buildBannersSection(banners),
                              SizedBox(height: dW * 0.08),
                            ],

                            // If no dynamic data, show fallback
                            if (topProducts.isEmpty &&
                                bottomProducts.isEmpty) ...[
                              Container(
                                padding: EdgeInsets.all(dW * 0.1),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.shopping_bag_outlined,
                                      size: dW * 0.2,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: dW * 0.04),
                                    TextWidget(
                                      title: 'No products available',
                                      fontSize: 18,
                                      color: Colors.grey[600]!,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(height: dW * 0.02),
                                    TextWidget(
                                      title:
                                          'Check back later for new arrivals',
                                      fontSize: 14,
                                      color: Colors.grey[500]!,
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
                                    height: dW * 0.675,
                                    child: Image.asset(
                                      "assets/images/b3.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Image.asset("assets/images/b4.png"),
                                  Image.asset("assets/images/b5.png"),
                                ],
                              ),
                            ),

                            ],

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget buildProductSection(
    String sectionName,
    List<dynamic> products,
    CategoryProvider categoryProvider,
  ) {
    if (products.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section header
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(
              title: sectionName,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListScreen()),
                );
              },
              child: Row(
                children: [
                  TextWidget(title: "View all", fontSize: 15),
                  SizedBox(width: dW * 0.01),
                  Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: dW * 0.05),

        // First row of products (3 small cards)
        if (products.length >= 3)
          Row(
            children: [
              for (int i = 0; i < 3 && i < products.length; i++) ...[
                Expanded(
                  child: _buildSmallProductCard(products[i], categoryProvider),
                ),
                if (i < 2)
                  SizedBox(
                    width: dW * 0.02,
                  ), // Add spacing between cards except after the last one
              ],
            ],
          ),

        SizedBox(height: dW * 0.02),

        // Second row (2 small + 1 big card)
        if (products.length >= 6)
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    if (products.length > 3)
                      _buildSmallProductCard(products[3], categoryProvider),
                    SizedBox(height: dW * 0.02),
                    if (products.length > 4)
                      _buildSmallProductCard(products[4], categoryProvider),
                  ],
                ),
              ),
              SizedBox(width: dW * 0.02),
              Expanded(
                flex: 2,
                child: products.length > 5
                    ? _buildBigProductCard(products[5], categoryProvider)
                    : Container(),
              ),
            ],
          )
        else if (products.length > 3)
          // If we have 4-5 products, show them in a different layout
          Row(
            children: [
              if (products.length > 3) ...[
                Expanded(
                  child: _buildSmallProductCard(products[3], categoryProvider),
                ),
                if (products.length > 4) SizedBox(width: dW * 0.02),
              ],
              if (products.length > 4)
                Expanded(
                  child: _buildSmallProductCard(products[4], categoryProvider),
                ),
            ],
          ),
      ],
    );
  }

  // Helper method to get product image URL with fallbacks
  String _getProductImageUrl(
    Map<String, dynamic> product,
    CategoryProvider categoryProvider,
  ) {
    // Try to get image from the provider
    final imageFromProvider = categoryProvider.getProductImage(product);
    if (imageFromProvider != null && imageFromProvider.isNotEmpty) {
      return imageFromProvider;
    }

    // Fallback to a placeholder asset image that exists
    return 'assets/images/g1.png';
  }

  // Additional helper methods for banners
  Widget _buildBannersSection(List<dynamic> banners) {
    if (banners.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          title: 'Featured',
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        SizedBox(height: dW * 0.03),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: banners.map((banner) {
              return Container(
                margin: EdgeInsets.only(right: dW * 0.03),
                child: _buildBannerWidget(banner),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerWidget(Map<String, dynamic> banner) {
    final imageData = banner['image'];

    return Container(
      height: dW * 0.4,
      width: dW * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: imageData != null
            ? Image.memory(
                base64Decode(imageData),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildBannerPlaceholder(banner);
                },
              )
            : _buildBannerPlaceholder(banner),
      ),
    );
  }

  Widget _buildBannerPlaceholder(Map<String, dynamic> banner) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Colors.blue[300]!, Colors.purple[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: TextWidget(
          title: banner['title']?.toString() ?? 'Featured',
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper method to safely build small product cards with modern style
  Widget _buildSmallProductCard(
    Map<String, dynamic> product,
    CategoryProvider categoryProvider,
  ) {
    final imageUrl = _getProductImageUrl(product, categoryProvider);
    final price = categoryProvider.getProductPrice(product);
    final rating = categoryProvider.getProductRating(product);

    return Container(
      height: dW * 0.28, // Smaller height for side products
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Product Image
            _buildImageWidget(imageUrl),

            // Bottom gradient overlay with info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(dW * 0.02),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextWidget(
                        title: price.replaceAll('\$', '\$'),
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 10),
                          SizedBox(width: 1),
                          TextWidget(
                            title: rating.toStringAsFixed(1),
                            fontSize: 8,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build image with proper fallbacks
  Widget _buildImageWidget(String imageUrl) {
    print('_buildImageWidget received: $imageUrl');
    
    // Handle network URLs
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    }
    
    // Handle asset images
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    }
    
    // Handle base64 images (anything else that's not URL or asset)
    if (imageUrl.isNotEmpty && imageUrl.length > 50) {
      return buildBase64Image(imageUrl);
    }
    
    // Fallback
    return _buildFallbackImage();
  }

  // Add the _decodeAndDisplayBase64 helper method here (inside the CategoryScreenState class)
  Widget _decodeAndDisplayBase64(String base64String) {
    try {
      String cleanBase64 = base64String.trim();

      // Remove data URL prefix if present
      if (cleanBase64.contains(',')) {
        cleanBase64 = cleanBase64.split(',').last;
      }

      // Remove any leading slash (though WebP shouldn't have this)
      while (cleanBase64.startsWith('/')) {
        cleanBase64 = cleanBase64.substring(1);
      }

      // Remove any whitespace and newlines
      cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');

      // Ensure proper base64 padding
      while (cleanBase64.length % 4 != 0) {
        cleanBase64 += '=';
      }

      // Validate base64 characters
      if (!RegExp(r'^[A-Za-z0-9+/]*={0,2}$').hasMatch(cleanBase64)) {
        print('Invalid base64 characters found');
        return _buildFallbackImage();
      }

      print('Attempting to decode base64, length: ${cleanBase64.length}');
      print(
        'Base64 starts with: ${cleanBase64.substring(0, cleanBase64.length > 20 ? 20 : cleanBase64.length)}',
      );

      final Uint8List bytes = base64Decode(cleanBase64);
      print('Successfully decoded base64, bytes length: ${bytes.length}');

      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error displaying Image.memory: $error');
          return _buildFallbackImage();
        },
      );
    } catch (e) {
      print('Error decoding base64: $e');
      return _buildFallbackImage();
    }
  }

  // Add the _buildFallbackImage helper method here (inside the CategoryScreenState class)
  Widget _buildFallbackImage() {
    return Container(
      color: Colors.grey[300],
      child: Icon(Icons.image_outlined, color: Colors.grey[500], size: 40),
    );
  }

  // Legacy method - redirects to modern implementation
  Widget _buildBigProductCard(
    Map<String, dynamic> product,
    CategoryProvider categoryProvider,
  ) {
    return _buildLargeModernCard(product, categoryProvider);
  }

  // Modern large card implementation matching the UI exactly
  Widget _buildLargeModernCard(
    Map<String, dynamic> product,
    CategoryProvider categoryProvider, {
    bool featured = false,
  }) {
    final imageUrl = _getProductImageUrl(product, categoryProvider);
    final price = categoryProvider.getProductPrice(product);
    final rating = categoryProvider.getProductRating(product);
    final name = categoryProvider.getProductName(product);

    return Container(
      height: dW * 0.65, // Taller for better proportions
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Product Image
            _buildImageWidget(imageUrl),

            // Dark overlay for text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),

            // Price overlay (top left)
            Positioned(
              top: dW * 0.04,
              left: dW * 0.04,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextWidget(
                  title:
                      '\$${double.tryParse(price.replaceAll('\$', ''))?.toStringAsFixed(0) ?? price.replaceAll('\$', '')}',
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Rating overlay (top right)
            Positioned(
              top: dW * 0.04,
              right: dW * 0.04,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 14),
                    SizedBox(width: 3),
                    TextWidget(
                      title: rating.toStringAsFixed(1),
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),

            // Product name overlay (bottom) for featured cards
            if (featured)
              Positioned(
                bottom: dW * 0.04,
                left: dW * 0.04,
                right: dW * 0.04,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextWidget(
                    title: name,
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

            // Tap overlay
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    // Handle product tap - navigate to product detail
                  },
                  splashColor: Colors.white.withOpacity(0.1),
                  highlightColor: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modern small card implementation matching the UI exactly
  Widget _buildSmallModernCard(
    Map<String, dynamic> product,
    CategoryProvider categoryProvider,
  ) {
    final imageUrl = _getProductImageUrl(product, categoryProvider);
    final price = categoryProvider.getProductPrice(product);
    final rating = categoryProvider.getProductRating(product);

    return Container(
      height: dW * 0.31, // Proportional height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Product Image
            _buildImageWidget(imageUrl),

            // Dark overlay for text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                  stops: [0.5, 1.0],
                ),
              ),
            ),

            // Price and rating overlay (bottom)
            Positioned(
              bottom: dW * 0.025,
              left: dW * 0.025,
              right: dW * 0.025,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextWidget(
                      title:
                          '\$${double.tryParse(price.replaceAll('\$', ''))?.toStringAsFixed(0) ?? price.replaceAll('\$', '')}',
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // Rating
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 10),
                        SizedBox(width: 2),
                        TextWidget(
                          title: rating.toStringAsFixed(1),
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tap overlay
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    // Handle product tap - navigate to product detail
                  },
                  splashColor: Colors.white.withOpacity(0.1),
                  highlightColor: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernProductSection(
    String sectionName,
    List<dynamic> products,
    CategoryProvider categoryProvider,
  ) {
    if (products.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with modern styling
        Container(
          margin: EdgeInsets.only(bottom: dW * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                title: sectionName,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: dW * 0.04,
                    vertical: dW * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.black87, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget(
                        title: "View all",
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(width: dW * 0.015),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Products grid layout matching the UI exactly
        Container(
          child: Column(
            children: [
              // First row - 3 products (Large + 2 small stacked)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First product (larger)
                  Expanded(
                    flex: 2,
                    child: products.length > 0
                        ? _buildLargeModernCard(products[0], categoryProvider)
                        : Container(),
                  ),
                  SizedBox(width: dW * 0.02),
                  // Second and third products (smaller, stacked)
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        if (products.length > 1)
                          _buildSmallModernCard(products[1], categoryProvider),
                        SizedBox(height: dW * 0.02),
                        if (products.length > 2)
                          _buildSmallModernCard(products[2], categoryProvider),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: dW * 0.02),

              // Second row - 3 more products (2 small stacked + Large)
              if (products.length > 3)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fourth and fifth products (smaller, stacked)
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          if (products.length > 3)
                            _buildSmallModernCard(
                              products[3],
                              categoryProvider,
                            ),
                          SizedBox(height: dW * 0.02),
                          if (products.length > 4)
                            _buildSmallModernCard(
                              products[4],
                              categoryProvider,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: dW * 0.02),
                    // Sixth product (larger) - or the large featured card
                    Expanded(
                      flex: 2,
                      child: products.length > 5
                          ? _buildLargeModernCard(
                              products[5],
                              categoryProvider,
                              featured: true,
                            )
                          : Container(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Add this simple helper function to your CategoryScreenState class
  String convertBase64ToDataUrl(String base64String) {
    // Clean the base64 string first
    String cleanBase64 = base64String.trim();

    // Remove any leading slash
    while (cleanBase64.startsWith('/')) {
      cleanBase64 = cleanBase64.substring(1);
    }

    // Remove any whitespace and newlines
    cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');

    // Add proper padding if needed
    while (cleanBase64.length % 4 != 0) {
      cleanBase64 += '=';
    }

    // Return as data URL (but we won't actually use this - see below)
    return 'data:image/jpeg;base64,$cleanBase64';
  }

  // But instead, use this simple function to directly decode base64 to bytes
  Uint8List? decodeBase64ToBytes(String base64String) {
    try {
      // Clean the base64 string
      String cleanBase64 = base64String.trim();

      // Remove data URL prefix if present
      if (cleanBase64.contains(',')) {
        cleanBase64 = cleanBase64.split(',').last;
      }

      // Remove any leading slash
      while (cleanBase64.startsWith('/')) {
        cleanBase64 = cleanBase64.substring(1);
      }

      // Remove any whitespace and newlines
      cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');

      // Add proper padding if needed
      while (cleanBase64.length % 4 != 0) {
        cleanBase64 += '=';
      }

      // Validate base64 characters
      if (!RegExp(r'^[A-Za-z0-9+/]*={0,2}$').hasMatch(cleanBase64)) {
        print('Invalid base64 characters found');
        return null;
      }

      // Decode and return bytes
      return base64Decode(cleanBase64);
    } catch (e) {
      print('Error decoding base64: $e');
      return null;
    }
  }

  // Simple widget to display base64 images
  Widget buildBase64Image(
    String base64String, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    final bytes = decodeBase64ToBytes(base64String);

    if (bytes != null) {
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: Icon(Icons.broken_image, color: Colors.grey[500]),
          );
        },
      );
    } else {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: Icon(Icons.image_outlined, color: Colors.grey[500]),
      );
    }
  }
}
