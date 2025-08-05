import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../authModule/providers/auth_provider.dart';
import '../../checkoutModule/screens/checkout_screen.dart';
import '../providers/cart_provider.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen>
    with SingleTickerProviderStateMixin {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  String? userId;

  // Sample cart data - Updated with Denim Jeans (will be replaced with API data)
  List<Map<String, dynamic>> cartItems = [];

  fetchData() async {
    // Get user ID from AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user.id != null && user.id!.isNotEmpty) {
      userId = user.id!;
      print('👤 User ID loaded: $userId');

      // Fetch cart data
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      await cartProvider.getCart(userId!);

      setState(() {
        // Convert CartItem objects to Map for compatibility with existing UI
        cartItems = cartProvider.cartItems
            .map(
              (cartItem) => {
                "variantId": cartItem.variantId,
                "name": cartItem.product?.name ?? "Unknown Product",
                "size": cartItem.size.toUpperCase(),
                "color": cartItem.variant?.color ?? "Default",
                "price":
                    cartItem.variant?.discountPrice ??
                    cartItem.variant?.price ??
                    0.0,
                "originalPrice": cartItem.variant?.price,
                "discount": cartItem.variant?.discountPrice != null
                    ? "${(((cartItem.variant!.price! - cartItem.variant!.discountPrice!) / cartItem.variant!.price!) * 100).round()}% OFF"
                    : null,
                "quantity": cartItem.quantity,
                "image":
                    cartItem.image ??
                    "assets/images/placeholder.png", // Use image directly as string
                "rating":
                    4.5, // Default rating - could be enhanced from product data
                "reviews": "Reviews",
              },
            )
            .toList();
      });
    } else {
      print('❌ No user ID found');
    }
  }

  late AnimationController _animationController;
  late Animation<double> _badgeAnimation;

  int get totalItems {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return cartProvider.totalItems > 0
        ? cartProvider.totalItems
        : cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }

  @override
  void initState() {
    super.initState();
    fetchData();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Create badge animation
    _badgeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Start animation when screen loads
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
          'My Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Center(
          child: AnimatedBuilder(
            animation: _badgeAnimation,
            builder: (context, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Transform.scale(
                    scale: _badgeAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFB8956A).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.shopping_cart,
                        color: Color(0xFFB8956A),
                        size: 20,
                      ),
                    ),
                  ),
                  if (totalItems > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Transform.scale(
                        scale: _badgeAnimation.value,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            totalItems.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return SizedBox(
            height: dH,
            width: dW,
            child: isLoading || cartProvider.isLoading
                ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
                    child: Column(
                      children: [
                        SizedBox(height: dW * 0.05),
                        if (cartProvider.error != null)
                          Container(
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    cartProvider.error!,
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    cartProvider.clearError();
                                    fetchData();
                                  },
                                  child: Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        if (cartItems.isEmpty)
                          Center(
                            child: Column(
                              children: [
                                SizedBox(height: dH * 0.2),
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 80,
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Your cart is empty',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Add some items to get started',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          ...cartItems.map((item) => cartItemCard(item)),
                          SizedBox(height: dW * 0.05),
                          discountBox(),
                          SizedBox(height: dW * 0.04),
                          orderSummarySection(),
                          SizedBox(height: dW * 0.06),
                          checkoutButton(),
                        ],
                        SizedBox(height: dW * 0.1),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget cartItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: dW * 0.25,
            height: dW * 0.28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(item['image']),
            ),
          ),
          SizedBox(width: dW * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  item['name'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),

                // Size and Color
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0xFFD2B193).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Size: ${item['size']}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB8956A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0xFFD2B193).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['color'] ?? "Default",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB8956A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Price and Discount
                Row(
                  children: [
                    Text(
                      "\$${item['price'].toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    if (item['originalPrice'] != null) ...[
                      SizedBox(width: 8),
                      Text(
                        "\$${item['originalPrice'].toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(width: 6),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF8FBC8F),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item['discount'] ?? "",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 8),

                // Rating if available
                if (item['rating'] != null)
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.white, size: 12),
                            SizedBox(width: 2),
                            Text(
                              item['rating'].toString(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        item['reviews'] ?? "",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 12),

                // Quantity Controls and Delete
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (item['quantity'] > 1) {
                          final newQuantity = item['quantity'] - 1;
                          final cartProvider = Provider.of<CartProvider>(
                            context,
                            listen: false,
                          );

                          final success = await cartProvider.updateQuantity(
                            userId!,
                            item['variantId'],
                            newQuantity,
                          );

                          if (success) {
                            setState(() {
                              item['quantity'] = newQuantity;
                              // Restart animation when quantity changes
                              _animationController.reset();
                              _animationController.forward();
                            });
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFD2B193)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 16,
                          color: Color(0xFFB8956A),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        item['quantity'].toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final newQuantity = item['quantity'] + 1;
                        final cartProvider = Provider.of<CartProvider>(
                          context,
                          listen: false,
                        );

                        final success = await cartProvider.updateQuantity(
                          userId!,
                          item['variantId'],
                          newQuantity,
                        );

                        if (success) {
                          setState(() {
                            item['quantity'] = newQuantity;
                            // Restart animation when quantity changes
                            _animationController.reset();
                            _animationController.forward();
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Color(0xFFD2B193),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () async {
                        final cartProvider = Provider.of<CartProvider>(
                          context,
                          listen: false,
                        );

                        final success = await cartProvider.removeFromCart(
                          userId!,
                          item['variantId'],
                        );

                        if (success) {
                          setState(() {
                            cartItems.remove(item);
                          });
                        }
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget discountBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFD2B193), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Enter a discount coupon",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Apply coupon logic
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "APPLY",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget orderSummarySection() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    double subTotal = cartProvider.subTotalAmount > 0
        ? cartProvider.subTotalAmount
        : cartItems.fold(
            0.0,
            (sum, item) => sum + (item['price'] * item['quantity']),
          );
    double deliveryFee = 5.99;
    double discount = 25.00;
    double total = subTotal + deliveryFee - discount;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          orderRow("Sub-total", "\$${subTotal.toStringAsFixed(2)}"),
          orderRow("Delivery Fee", "\$${deliveryFee.toStringAsFixed(2)}"),
          orderRow(
            "Discount",
            "- \$${discount.toStringAsFixed(2)}",
            color: Color(0xFF8FBC8F),
          ),
          Divider(color: Colors.grey.shade300),
          orderRow("Total", "\$${total.toStringAsFixed(2)}", isBold: true),
        ],
      ),
    );
  }

  Widget orderRow(
    String label,
    String value, {
    Color? color,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : null,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget checkoutButton() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    double subTotal = cartProvider.subTotalAmount > 0
        ? cartProvider.subTotalAmount
        : cartItems.fold(
            0.0,
            (sum, item) => sum + (item['price'] * item['quantity']),
          );
    double deliveryFee = 5.99;
    double discount = 25.00;
    double total = subTotal + deliveryFee - discount;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFD2B193), Color(0xFFB8956A), Color(0xFFA67C52)],
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
        onPressed: cartItems.isNotEmpty
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutScreen(),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(Icons.payment, color: Colors.white, size: 20),
        label: Text(
          cartItems.isNotEmpty
              ? 'Proceed to Checkout - \$${total.toStringAsFixed(2)}'
              : 'Cart is Empty',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.asset(
        'assets/images/placeholder.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.grey.shade400,
              size: 40,
            ),
          );
        },
      );
    }

    // Check if it's a data URL (from API)
    if (imageUrl.startsWith('data:')) {
      try {
        // Extract base64 data from data URL
        final base64Data = imageUrl.split(',')[1];
        final bytes = base64Decode(base64Data);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackImage();
          },
        );
      } catch (e) {
        print('Error decoding base64 image: $e');
        return _buildFallbackImage();
      }
    }

    // If it's a regular asset path
    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackImage();
      },
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      color: Colors.grey.shade200,
      child: Icon(
        Icons.shopping_bag_outlined,
        color: Colors.grey.shade400,
        size: 40,
      ),
    );
  }
}
