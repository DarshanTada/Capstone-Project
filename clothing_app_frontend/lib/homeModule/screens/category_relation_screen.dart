import 'package:clothing_app_frontend/authModule/providers/auth_provider.dart';
import 'package:clothing_app_frontend/common_functions.dart';
import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:clothing_app_frontend/common_widgets/custom_app_bar.dart';
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

  List<Map<String, dynamic>> categories = [
    {'name': 'Baggy', 'image': 'https://i.imgur.com/8Km9tLL.jpg'},
    {'name': 'Straight Fit', 'image': 'https://i.imgur.com/5tj6S7Ol.jpg'},
    {'name': 'Carpenter', 'image': 'https://i.imgur.com/3y5b2.jpg'},
  ];
  List<Map<String, dynamic>> products = List.generate(10, (i) {
    return {
      'name': 'Charcoal Fade Jeans',
      'image': [
        'https://i.imgur.com/5tj6S7Ol.jpg',
        'https://i.imgur.com/5tj6S7Ol.jpg',
        'https://i.imgur.com/3y5b2.jpg',
      ][i % 3],
      'oldPrice': 60 + i,
      'price': 50,
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

  @override
  void initState() {
    super.initState();
    fetchData();
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
            TextWidget(title: 'Vintage jeans'),
            SizedBox(height: dW * 0.02),
            TextWidget(title: '1256 items'),
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
                          onUpdate: setState, // <-- Pass setState
                        );
                      } else {
                        int crossAxisCount = viewType == ProductViewType.twoGrid
                            ? 2
                            : 3;
                        return ProductGrid(
                          products: products,
                          dW: dW,
                          crossAxisCount: crossAxisCount,
                          onUpdate: setState, // <-- Pass setState
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
                    image: NetworkImage(cat['image']),
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

class ProductGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final double dW;
  final int crossAxisCount;
  final void Function(void Function()) onUpdate; // <-- Add this

  const ProductGrid({
    super.key,
    required this.products,
    required this.dW,
    required this.crossAxisCount,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    // Lower aspect ratio for more height and no overflow
    double aspectRatio = crossAxisCount == 3
        ? 0.65
        : 0.75; // <-- Tweak these values
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
          products[i]['isFavorite'] = liked;
          onUpdate(() {}); // <-- Call setState from parent
        },
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final double dW;
  final void Function(void Function()) onUpdate; // <-- Add this

  const ProductList({
    super.key,
    required this.products,
    required this.dW,
    required this.onUpdate,
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
          products[i]['isFavorite'] = liked;
          onUpdate(() {}); // <-- Call setState from parent
        },
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final double dW;
  final bool isFull;
  final bool isThreeGrid;
  final ValueChanged<bool>? onLikeToggle; // <-- Add this

  const ProductCard({
    required this.product,
    required this.dW,
    this.isFull = false,
    this.isThreeGrid = false,
    this.onLikeToggle, // <-- Add this
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
                  child: Image.network(
                    widget.product['image'],
                    width: double.infinity,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      widget.onLikeToggle?.call(!isLiked);
                    },
                    child: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.white,
                      size: widget.isThreeGrid ? 22 : 26,
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
                ...widget.product['colors'].map<Widget>(
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
              ],
            ),
          ),
          // Sizes row
          Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
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
