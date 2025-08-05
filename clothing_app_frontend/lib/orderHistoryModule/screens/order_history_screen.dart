import 'package:clothing_app_frontend/common_widgets/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../authModule/providers/auth_provider.dart';
import '../../orderModule/providers/order_provider.dart';
import '../../common_functions.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;

  fetchData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    if (authProvider.user.id != null && authProvider.user.id!.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      print('🔄 Fetching orders for user: ${authProvider.user.id}');

      await orderProvider.getUserOrders(
        userId: authProvider.user.id!,
        limit: 20,
        refresh: true,
      );

      setState(() {
        isLoading = false;
      });
    } else {
      print('❌ No user found, cannot fetch orders');
    }
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

    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: const Text(
              'Order History',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.brown.shade300,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.filter_list, color: Colors.brown.shade300),
                onPressed: () {
                  // Add filter functionality
                },
              ),
            ],
          ),
          body: iOSCondition(dH)
              ? screenBody(orderProvider)
              : SafeArea(child: screenBody(orderProvider)),
        );
      },
    );
  }

  Widget screenBody(OrderProvider orderProvider) {
    final orders = orderProvider.userOrders;
    final isApiLoading = orderProvider.isLoadingOrders;
    final error = orderProvider.error;

    return SizedBox(
      height: dH,
      width: dW,
      child: (isLoading || isApiLoading)
          ? CircularLoader(android: dW * 0.08, iOS: dW * 0.035)
          : error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: dW * 0.15,
                    color: Colors.red.shade400,
                  ),
                  SizedBox(height: dH * 0.02),
                  Text(
                    'Error Loading Orders',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: dH * 0.01),
                  Text(
                    error,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: dH * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      orderProvider.clearError();
                      fetchData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB8956A),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: dW * 0.08,
                        vertical: dH * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Retry'),
                  ),
                ],
              ),
            )
          : orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(dW * 0.1),
                    decoration: BoxDecoration(
                      color: Color(0xFFD2B193).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: dW * 0.15,
                      color: Color(0xFFB8956A),
                    ),
                  ),
                  SizedBox(height: dH * 0.03),
                  Text(
                    'No Orders Yet',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: dH * 0.01),
                  Text(
                    'Start shopping to see your orders here',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                if (authProvider.user.id != null) {
                  await orderProvider.refreshOrders(
                    userId: authProvider.user.id!,
                    limit: 20,
                  );
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: dH * 0.02),
                    Text(
                      '${orders.length} Orders',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: dH * 0.02),
                    ...orders.map((order) => orderCard(order)),
                    SizedBox(height: dH * 0.1),
                  ],
                ),
              ),
            ),
    );
  }

  Widget orderCard(dynamic orderData) {
    // Handle both API structure and legacy structure
    Map<String, dynamic> order;

    if (orderData is Map<String, dynamic>) {
      // Legacy hardcoded structure
      if (orderData.containsKey('name')) {
        order = orderData;
      } else {
        // API structure - extract from first product
        final products = orderData['products'] as List<dynamic>? ?? [];
        if (products.isNotEmpty) {
          final firstProduct = products[0];
          final productInfo = firstProduct['product'] ?? {};
          final imageData = firstProduct['image'];

          // Debug print to see the actual image structure
          print('🖼️ Image data structure: $imageData');

          // Handle different image URL formats
          String? imageUrl;
          if (imageData != null) {
            if (imageData is Map<String, dynamic>) {
              // If image is an object with 'image' property
              imageUrl = imageData['image']?.toString();
            } else if (imageData is String) {
              // If image is directly a string
              imageUrl = imageData;
            }

            // If imageUrl is relative, prepend the base URL
            if (imageUrl != null && imageUrl.isNotEmpty) {
              if (imageUrl.startsWith('http')) {
                // Already a full URL
              } else if (imageUrl.startsWith('/')) {
                // Relative URL starting with /
                imageUrl = imageUrl;
              } else {
                // Relative URL without /
                imageUrl = imageUrl;
              }
            }
          }

          print('🖼️ Final image URL: $imageUrl');

          order = {
            'name': productInfo['name'] ?? 'Unknown Product',
            'size': firstProduct['size'] ?? 'Unknown',
            'price': (firstProduct['price'] ?? 0.0),
            'image': imageUrl,
            'status': _getOrderStatus(
              orderData['status'] ?? firstProduct['status'],
            ),
            'date': _formatDate(orderData['createdAt']),
            'orderId': orderData['_id'] ?? '',
            'totalProducts': products.length,
          };
        } else {
          // Fallback for empty products
          order = {
            'name': 'Unknown Product',
            'size': 'Unknown',
            'price': 0.0,
            'image': null,
            'status': 'Unknown',
            'date': null,
            'orderId': orderData['_id'] ?? '',
            'totalProducts': 0,
          };
        }
      }
    } else {
      // Fallback for unexpected structure
      order = {
        'name': 'Unknown Product',
        'size': 'Unknown',
        'price': 0.0,
        'image': null,
        'status': 'Unknown',
        'date': null,
        'orderId': '',
        'totalProducts': 0,
      };
    }

    return Container(
      margin: EdgeInsets.only(bottom: dH * 0.02),
      padding: EdgeInsets.all(dW * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: dW * 0.24,
                    width: dW * 0.24,
                    child: _buildOrderImage(order['image']),
                  ),
                ),
              ),
              SizedBox(width: dW * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            order['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              order['status'],
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getStatusIcon(order['status']),
                            size: 18,
                            color: _getStatusColor(order['status']),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: dH * 0.012),
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Color(0xFFD2B193),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFFB8956A),
                              width: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Size ${order['size']}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        if (order['totalProducts'] != null &&
                            order['totalProducts'] > 1) ...[
                          SizedBox(width: 12),
                          Text(
                            "+${order['totalProducts'] - 1} more",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: dH * 0.015),
                    Text(
                      "\$${order['price'].toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Color(0xFFB8956A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: dH * 0.02),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: dH * 0.015,
              horizontal: dW * 0.04,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getStatusColor(order['status']).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStatusLabel(order['status']),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      order['date'] ?? order['status'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(order['status']),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order['status']),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getStatusAction(order['status']),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for status handling
  String _getOrderStatus(dynamic status) {
    if (status == null) return 'Unknown';
    if (status is String) return status;
    return status.toString();
  }

  String _formatDate(dynamic dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString.toString());
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return "${months[date.month - 1]} ${date.day}, ${date.year}";
    } catch (e) {
      return '';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'receipt':
      case 'completed':
        return Colors.green.shade600;
      case 'shipped':
      case 'shipping':
        return Colors.blue.shade600;
      case 'pending':
      case 'order placed':
        return Colors.orange.shade600;
      case 'cancelled':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'receipt':
      case 'completed':
        return Icons.check_circle_outline;
      case 'shipped':
      case 'shipping':
        return Icons.local_shipping_outlined;
      case 'pending':
      case 'order placed':
        return Icons.schedule;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'receipt':
      case 'completed':
        return 'Delivered';
      case 'shipped':
      case 'shipping':
        return 'Shipped';
      case 'pending':
      case 'order placed':
        return 'Order Status';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Status';
    }
  }

  String _getStatusAction(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'receipt':
      case 'completed':
        return 'View Receipt';
      case 'shipped':
      case 'shipping':
        return 'Track Order';
      case 'pending':
      case 'order placed':
        return 'Track Order';
      case 'cancelled':
        return 'View Details';
      default:
        return 'View Order';
    }
  }

  // Image builder method similar to checkout screen
  Widget _buildOrderImage(String? imageUrl) {
    print('🖼️ Building image for URL: $imageUrl');

    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildFallbackImage();
    }

    // Check if it's a data URL (base64 encoded)
    if (imageUrl.startsWith('data:')) {
      try {
        print('🖼️ Processing data URL image');
        // Extract base64 data from data URL
        final base64Data = imageUrl.split(',')[1];
        final bytes = base64Decode(base64Data);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: dW * 0.24,
          height: dW * 0.24,
          errorBuilder: (context, error, stackTrace) {
            print('❌ Error loading base64 image: $error');
            return _buildFallbackImage();
          },
        );
      } catch (e) {
        print('❌ Error decoding base64 image: $e');
        return _buildFallbackImage();
      }
    }

    // Check if it's a network URL (http/https)
    if (imageUrl.startsWith('http')) {
      print('🖼️ Processing network URL image');
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: dW * 0.24,
        height: dW * 0.24,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            width: dW * 0.24,
            height: dW * 0.24,
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
                color: Color(0xFFB8956A),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('❌ Error loading network image: $imageUrl - Error: $error');
          return _buildFallbackImage();
        },
      );
    }

    // If it's a local asset path, try Image.asset
    print('🖼️ Processing asset image: $imageUrl');
    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      width: dW * 0.24,
      height: dW * 0.24,
      errorBuilder: (context, error, stackTrace) {
        print('❌ Error loading asset image: $imageUrl - Error: $error');
        return _buildFallbackImage();
      },
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: dW * 0.24,
      height: dW * 0.24,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            color: Colors.grey.shade400,
            size: dW * 0.08,
          ),
          SizedBox(height: 4),
          Text(
            'No Image',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
