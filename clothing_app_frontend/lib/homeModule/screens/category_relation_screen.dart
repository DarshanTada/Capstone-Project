import 'dart:convert';
import 'dart:typed_data';

import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/text_widget.dart';
import 'package:clothing_app_frontend/navigation/arguments.dart';
import 'package:clothing_app_frontend/navigation/navigators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ProductViewType { threeGrid, oneList, twoGrid }

class CategoryRelationScreen extends StatefulWidget {
  final CategoryRelationScreenArguments args;

  const CategoryRelationScreen({super.key, required this.args});
  @override
  CategoryRelationScreenState createState() => CategoryRelationScreenState();
}

class CategoryRelationScreenState extends State<CategoryRelationScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  ProductViewType viewType = ProductViewType.threeGrid;

  // Updated categories with actual asset images based on selected category
  List<Map<String, dynamic>> categories = [];

  // Change from getter to regular list variable
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    _initializeCategories();
    _initializeProducts();
    fetchData();
  }

  void _initializeCategories() {
    // Use only dynamic subcategories data
    if (widget.args.subcategories != null &&
        widget.args.subcategories!.isNotEmpty) {
      categories = widget.args.subcategories!.map((subcat) {
        final subcatName = subcat['name']?.toString() ?? 'Unknown';
        final subcatImage = subcat['image']?.toString() ?? '';

        return {
          'name': subcatName,
          'image': subcatImage, // This will be base64 encoded image
          'isBase64': true, // Flag to indicate this is base64 data
        };
      }).toList();
    } else {
      // Show empty state when no dynamic data available
      categories = [
        {
          'name': 'No Categories',
          'image': '', // Empty image will show placeholder
          'isBase64': false,
        },
      ];
    }
  }

  void _initializeProducts() {
    // Use only dynamic products data
    if (widget.args.products != null && widget.args.products!.isNotEmpty) {
      products = widget.args.products!.map((product) {
        return {
          'name': product['name']?.toString() ?? 'Unknown Product',
          'image': product['image']?.toString() ?? '',
          'oldPrice': (product['price'] is num)
              ? (product['price'] as num).toDouble() + 15
              : 60.0,
          'price': (product['price'] is num)
              ? (product['price'] as num).toDouble()
              : 45.0,
          'rating': product['rating'] ?? 4.5,
          'colors': [
            Colors.black,
            Colors.brown,
            Colors.grey.shade400,
            Colors.brown.shade200,
            Colors.blueGrey,
          ],
          'sizes': ['S', 'M', 'L', 'XL'],
          'isFavorite': false,
          'isBase64': true, // Flag to indicate this is base64 image data
        };
      }).toList();
    } else {
      // Show empty state when no dynamic data available - don't create fake products
      products = [];
    }
  }

  fetchData() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    customTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.white,

        title: Column(
          children: [
            TextWidget(title: widget.args.category),
            SizedBox(height: dW * 0.02),
            TextWidget(
              title:
                  widget.args.products != null &&
                      widget.args.products!.isNotEmpty
                  ? '${widget.args.products!.length} items'
                  : '0 items',
            ),
          ],
        ),
      ),
      body: iOSCondition(dH) ? screenBody() : SafeArea(child: screenBody()),
    );
  }

  Widget screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: dW * 0.03),
                CategoryRow(
                  categories: categories,
                  dW: dW,
                  customTextTheme: customTextTheme,
                ),
                ProductViewToggle(
                  viewType: viewType,
                  onChange: (type) => setState(() => viewType = type),
                  dW: dW,
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      // Check if we have real products or just empty state
                      bool hasRealProducts =
                          widget.args.products != null &&
                          widget.args.products!.isNotEmpty;

                      if (!hasRealProducts) {
                        return _buildEmptyState();
                      }

                      if (viewType == ProductViewType.oneList) {
                        return ProductList(
                          products: products,
                          dW: dW,
                          onLikeToggle: (index, liked) {
                            setState(() {
                              products[index]['isFavorite'] = liked;
                            });
                          },
                        );
                      } else {
                        int crossAxisCount = viewType == ProductViewType.twoGrid
                            ? 2
                            : 3;
                        return ProductGrid(
                          products: products,
                          dW: dW,
                          crossAxisCount: crossAxisCount,
                          onLikeToggle: (index, liked) {
                            setState(() {
                              products[index]['isFavorite'] = liked;
                            });
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: dW * 0.2,
            color: Colors.grey[400],
          ),
          SizedBox(height: dW * 0.05),
          Text(
            'No Products Available',
            style: customTextTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: dW * 0.02),
          Text(
            'Please check back later or try another category',
            style: customTextTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class CategoryRow extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final double dW;
  final TextTheme customTextTheme;

  const CategoryRow({
    super.key,
    required this.categories,
    required this.dW,
    required this.customTextTheme,
  });

  Widget _buildBase64Image(String base64String, double size) {
    try {
      if (base64String.isEmpty) {
        return Container(
          width: size,
          height: size,
          color: Colors.grey[300],
          child: Icon(
            Icons.image_not_supported,
            color: Colors.grey[600],
            size: 20,
          ),
        );
      }

      // Extract base64 data (remove data:image/...;base64, prefix if present)
      final base64Data = base64String.contains(',')
          ? base64String.split(',').last
          : base64String;

      final Uint8List imageBytes = base64Decode(base64Data);

      return Image.memory(
        imageBytes,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            color: Colors.grey[300],
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey[600],
              size: 20,
            ),
          );
        },
      );
    } catch (e) {
      return Container(
        width: size,
        height: size,
        color: Colors.grey[300],
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey[600],
          size: 20,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dW * 0.28,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: dW * 0.03,
          vertical: dW * 0.01,
        ),
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: dW * 0.03),
        itemBuilder: (context, i) {
          final cat = categories[i];
          final isBase64 = cat['isBase64'] == true;
          final imageData = cat['image'] ?? '';

          return Column(
            children: [
              Container(
                width: dW * 0.18,
                height: dW * 0.18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200], // Background color for loading
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: isBase64 && imageData.isNotEmpty
                      ? _buildBase64Image(imageData, dW * 0.18)
                      : Container(
                          width: dW * 0.18,
                          height: dW * 0.18,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.category,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 4),
              SizedBox(
                width: dW * 0.18,
                child: Text(
                  cat['name'],
                  textAlign: TextAlign.center,
                  style: customTextTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProductViewToggle extends StatelessWidget {
  final ProductViewType viewType;
  final Function(ProductViewType) onChange;
  final double dW;

  const ProductViewToggle({
    super.key,
    required this.viewType,
    required this.onChange,
    required this.dW,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dW * 0.03, vertical: dW * 0.01),
      child: Row(
        children: [
          Icon(Icons.tune, color: Colors.black54),
          SizedBox(width: 4),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 0),
              minimumSize: Size(0, 36),
            ),
            onPressed: () {},
            child: Text(
              'Sort',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
          ),
          Spacer(),
          IconButton(
            tooltip: "1 product in a row",
            icon: Icon(
              Icons.view_agenda_rounded,
              color: viewType == ProductViewType.oneList
                  ? Colors.black
                  : Colors.black26,
              size: 32,
            ),
            onPressed: () => onChange(ProductViewType.oneList),
          ),
          IconButton(
            tooltip: "2 products in a row",
            icon: Icon(
              Icons.grid_view_rounded,
              color: viewType == ProductViewType.twoGrid
                  ? Colors.black
                  : Colors.black26,
              size: 32,
            ),
            onPressed: () => onChange(ProductViewType.twoGrid),
          ),
          IconButton(
            tooltip: "3 products in a row",
            icon: Icon(
              Icons.apps_rounded,
              color: viewType == ProductViewType.threeGrid
                  ? Colors.black
                  : Colors.black26,
              size: 32,
            ),
            onPressed: () => onChange(ProductViewType.threeGrid),
          ),
        ],
      ),
    );
  }
}

// Update ProductGrid to use the new callback signature
class ProductGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final double dW;
  final int crossAxisCount;
  final Function(int index, bool liked) onLikeToggle;

  const ProductGrid({
    super.key,
    required this.products,
    required this.dW,
    required this.crossAxisCount,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    // Further reduced aspect ratio to give more height
    double aspectRatio = crossAxisCount == 3
        ? 0.60 // Reduced from 0.62 to 0.60
        : 0.72;

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: dW * 0.01, vertical: dW * 0.01),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: dW * 0.03,
        crossAxisSpacing: dW * 0.03,
        childAspectRatio: aspectRatio,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) => ProductCard(
        product: products[i],
        dW: dW,
        isThreeGrid: crossAxisCount == 3,
        onLikeToggle: (liked) {
          onLikeToggle(i, liked);
        },
      ),
    );
  }
}

// Update ProductList to use the new callback signature
class ProductList extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final double dW;
  final Function(int index, bool liked) onLikeToggle;

  const ProductList({
    super.key,
    required this.products,
    required this.dW,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: dW * 0.01, vertical: dW * 0.01),
      itemCount: products.length,
      separatorBuilder: (_, __) => SizedBox(height: dW * 0.03),
      itemBuilder: (context, i) => ProductCard(
        product: products[i],
        dW: dW,
        isFull: true,
        onLikeToggle: (liked) {
          onLikeToggle(i, liked); // Pass index and liked state
        },
      ),
    );
  }
}

