import 'dart:convert';
import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/cartModule/providers/cart_provider.dart';
import 'package:clothing_app_frontend/cartModule/screens/cart_screen.dart';
import 'package:clothing_app_frontend/categoryModule/widgets/similar_product_card_widget.dart';
import 'package:clothing_app_frontend/checkoutModule/screens/checkout_screen.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/homeModule/provider/product_detail_provider.dart';
import 'package:clothing_app_frontend/homeModule/widgets/custom_big_product_card_grid.dart';
import 'package:clothing_app_frontend/homeModule/widgets/custom_small_product_card_grid.dart';
import 'package:clothing_app_frontend/homeModule/widgets/size_chart_screen.dart';
import 'package:clothing_app_frontend/navigation/arguments.dart';
import 'package:clothing_app_frontend/profileModule/screens/viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductDetailScreenArguments args;

  const ProductDetailScreen({super.key, required this.args});
  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  // Add this for dynamic images
  int selectedImageIndex = 0;
  bool isCheckOutPressed = false;
  List<String> productImages = [
    'assets/images/product_1_1.jpg',
    'assets/images/product_1_2.jpg',
    'assets/images/product_1_4.jpg',
    'assets/images/product_1_3.jpg',
    // Add more images from API here
  ];

  // Add these state variables
  String selectedSize = '32';
  int selectedColorIndex = 3; // Example: Sky Blue

  List<String> sizes = ['28', '30', '32', '34', '36'];
  List<Color> colors = [
    Color(0xFF000000), // Black
    Color(0xFF7D7D7D), // Gray
    Color(0xFF1A1F71), // Dark Blue
    Color(0xFF87CEEB), // Sky Blue
    Color(0xFFC3B091), // Tan
    Color(0xFF556B2F), // Dark Olive Green
  ];

  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  bool isFavourite = false;
  int cartItemCount = 0; // Add cart counter

  fetchProductDetails() async {
    setState(() => isLoading = true);
    try {
      final response = await Provider.of<ProductDetailProvider>(
        context,
        listen: false,
      ).fetchProductDetails(productId: widget.args.productId);

      if (response['success']) {
        // Update product images, colors, sizes based on API data
        _updateProductDataFromAPI();
      } else {
        showSnackbar(response['message']);
      }
    } catch (e) {
      showSnackbar('Failed to load product details');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _updateProductDataFromAPI() {
    final provider = Provider.of<ProductDetailProvider>(context, listen: false);
    if (provider.rawProductDetails.isNotEmpty) {
      final productData = safeProductDetail;

      if (productData == null) return;

      // Update product images from API data (prioritize API images over static)
      List<String> apiImages = [];

      // Handle images array with base64 data
      if (productData['images'] != null && productData['images'] is List) {
        final imagesList = productData['images'] as List;
        for (var imageObj in imagesList) {
          if (imageObj is Map && imageObj['image'] != null) {
            String base64Image = imageObj['image'].toString();
            if (base64Image.isNotEmpty) {
              // Add the base64 image directly (it already contains data:image/png;base64, prefix)
              apiImages.add(base64Image);
            }
          }
        }
      }

      // Also check variants for images (in case there are variant-specific images)
      if (productData['variants'] != null &&
          productData['variants'].isNotEmpty) {
        for (var variant in productData['variants']) {
          if (variant['imageUrl'] != null &&
              variant['imageUrl'].toString().isNotEmpty) {
            apiImages.add(variant['imageUrl'].toString());
          } else if (variant['image'] != null &&
              variant['image'].toString().isNotEmpty) {
            String variantImage = variant['image'].toString();
            // Handle base64 images from variants
            if (variantImage.startsWith('data:image/')) {
              apiImages.add(variantImage);
            } else {
              apiImages.add(variantImage);
            }
          }
        }
      }

      // Check for main product image fields (in case there are other image fields)
      if (productData['imageUrl'] != null &&
          productData['imageUrl'].toString().isNotEmpty) {
        apiImages.insert(
          0,
          productData['imageUrl'].toString(),
        ); // Add as first image
      }
      if (productData['image'] != null &&
          productData['image'].toString().isNotEmpty) {
        String mainImage = productData['image'].toString();
        if (mainImage.startsWith('data:image/')) {
          apiImages.insert(0, mainImage); // Add as first image
        } else {
          apiImages.insert(0, mainImage);
        }
      }

      // Remove duplicates while preserving order
      final uniqueApiImages = <String>[];
      for (String image in apiImages) {
        if (!uniqueApiImages.contains(image)) {
          uniqueApiImages.add(image);
        }
      }

      // Use API images if available, otherwise keep static images as fallback
      if (uniqueApiImages.isNotEmpty) {
        setState(() {
          productImages = uniqueApiImages;
          selectedImageIndex = 0;
        });
      }
      // If no API images found, productImages will remain with static asset images

      // Update available sizes from variants
      if (productData['variants'] != null) {
        final variants = List<dynamic>.from(productData['variants']);
        final availableSizes = variants
            .map<String>((variant) => variant['size']?.toString() ?? '')
            .where((size) => size.isNotEmpty)
            .toSet()
            .toList();
        if (availableSizes.isNotEmpty) {
          setState(() {
            sizes.clear();
            sizes.addAll(availableSizes);
            selectedSize = sizes.first; // Set to first available size from API
          });
        }
      }

      // Update available colors from variants
      if (productData['variants'] != null) {
        final variants = List<dynamic>.from(productData['variants']);
        final availableColors = variants
            .map<String>((variant) => variant['color']?.toString() ?? '')
            .where((color) => color.isNotEmpty)
            .toSet()
            .toList();

        // Map color names to Color objects (you can expand this)
        colors.clear();
        for (String colorName in availableColors) {
          switch (colorName.toUpperCase()) {
            case 'BLACK':
              colors.add(Color(0xFF000000));
              break;
            case 'WHITE':
              colors.add(Color(0xFFFFFFFF));
              break;
            case 'BROWN':
              colors.add(Color(0xFF8B4513)); // Brown color
              break;
            case 'BLUE':
            case 'DARK BLUE':
              colors.add(Color(0xFF1A1F71));
              break;
            case 'SKY BLUE':
            case 'LIGHT BLUE':
              colors.add(Color(0xFF87CEEB));
              break;
            case 'RED':
              colors.add(Color(0xFFDC143C));
              break;
            case 'GREEN':
            case 'DARK OLIVE GREEN':
              colors.add(Color(0xFF556B2F));
              break;
            case 'GRAY':
            case 'GREY':
              colors.add(Color(0xFF7D7D7D));
              break;
            case 'TAN':
            case 'BEIGE':
              colors.add(Color(0xFFC3B091));
              break;
            default:
              colors.add(Color(0xFF7D7D7D)); // Default gray
          }
        }

        if (colors.isNotEmpty) {
          setState(() {
            selectedColorIndex = 0; // Set to first available color from API
          });
        }
      }
    }
  }

  // Helper method to get current product data
  Map<String, dynamic>? get currentProductData {
    final provider = Provider.of<ProductDetailProvider>(context, listen: false);
    if (provider.rawProductDetails.isNotEmpty) {
      return provider.rawProductDetails[0];
    }
    return null;
  }

  // Helper method to safely get product detail data
  Map<String, dynamic>? get safeProductDetail {
    try {
      final data = currentProductData;
      if (data != null) {
        // Try different possible data structures
        if (data['data'] != null && data['data']['productDetail'] != null) {
          return data['data']['productDetail'];
        } else if (data['productDetail'] != null) {
          return data['productDetail'];
        } else if (data['product'] != null) {
          return data['product'];
        } else {
          // Return the whole data if no nested structure
          return data;
        }
      }
    } catch (e) {
      // Silently handle any access errors
    }
    return null;
  }

  // Helper method to get current variant data
  Map<String, dynamic>? get currentVariant {
    final productData = safeProductDetail;
    if (productData != null && productData['variants'] != null) {
      final variants = productData['variants'] as List;

      // DEBUG: Print variant structure to understand the data
      if (variants.isNotEmpty) {
        print('=== VARIANT DEBUG INFO ===');
        print('Number of variants: ${variants.length}');
        print('First variant structure: ${variants[0]}');
        print('First variant keys: ${variants[0].keys.toList()}');
        print('Selected size: $selectedSize');
        print('Selected color index: $selectedColorIndex');
        print('=== END DEBUG INFO ===');
      }

      // Get selected color name from the available variants
      String selectedColorName = '';
      if (variants.isNotEmpty) {
        final uniqueColors = variants
            .map<String>((v) => v['color']?.toString() ?? '')
            .where((color) => color.isNotEmpty)
            .toSet()
            .toList();
        if (selectedColorIndex < uniqueColors.length) {
          selectedColorName = uniqueColors[selectedColorIndex];
        }
      }

      // Find variant matching selected size and color
      for (var variant in variants) {
        final variantSize = variant['size']?.toString() ?? '';
        final variantColor = variant['color']?.toString() ?? '';

        if (variantSize.toLowerCase() == selectedSize.toLowerCase() &&
            variantColor.toLowerCase() == selectedColorName.toLowerCase()) {
          print('Found exact match variant: $variant');
          return variant;
        }
      }

      // If no exact match, try to find by size only
      for (var variant in variants) {
        final variantSize = variant['size']?.toString() ?? '';
        if (variantSize.toLowerCase() == selectedSize.toLowerCase()) {
          print('Found size match variant: $variant');
          return variant;
        }
      }

      // If no size/color matching works, return first variant (fallback)
      print('Using first variant as fallback: ${variants[0]}');
      return variants.isNotEmpty ? variants[0] : null;
    }
    return null;
  }

  fetchData() async {
    await fetchProductDetails();
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Product Detail',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Color(0xFFB8956A)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Cart Icon with Badge
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Color(0xFFB8956A),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyCartScreen(),
                    ),
                  );
                },
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$cartItemCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: Icon(
              isFavourite ? Icons.favorite : Icons.favorite_border,
              color: isFavourite ? Colors.red : Color(0xFFB8956A),
            ),
            onPressed: () {
              setState(() {
                isFavourite = !isFavourite;
              });

              // Show appropriate message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        isFavourite ? Icons.favorite : Icons.heart_broken,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        isFavourite
                            ? 'Added to favorites!'
                            : 'Removed from favorites',
                      ),
                    ],
                  ),
                  backgroundColor: isFavourite ? Colors.red : Colors.grey,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.all(16),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share, color: Color(0xFFB8956A)),
            onPressed: () {},
          ),
          // Debug button - remove this after fixing
          IconButton(
            icon: Icon(Icons.bug_report, color: Color(0xFFB8956A)),
            onPressed: _debugApiResponse,
          ),
        ],
      ),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFB8956A),
                        ),
                        backgroundColor: Color(0xFFB8956A).withOpacity(0.2),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading product details...',
                      style: TextStyle(
                        color: Color(0xFFB8956A),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: dW * 0.05),

                  // Product Image & Gallery
                  Container(
                    margin: EdgeInsets.only(bottom: dW * 0.04),
                    padding: EdgeInsets.all(dW * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _buildProductImage(
                            productImages[selectedImageIndex],
                          ),
                        ),
                        // Positioned(
                        //   top: 10,
                        //   left: 10,
                        //   child: Icon(
                        //     Icons.arrow_back_ios,
                        //     color: Colors.black54,
                        //   ),
                        // ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isFavourite = !isFavourite;
                              });
                            },
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) =>
                                  ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                              child: Icon(
                                isFavourite
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined,
                                key: ValueKey<bool>(isFavourite),
                                color: isFavourite ? Colors.red : Colors.white,
                                size: tS * 24,
                              ),
                            ),
                          ),
                        ),
                        // Gallery thumbnails
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Column(
                            children: List.generate(productImages.length, (
                              index,
                            ) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImageIndex = index;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedImageIndex == index
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: _buildThumbnailImage(
                                      productImages[index],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Product Title
                  TextWidget(
                    title:
                        safeProductDetail?['name'] ??
                        safeProductDetail?['title'] ??
                        safeProductDetail?['productName'] ??
                        'Product Name',
                    fontWeight: FontWeight.w500,
                    fontSize: 27,
                  ),
                  SizedBox(height: dW * 0.05),

                  // Ratings, Reviews, Sold
                  Row(
                    children: [
                      _ratingChip('4.7'),
                      SizedBox(width: 8),
                      TextWidget(
                        title: 'Ratings',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      SizedBox(width: 16),
                      TextWidget(
                        title: '• 2.8k+ Reviews',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      SizedBox(width: 16),
                      TextWidget(
                        title: '• 5.2k+ Sold',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Price, Discount
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextWidget(
                        title:
                            '\$${currentVariant?['price']?.toString() ?? '0.00'}',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                      SizedBox(width: 12),
                      if (currentVariant?['discount_price'] != null)
                        TextWidget(
                          title:
                              '\$${currentVariant?['discount_price']?.toString() ?? '0.00'}',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          textDecoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      if (currentVariant?['discount_price'] != null)
                        SizedBox(width: 8),
                      // Discount badge - show only if there's a discount
                      if (currentVariant?['discount_price'] != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Color(
                              0xFF8FBC8F,
                            ), // Subtle green that complements brown theme
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextWidget(
                            title: _calculateDiscountPercentage(),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Description
                  TextWidget(
                    title:
                        safeProductDetail?['description'] ??
                        safeProductDetail?['desc'] ??
                        safeProductDetail?['details'] ??
                        'This is a high-quality product designed for comfort and style.',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                  SizedBox(height: 20),

                  // Size Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: sizes
                        .map(
                          (size) => GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSize = size;
                              });
                            },
                            child: _sizeChip(
                              size,
                              selected:
                                  selectedSize.toLowerCase() ==
                                  size.toLowerCase(),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 20),

                  // Color Selector
                  Row(
                    children: [
                      TextWidget(
                        title: 'Color: ',
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      TextWidget(
                        title: _getColorName(selectedColorIndex),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFD2B193).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            TextWidget(
                              title: 'Suggested',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Color(0xFFB8956A),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.star,
                              color: Color(0xFFB8956A),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Color Chips
                  Wrap(
                    spacing: 8,
                    children: List.generate(colors.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColorIndex = index;
                          });
                        },
                        child: _colorChip(
                          colors[index],
                          index < 3, // starred for first three
                          selected: selectedColorIndex == index,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 30),

                  // Size Chart and Try On Options
                  Row(
                    children: [
                      // Size Chart Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            SizeChartScreen.show(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color(0xFFD2B193),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.straighten,
                                  color: Color(0xFFB8956A),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                TextWidget(
                                  title: 'Size Chart',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xFFB8956A),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Try On Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await _openTryOnModel();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFB8956A).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                TextWidget(
                                  title: 'Try On',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Product Details Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          title: 'Product Details',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        SizedBox(height: 12),
                        _detailRow(
                          'Fabric',
                          safeProductDetail?['fabric_type'] ??
                              safeProductDetail?['fabric'] ??
                              safeProductDetail?['material'] ??
                              'Cotton',
                        ),
                        _detailRow(
                          'Gender',
                          safeProductDetail?['gender'] ??
                              safeProductDetail?['targetGender'] ??
                              'Unisex',
                        ),
                        _detailRow(
                          'Body Type',
                          safeProductDetail?['bodyType'] ??
                              safeProductDetail?['body_type'] ??
                              safeProductDetail?['fit'] ??
                              'Regular',
                        ),
                        _detailRow(
                          'Product Type',
                          safeProductDetail?['productType'] ??
                              safeProductDetail?['product_type'] ??
                              safeProductDetail?['category'] ??
                              'Clothing',
                        ),
                        _detailRow('Style', _getStyleString()),
                        _detailRow('SKU', currentVariant?['sku'] ?? 'N/A'),
                        SizedBox(height: 16),
                        TextWidget(
                          title: 'Care Instructions',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        SizedBox(height: 8),
                        TextWidget(
                          title:
                              '• Machine wash cold with like colors\n• Tumble dry low heat\n• Do not bleach\n• Iron on medium heat if needed',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Add to Cart and Checkout Buttons
                  Row(
                    children: [
                      // Add to Cart Button
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color(0xFFD2B193),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              _addToCart();
                            },
                            icon: Icon(
                              Icons.add_shopping_cart,
                              size: 20,
                              color: Color(0xFFB8956A),
                            ),
                            label: Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: Color(0xFFB8956A),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Checkout Button
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFD2B193),
                                Color(0xFFB8956A),
                                Color(0xFFA67C52),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFB8956A).withOpacity(0.3),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isCheckOutPressed = true;
                              });
                              _addToCart();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CheckoutScreen(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.payment,
                              size: 20,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Checkout',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Similar Products Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        title: 'Similar Products',
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: TextWidget(
                          title: 'View all',
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Color(0xFFB8956A),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SimilarProductCard(
                          imagePath: 'assets/images/g1.png',
                          productName: 'Product 1',
                          onTap: () {},
                        ),
                        SimilarProductCard(
                          imagePath: 'assets/images/g2.png',
                          productName: 'Product 2',
                          onTap: () {},
                        ),
                        SimilarProductCard(
                          imagePath: 'assets/images/g3.png',
                          productName: 'Product 3',
                          onTap: () {},
                        ),
                        SimilarProductCard(
                          imagePath: 'assets/images/g4.png',
                          productName: 'Product 4',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            title: 'Make an Outfit',
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {},
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomSmallProductCardGrid(
                            imageUrl: 'assets/images/g1.png',
                            price: '50',
                            rating: 3.9,
                            onTap: () {},
                          ),
                          CustomSmallProductCardGrid(
                            imageUrl: 'assets/images/g2.png',
                            price: '44',
                            rating: 4.7,
                            onTap: () {},
                          ),
                          CustomSmallProductCardGrid(
                            imageUrl: 'assets/images/g3.png',
                            price: '90',
                            rating: 4.5,
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: dW * 0.02),
                      Row(
                        children: [
                          // Left column with small cards
                          Flexible(
                            flex: 3,
                            child: Column(
                              children: [
                                CustomSmallProductCardGrid(
                                  imageUrl: 'assets/images/g2.png',
                                  price: '90',
                                  rating: 4.5,
                                  onTap: () {},
                                ),
                                SizedBox(height: dW * 0.02),
                                CustomSmallProductCardGrid(
                                  imageUrl: 'assets/images/g2.png',
                                  price: '90',
                                  rating: 4.5,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: dW * 0.02),
                          // Right side with big card
                          Flexible(
                            flex: 5,
                            child: CustomBigProductCardGridWidget(
                              productName: 'Charcoal Fade Jeans',
                              imageUrl: 'assets/images/g2.png',
                              price: '90',
                              rating: 4.5,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: dW * 0.05),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  // Helper to get color name
  String _getColorName(int index) {
    final productData = safeProductDetail;
    if (productData != null && productData['variants'] != null) {
      final variants = productData['variants'] as List;

      // Get unique colors
      final uniqueColors = variants
          .map<String>((v) => v['color']?.toString() ?? '')
          .where((color) => color.isNotEmpty)
          .toSet()
          .toList();

      if (index < uniqueColors.length) {
        return uniqueColors[index];
      }
    }

    // Fallback to static color names if API data not available
    switch (index) {
      case 0:
        return 'Black';
      case 1:
        return 'Gray';
      case 2:
        return 'Dark Blue';
      case 3:
        return 'Sky Blue';
      case 4:
        return 'Tan';
      case 5:
        return 'Dark Olive Green';
      default:
        return 'Unknown';
    }
  }

  // Helper method to open Try On 3D model
  Future<void> _openTryOnModel() async {
    // final variant = currentVariant;
    final avatarUrl =
        // variant?['avatarUrl'] ??
        'https://models.readyplayer.me/6891102bece5d61d2d67f672.glb';
        // 'https://models.readyplayer.me/68840d454f328601275c3f78.glb';

    try {
      // Use AvatarViewerPage to view the 3D model
      AvatarViewerPage.viewModel(context, avatarUrl, title: "Try On");
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening Try On viewer'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Helper method to add product to cart
  void _addToCart() async {
    // Validate current variant is available
    final variant = currentVariant;

    print('=== ADD TO CART DEBUG ===');
    print('Current variant: $variant');
    print('Variant _id: ${variant?['_id']}');
    print('Selected size: $selectedSize');
    print('Selected color index: $selectedColorIndex');
    print('Available sizes: $sizes');
    print('Available colors count: ${colors.length}');
    if (safeProductDetail?['variants'] != null) {
      final variants = safeProductDetail!['variants'] as List;
      print('Total variants in API: ${variants.length}');
      for (int i = 0; i < variants.length; i++) {
        print(
          'Variant $i: size=${variants[i]['size']}, color=${variants[i]['color']}, _id=${variants[i]['_id']}',
        );
      }
    }
    print('========================');

    if (variant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No variant data available. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check for variant ID in multiple possible field names
    String? variantId;
    if (variant['_id'] != null && variant['_id'].toString().isNotEmpty) {
      variantId = variant['_id'].toString();
    } else if (variant['id'] != null && variant['id'].toString().isNotEmpty) {
      variantId = variant['id'].toString();
    } else if (variant['variantId'] != null &&
        variant['variantId'].toString().isNotEmpty) {
      variantId = variant['variantId'].toString();
    }

    if (variantId == null || variantId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to add to cart: Invalid variant ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Get user ID from AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user.id == ''
          ? '6891343a436e2277cd0a829f'
          : authProvider.user.id;

      // Validate userId
      if (userId == null || userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to add to cart: User not logged in'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Call the CartProvider addToCart method with the actual selected variant ID
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      // Ensure we always have a valid quantity (minimum 1)
      final quantityToAdd = 1; // Always add 1 item to cart

      print(
        'Adding to cart with userId: $userId, variantId: $variantId, quantity: $quantityToAdd',
      );

      final result = await cartProvider.addToCart(
        userId: userId,
        variantId: variantId,
        quantity: quantityToAdd,
      );

      if (result['success'] == true) {
        setState(() {
          cartItemCount++; // Increment cart counter
        });

        // Show success toast
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Added to cart successfully!',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${safeProductDetail?['name'] ?? 'Product'} - Size $selectedSize added to cart!',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Color(0xFF8FBC8F),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'VIEW CART',
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyCartScreen()),
                );
              },
            ),
          ),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text(result['message'] ?? 'Failed to add to cart'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(16),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('Error adding to cart. Please try again.'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Helper method to calculate discount percentage
  String _calculateDiscountPercentage() {
    final variant = currentVariant;
    if (variant != null &&
        variant['price'] != null &&
        variant['discount_price'] != null) {
      final price = double.tryParse(variant['price'].toString()) ?? 0.0;
      final discountPrice =
          double.tryParse(variant['discount_price'].toString()) ?? 0.0;

      if (price > 0 && discountPrice > 0 && price > discountPrice) {
        final percentage = ((price - discountPrice) / price * 100).round();
        return '${percentage}% OFF';
      }
    }
    return '0% OFF';
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: TextWidget(
              title: '$label:',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          Expanded(
            child: TextWidget(
              title: value,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingChip(String rating) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.white, size: 16),
          SizedBox(width: 4),
          TextWidget(
            title: rating,
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _sizeChip(String size, {bool selected = false}) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Color(0xFFD2B193).withOpacity(0.2) : Colors.white,
        border: Border.all(
          color: selected ? Color(0xFFB8956A) : Colors.grey.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Color(0xFFB8956A).withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: TextWidget(
        title: size,
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: selected ? Color(0xFFB8956A) : Colors.black87,
      ),
    );
  }

  Widget _colorChip(Color color, bool starred, {bool selected = false}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            if (starred) Icon(Icons.star, color: Colors.amber, size: 16),
          ],
        ),
        SizedBox(height: 2),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: selected ? 4 : 0,
          width: 36,
          decoration: BoxDecoration(
            color: selected ? Colors.brown : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  // Helper method to build product image (supports asset, network, and base64 images)
  Widget _buildProductImage(String imagePath) {
    // Check if it's a base64 image
    if (imagePath.startsWith('data:image/')) {
      try {
        // Extract base64 data from the data URL
        final base64String = imagePath.split(',').last;
        final bytes = base64Decode(base64String);

        return Image.memory(
          bytes,
          height: dW * 0.7,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: dW * 0.7,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Base64 image error',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            );
          },
        );
      } catch (e) {
        return Container(
          height: dW * 0.7,
          width: double.infinity,
          color: Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 48, color: Colors.grey.shade400),
              SizedBox(height: 8),
              Text(
                'Invalid base64 image',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        );
      }
    }
    // Check if it's a network URL
    else if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        height: dW * 0.7,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: dW * 0.7,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 8),
                Text(
                  'Image not available',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: dW * 0.7,
            width: double.infinity,
            color: Colors.grey.shade100,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                color: Color(0xFFB8956A),
              ),
            ),
          );
        },
      );
    } else {
      // Asset image
      return Image.asset(
        imagePath,
        height: dW * 0.7,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: dW * 0.7,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 8),
                Text(
                  'Image not available',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  // Helper method to build thumbnail image (supports asset, network, and base64 images)
  Widget _buildThumbnailImage(String imagePath) {
    // Check if it's a base64 image
    if (imagePath.startsWith('data:image/')) {
      try {
        // Extract base64 data from the data URL
        final base64String = imagePath.split(',').last;
        final bytes = base64Decode(base64String);

        return Image.memory(
          bytes,
          height: 48,
          width: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 48,
              width: 48,
              color: Colors.grey.shade200,
              child: Icon(
                Icons.image_not_supported,
                size: 24,
                color: Colors.grey.shade400,
              ),
            );
          },
        );
      } catch (e) {
        return Container(
          height: 48,
          width: 48,
          color: Colors.grey.shade200,
          child: Icon(Icons.error, size: 24, color: Colors.grey.shade400),
        );
      }
    }
    // Check if it's a network URL
    else if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        height: 48,
        width: 48,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 48,
            width: 48,
            color: Colors.grey.shade200,
            child: Icon(
              Icons.image_not_supported,
              size: 24,
              color: Colors.grey.shade400,
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 48,
            width: 48,
            color: Colors.grey.shade100,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFB8956A),
                ),
              ),
            ),
          );
        },
      );
    } else {
      // Asset image
      return Image.asset(
        imagePath,
        height: 48,
        width: 48,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 48,
            width: 48,
            color: Colors.grey.shade200,
            child: Icon(
              Icons.image_not_supported,
              size: 24,
              color: Colors.grey.shade400,
            ),
          );
        },
      );
    }
  }

  // Debug method to show actual API response structure
  void _debugApiResponse() {
    final provider = Provider.of<ProductDetailProvider>(context, listen: false);
    if (provider.rawProductDetails.isNotEmpty) {
      final response = provider.rawProductDetails[0];

      // Show a dialog with the API structure
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('API Response Structure'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Keys in response: ${response.keys.toList()}'),
                SizedBox(height: 10),
                if (response['data'] != null) ...[
                  Text('data keys: ${(response['data'] as Map).keys.toList()}'),
                  SizedBox(height: 5),
                  if (response['data']['productDetail'] != null)
                    Text(
                      'productDetail keys: ${(response['data']['productDetail'] as Map).keys.toList()}',
                    ),
                ],
                if (response['productDetail'] != null)
                  Text(
                    'productDetail keys: ${(response['productDetail'] as Map).keys.toList()}',
                  ),
                SizedBox(height: 10),
                Text(
                  'Safe product detail: ${safeProductDetail?.keys.toList() ?? "null"}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  // Helper method to get style string from various possible field names
  String _getStyleString() {
    final productData = safeProductDetail;
    if (productData != null) {
      // Try different possible style field names
      if (productData['style'] != null) {
        if (productData['style'] is List) {
          return (productData['style'] as List).join(', ');
        } else {
          return productData['style'].toString();
        }
      } else if (productData['styles'] != null) {
        if (productData['styles'] is List) {
          return (productData['styles'] as List).join(', ');
        } else {
          return productData['styles'].toString();
        }
      } else if (productData['styleType'] != null) {
        return productData['styleType'].toString();
      } else if (productData['design'] != null) {
        return productData['design'].toString();
      }
    }
    return 'Casual';
  }
}
