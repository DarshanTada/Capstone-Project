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
    // Set categories based on the selected category from CategoryScreen
    if (widget.args.category == 'Jeans') {
      categories = [
        {
          'name': 'Baggy',
          'image': 'assets/products/6_jeans/baggy/product_6_1.png',
        },
        {
          'name': 'Skinny',
          'image': 'assets/products/6_jeans/skinny_jeans/product_6_1.png',
        },
        {
          'name': 'Ripped',
          'image': 'assets/products/6_jeans/ripped_jeans/product_6_1.png',
        },
        {
          'name': 'Wide Leg',
          'image': 'assets/products/6_jeans/wide_leg_jeans/product_6_1.png',
        },
        {
          'name': 'Splatter Loose Fit',
          'image':
              'assets/products/6_jeans/splatter_loose_fit_jeans/product_6_1.png',
        },
      ];
    } else if (widget.args.category == 'Shorts') {
      categories = [
        {
          'name': 'Jeans Shorts',
          'image': 'assets/products/4_shorts/jeans_shorts/product_4_1.png',
        },
        {
          'name': 'Linen Shorts',
          'image': 'assets/products/4_shorts/linen_shorts/product_4_1.png',
        },
      ];
    } else if (widget.args.category == 'T-Shirts') {
      categories = [
        {
          'name': 'Collar T-Shirts',
          'image': 'assets/products/8_t-shirts/collar_tshirts/product_8_1.png',
        },
        {
          'name': 'Wide T-Shirts',
          'image': 'assets/products/8_t-shirts/wide_tshirts/product_8_4.png',
        },
        {
          'name': 'Cotton Shirts',
          'image': 'assets/products/7_shirts/cotton_shirts/product_7_1.png',
        },
        {
          'name': 'Jeans Shirts',
          'image': 'assets/products/7_shirts/jeans_shirts/product_7_1.png',
        },
      ];
    } else {
      // Default categories for other types
      categories = [
        {
          'name': 'All Items',
          'image': 'assets/products/6_jeans/baggy/product_6_1.png',
        },
      ];
    }
  }

  void _initializeProducts() {
    products = List.generate(10, (i) {
      // Create different product types based on category with actual asset images
      List<String> imagesToUse = [];
      List<String> productNames = [];

      if (widget.args.category == 'Jeans') {
        // Use actual jeans images from different subcategories
        imagesToUse = [
          'assets/products/6_jeans/baggy/product_6_1.png',
          'assets/products/6_jeans/baggy/product_6_2.png',
          'assets/products/6_jeans/skinny_jeans/product_6_1.png',
          'assets/products/6_jeans/skinny_jeans/product_6_2.png',
          'assets/products/6_jeans/ripped_jeans/product_6_1.png',
          'assets/products/6_jeans/wide_leg_jeans/product_6_1.png',
          'assets/products/6_jeans/splatter_loose_fit_jeans/product_6_1.png',
        ];
        productNames = [
          'Baggy Denim Jeans',
          'Premium Baggy Jeans',
          'Skinny Fit Jeans',
          'Slim Skinny Jeans',
          'Ripped Denim Jeans',
          'Wide Leg Jeans',
          'Splatter Loose Fit Jeans',
        ];
      } else if (widget.args.category == 'Shorts') {
        // Use actual shorts images
        imagesToUse = [
          'assets/products/4_shorts/jeans_shorts/product_4_1.png',
          'assets/products/4_shorts/jeans_shorts/product_4_2.png',
          'assets/products/4_shorts/linen_shorts/product_4_1.png',
          'assets/products/4_shorts/linen_shorts/product_4_2.png',
        ];
        productNames = [
          'Denim Cargo Shorts',
          'Classic Jeans Shorts',
          'Summer Linen Shorts',
          'Casual Linen Shorts',
        ];
      } else if (widget.args.category == 'T-Shirts') {
        // Use actual t-shirts and shirts images
        imagesToUse = [
          'assets/products/8_t-shirts/collar_tshirts/product_8_1.png',
          'assets/products/8_t-shirts/collar_tshirts/product_8_2.png',
          'assets/products/8_t-shirts/collar_tshirts/product_8_3.png',
          'assets/products/8_t-shirts/wide_tshirts/product_8_4.png',
          'assets/products/8_t-shirts/wide_tshirts/product_8_5.png',
          'assets/products/7_shirts/cotton_shirts/product_7_1.png',
          'assets/products/7_shirts/cotton_shirts/product_7_2.png',
          'assets/products/7_shirts/cotton_shirts/product_7_3.png',
          'assets/products/7_shirts/jeans_shirts/product_7_1.png',
        ];
        productNames = [
          'Classic Collar T-Shirt',
          'Premium Collar T-Shirt',
          'Designer Collar T-Shirt',
          'Wide Fit T-Shirt',
          'Oversized Wide T-Shirt',
          'Cotton Casual Shirt',
          'Premium Cotton Shirt',
          'Classic Cotton Shirt',
          'Denim Style Shirt',
        ];
      } else {
        // Default fallback
        imagesToUse = ['assets/products/6_jeans/baggy/product_6_1.png'];
        productNames = ['Classic Item'];
      }

      // Cycle through available images and names
      String selectedImage = imagesToUse[i % imagesToUse.length];
      String selectedName = productNames[i % productNames.length];

      return {
        'name': selectedName,
        'image': selectedImage,
        'oldPrice': 60 + (i * 5),
        'price': 45 + (i * 3),
        'colors': [
          Colors.black,
          Colors.brown,
          Colors.grey.shade400,
          Colors.brown.shade200,
          Colors.blueGrey,
        ],
        'sizes': ['S', 'M', 'L', 'XL'],
        'isFavorite': i % 2 == 0,
      };
    });
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
              title: widget.args.category == 'Jeans'
                  ? '156 items'
                  : '163 items',
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
          return Column(
            children: [
              Container(
                width: dW * 0.18,
                height: dW * 0.18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(
                      cat['image'],
                    ), // Changed from NetworkImage to AssetImage
                    fit: BoxFit.cover,
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
                  child: Image.asset(
                    widget.product['image'],
                    width: double.infinity,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: imageHeight,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                      );
                    },
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