// ProductCard remains the same
class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final double dW;
  final bool isFull;
  final bool isThreeGrid;
  final ValueChanged<bool>? onLikeToggle;

  const ProductCard({
    required this.product,
    required this.dW,
    this.isFull = false,
    this.isThreeGrid = false,
    this.onLikeToggle,
    super.key,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Widget _buildProductImage(String imageData, bool isBase64, double height) {
    if (isBase64 && imageData.isNotEmpty) {
      try {
        // Extract base64 data (remove data:image/...;base64, prefix if present)
        final base64Data = imageData.contains(',')
            ? imageData.split(',').last
            : imageData;

        final Uint8List imageBytes = base64Decode(base64Data);

        return Image.memory(
          imageBytes,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: height,
              color: Colors.grey[300],
              child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
            );
          },
        );
      } catch (e) {
        return Container(
          width: double.infinity,
          height: height,
          color: Colors.grey[300],
          child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
        );
      }
    } else {
      // No image data - show placeholder
      return Container(
        width: double.infinity,
        height: height,
        color: Colors.grey[300],
        child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLiked = widget.product['isFavorite'] ?? false;
    final double imageHeight = widget.isFull
        ? widget.dW * 0.7
        : widget.isThreeGrid
        ? widget.dW * 0.22
        : widget.dW * 0.28;

    return Container(
      margin: EdgeInsets.all(widget.dW * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: imageHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                  child: _buildProductImage(
                    widget.product['image'] ?? '',
                    widget.product['isBase64'] == true,
                    imageHeight,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      widget.onLikeToggle?.call(!isLiked);
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey[600],
                        size: widget.isThreeGrid ? 18 : 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Product name
          Container(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Text(
              widget.product['name'],
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: widget.isThreeGrid ? 13 : 15,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Price row
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12, 4, 12, 0),
            child: Row(
              children: [
                Text(
                  '\$${widget.product['oldPrice']}',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: widget.isThreeGrid ? 11 : 13,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  '\$${widget.product['price']}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: widget.isThreeGrid ? 14 : 17,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.local_offer_rounded,
                  color: Colors.amber[700],
                  size: widget.isThreeGrid ? 18 : 22,
                ),
              ],
            ),
          ),
          // Colors row
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12, 4, 12, 0),
            child: Row(
              children: [
                ...widget.product['colors']
                    .take(4)
                    .map<Widget>(
                      (c) => Container(
                        margin: EdgeInsets.only(right: 4),
                        width: widget.isThreeGrid ? 12 : 16,
                        height: widget.isThreeGrid ? 12 : 16,
                        decoration: BoxDecoration(
                          color: c,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black12, width: 1),
                        ),
                      ),
                    ),
                if (widget.product['colors'].length > 4)
                  Container(
                    margin: EdgeInsets.only(left: 4),
                    child: Text(
                      '+${widget.product['colors'].length - 4}',
                      style: TextStyle(
                        fontSize: widget.isThreeGrid ? 10 : 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Sizes row
          Padding(
            padding: EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: Text(
              widget.product['sizes'].join(' '),
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: widget.isThreeGrid ? 11 : 13,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
