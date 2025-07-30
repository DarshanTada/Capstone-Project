import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/cartModule/screens/cart_screen.dart';
import 'package:clothing_app_frontend/categoryModule/widgets/similar_product_card_widget.dart';
import 'package:clothing_app_frontend/checkoutModule/screens/checkout_screen.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
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

  final List<String> sizes = ['28', '30', '32', '34', '36'];
  final List<Color> colors = [
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
        title: const Text('Product Detail', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
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
                icon: Icon(Icons.shopping_cart_outlined, color: Color(0xFFB8956A)),
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
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
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
              color: isFavourite ? Colors.red : Color(0xFFB8956A)
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
                      Text(isFavourite 
                        ? 'Added to favorites!' 
                        : 'Removed from favorites'
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
          ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
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
                          child: Image.asset(
                            productImages[selectedImageIndex],
                            height: dW * 0.7,
                            width: double.infinity,
                            fit: BoxFit.cover,
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
                                    child: Image.asset(
                                      productImages[index],
                                      height: 48,
                                      width: 48,
                                      fit: BoxFit.cover,
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
                    title: 'High Waist Wide Leg Denim Baggy Jeans',
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
                        title: '\$89.99',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                      SizedBox(width: 12),
                      TextWidget(
                        title: '\$119.99',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        textDecoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8),
                      // Discount badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF8FBC8F), // Subtle green that complements brown theme
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextWidget(
                          title: '25% OFF',
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
                        'Premium high-rise denim jeans featuring a relaxed wide-leg silhouette. Crafted from 100% cotton denim with a comfortable baggy fit. Perfect for casual and street style looks.',
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
                              selected: selectedSize == size,
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
                            Icon(Icons.star, color: Color(0xFFB8956A), size: 16),
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
                            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xFFD2B193), width: 1.5),
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
                            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
                        _detailRow('Fabric', '100% Cotton Denim'),
                        _detailRow('Fit', 'Relaxed Baggy Fit'),
                        _detailRow('Rise', 'High Waist'),
                        _detailRow('Length', 'Full Length'),
                        _detailRow('Style', 'Wide Leg'),
                        _detailRow('Closure', 'Button & Zip Fly'),
                        SizedBox(height: 16),
                        TextWidget(
                          title: 'Care Instructions',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        SizedBox(height: 8),
                        TextWidget(
                          title: '• Machine wash cold with like colors\n• Tumble dry low heat\n• Do not bleach\n• Iron on medium heat if needed',
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
                            border: Border.all(color: Color(0xFFD2B193), width: 1.5),
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
                            imageUrl:
                                'assets/images/g3.png',
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
        return '';
    }
  }

  // Helper method to open Try On 3D model
  Future<void> _openTryOnModel() async {
    const url = 'https://models.readyplayer.me/68840d454f328601275c3f78.glb';
    try {
      // Use AvatarViewerPage to view the 3D model
      AvatarViewerPage.viewModel(context, url, title: "Try On");
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
  void _addToCart() {
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
                    'High Waist Wide Leg Denim Baggy Jeans - Size $selectedSize',
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
              MaterialPageRoute(
                builder: (context) => const MyCartScreen(),
              ),
            );
          },
        ),
      ),
    );
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
        boxShadow: selected ? [
          BoxShadow(
            color: Color(0xFFB8956A).withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ] : [],
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
}
