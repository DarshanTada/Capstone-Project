import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/categoryModule/widgets/similar_product_card_widget.dart';
import 'package:clothing_app_frontend/colors.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/homeModule/widgets/custom_big_product_card_grid.dart';
import 'package:clothing_app_frontend/homeModule/widgets/custom_small_product_card_grid.dart';
import 'package:clothing_app_frontend/navigation/arguments.dart';
import 'package:clothing_app_frontend/navigation/navigators.dart';
import 'package:clothing_app_frontend/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductDetailScreenArguments args;

  const ProductDetailScreen({Key? key, required this.args}) : super(key: key);
  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  // Add this for dynamic images
  int selectedImageIndex = 0;
  List<String> productImages = [
    'assets/images/b4.png',
    'assets/images/b1.png',
    'assets/images/b3.png',
    // Add more images from API here
  ];

  // Add these state variables
  String selectedSize = 'M';
  int selectedColorIndex = 3; // Example: Beige

  final List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];
  final List<Color> colors = [
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.brown.shade200,
    Colors.brown.shade400,
    Colors.brown.shade600,
    Colors.brown.shade800,
  ];

  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  bool isFavourite = false;

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
      backgroundColor: white,
      appBar: CustomAppBar(title: 'Product Detail', dW: dW, bgColor: white),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        32,
                      ), // Increased for more rounding
                    ),
                    // padding: EdgeInsets.all(dW * 0.02),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            32,
                          ), // Match container
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
                    title: 'KIDS STYLISH JACKET',
                    fontWeight: FontWeight.w500,
                    fontSize: 27,
                  ),
                  SizedBox(height: dW * 0.05),

                  // Ratings, Reviews, Sold
                  Row(
                    children: [
                      _ratingChip('4.5'),
                      SizedBox(width: 8),
                      TextWidget(
                        title: 'Ratings',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      SizedBox(width: 16),
                      TextWidget(
                        title: '• 1.5k+ Review',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      SizedBox(width: 16),
                      TextWidget(
                        title: '• 3.4k+ Sold',
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
                        title: '\$250.99',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                      SizedBox(width: 12),
                      TextWidget(
                        title: '\$320.99',
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
                          color: Colors.brown.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextWidget(
                          title: '15%',
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
                        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod',
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
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            TextWidget(
                              title: 'Suggested',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.star, color: Colors.amber, size: 16),
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

                  // Add to Cart Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade700,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_shopping_cart,
                      size: 28,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Add to Cart',
                      style: customTextTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
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
                          color: Colors.brown,
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
                          CustomBigProductCardGridWidget(
                            productName: 'Charcoal Fade Jeans',
                            imageUrl: 'https://tinyurl.com/2jjbmthn',
                            price: '90',
                            rating: 4.5,
                            onTap: () {},
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
        return 'Red';
      case 1:
        return 'Black';
      case 2:
        return 'Yellow';
      case 3:
        return 'Beige';
      case 4:
        return 'Brown';
      case 5:
        return 'Dark Brown';
      case 6:
        return 'Chocolate';
      default:
        return '';
    }
  }

  // Helper widgets
  Widget _galleryThumb(String assetPath, {String? label}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            assetPath,
            height: 48,
            width: 48,
            fit: BoxFit.cover,
          ),
        ),
        if (label != null)
          Container(
            color: Colors.black54,
            child: TextWidget(
              title: label,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  Widget _ratingChip(String rating) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
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
        color: selected ? Colors.brown.shade100 : Colors.white,
        border: Border.all(
          color: selected ? Colors.brown : Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextWidget(title: size, fontWeight: FontWeight.w600, fontSize: 15),
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
