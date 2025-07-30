import 'package:clothing_app_frontend/api.dart';
import 'package:clothing_app_frontend/homeModule/model/category_model.dart';
import 'package:clothing_app_frontend/http_helper.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  Map<String, dynamic> _categoryProducts = {};
  bool _isLoadingProducts = false;

  List<Category> get categories => _categories;
  Map<String, dynamic> get categoryProducts => _categoryProducts;
  bool get isLoadingProducts => _isLoadingProducts;

  // Helper method to get top products from the response
  List<dynamic> get topProducts {
    if (_categoryProducts['success'] == true &&
        _categoryProducts['data'] != null) {
      final data = _categoryProducts['data'] as List<dynamic>;
      for (var section in data) {
        if (section is Map<String, dynamic> &&
            section['name'] == 'Top' &&
            section['products'] is List) {
          return section['products'] as List<dynamic>;
        }
      }
    }
    return [];
  }

  // Helper method to get bottom products from the response
  List<dynamic> get bottomProducts {
    if (_categoryProducts['success'] == true &&
        _categoryProducts['data'] != null) {
      final data = _categoryProducts['data'] as List<dynamic>;
      for (var section in data) {
        if (section is Map<String, dynamic> &&
            section['name'] == 'Bottom' &&
            section['products'] is List) {
          return section['products'] as List<dynamic>;
        }
      }
    }
    return [];
  }

  // Helper method to get banners from the response
  List<dynamic> get banners {
    if (_categoryProducts['success'] == true &&
        _categoryProducts['data'] != null) {
      final data = _categoryProducts['data'] as List<dynamic>;
      for (var section in data) {
        if (section is Map<String, dynamic> && section['banners'] is List) {
          return section['banners'] as List<dynamic>;
        }
      }
    }
    return [];
  }

  // Helper method to get categories from the response
  List<dynamic> get categoryList {
    if (_categoryProducts['success'] == true &&
        _categoryProducts['data'] != null) {
      final data = _categoryProducts['data'] as List<dynamic>;
      for (var section in data) {
        if (section is Map<String, dynamic> && section['category'] is List) {
          return section['category'] as List<dynamic>;
        }
      }
    }
    return [];
  }

  // Helper method to get filters from the response
  Map<String, dynamic> get filters {
    if (_categoryProducts['success'] == true &&
        _categoryProducts['filters'] != null) {
      return _categoryProducts['filters'] as Map<String, dynamic>;
    }
    return {};
  }

  // Helper method to get all products combined
  List<dynamic> get allProducts {
    List<dynamic> combined = [];
    combined.addAll(topProducts);
    combined.addAll(bottomProducts);
    return combined;
  }

  // Helper method to get product by ID
  Map<String, dynamic>? getProductById(String productId) {
    for (var product in allProducts) {
      if (product is Map<String, dynamic> &&
          product['_id']?.toString() == productId) {
        return product;
      }
    }
    return null;
  }

  // Helper method to get products by subcategory
  List<dynamic> getProductsBySubcategory(String subcategoryId) {
    return allProducts.where((product) {
      if (product is Map<String, dynamic>) {
        final subcategory = product['subcategory'];
        if (subcategory is List && subcategory.isNotEmpty) {
          final subcat = subcategory[0];
          if (subcat is Map<String, dynamic>) {
            return subcat['_id']?.toString() == subcategoryId;
          }
        }
      }
      return false;
    }).toList();
  }

  // Helper method to safely get product price
  String getProductPrice(Map<String, dynamic> product) {
    // Try different possible price field names
    final price =
        product['price'] ??
        product['selling_price'] ??
        product['mrp'] ??
        product['cost_price'];

    if (price is num) {
      return '\$${price.toStringAsFixed(0)}'; // Remove decimals for cleaner look
    } else if (price is String) {
      // Try to parse the string as a number first
      final numPrice = double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), ''));
      if (numPrice != null) {
        return '\$${numPrice.toStringAsFixed(0)}';
      }
      return price.startsWith('\$') ? price : '\$$price';
    }

    // Fallback to a default price for demo
    return '\$50';
  }

  // Helper method to safely get product rating (hardcoded for now)
  double getProductRating(Map<String, dynamic> product) {
    final rating =
        product['rating'] ??
        product['average_rating'] ??
        product['review_rating'];

    if (rating is num) {
      return rating.toDouble().clamp(0.0, 5.0);
    } else if (rating is String) {
      final parsedRating = double.tryParse(rating) ?? 0.0;
      return parsedRating.clamp(0.0, 5.0);
    }

    // Hardcode a random rating between 4.0 and 5.0 for demo
    final productId = product['_id']?.toString() ?? '';
    final hash = productId.hashCode.abs();
    final demoRating =
        4.0 + (hash % 10) / 10.0; // Generates rating between 4.0-4.9
    return double.parse(demoRating.toStringAsFixed(1));
  }

  // Helper method to get product name
  String getProductName(Map<String, dynamic> product) {
    return product['name']?.toString() ?? 'Product';
  }

  // Helper method to get product description
  String getProductDescription(Map<String, dynamic> product) {
    return product['description']?.toString() ?? '';
  }

  // Helper method to get first image for a product (from images array)
  String? getProductImage(Map<String, dynamic> product) {
    try {
      // First try to get from images array (from ProductImage collection)
      final images = product['images'];
      if (images is List && images.isNotEmpty) {
        final firstImage = images[0];
        if (firstImage is Map<String, dynamic>) {
          // Check different possible image field names
          String? imageData =
              firstImage['image'] as String? ??
              firstImage['variant_0_image_0'] as String? ??
              firstImage['imageData'] as String? ??
              firstImage['base64'] as String?;

          if (imageData != null && imageData.isNotEmpty) {
            // If it's base64 data, return as data URL
            if (!imageData.startsWith('data:') &&
                !imageData.startsWith('http')) {
              return 'data:image/jpeg;base64,$imageData';
            }
            return imageData;
          }
        }
      }

      // Fallback to variants if no images (from ProductVariant collection)
      final variants = product['variants'];
      if (variants is List && variants.isNotEmpty) {
        final firstVariant = variants[0];
        if (firstVariant is Map<String, dynamic>) {
          String? imageData =
              firstVariant['image'] as String? ??
              firstVariant['variant_0_image_0'] as String? ??
              firstVariant['imageData'] as String? ??
              firstVariant['base64'] as String?;

          if (imageData != null && imageData.isNotEmpty) {
            // If it's base64 data, return as data URL
            if (!imageData.startsWith('data:') &&
                !imageData.startsWith('http')) {
              return 'data:image/jpeg;base64,$imageData';
            }
            return imageData;
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting product image: $e');
      debugPrint('Product structure: ${product.keys}');
      if (product['images'] != null) {
        debugPrint('Images structure: ${product['images']}');
      }
      if (product['variants'] != null) {
        debugPrint('Variants structure: ${product['variants']}');
      }
    }
    return null;
  }

  // Helper method to get all images for a product
  List<String> getProductImages(Map<String, dynamic> product) {
    try {
      List<String> allImages = [];

      // Get images from images array (from ProductImage collection)
      final images = product['images'];
      if (images is List) {
        for (var image in images) {
          if (image is Map<String, dynamic>) {
            String? imageData =
                image['image'] as String? ??
                image['variant_0_image_0'] as String? ??
                image['imageData'] as String? ??
                image['base64'] as String?;

            if (imageData != null && imageData.isNotEmpty) {
              // If it's base64 data, return as data URL
              if (!imageData.startsWith('data:') &&
                  !imageData.startsWith('http')) {
                allImages.add('data:image/jpeg;base64,$imageData');
              } else {
                allImages.add(imageData);
              }
            }
          }
        }
      }

      // Get images from variants if images array is empty (from ProductVariant collection)
      if (allImages.isEmpty) {
        final variants = product['variants'];
        if (variants is List) {
          for (var variant in variants) {
            if (variant is Map<String, dynamic>) {
              String? imageData =
                  variant['image'] as String? ??
                  variant['variant_0_image_0'] as String? ??
                  variant['imageData'] as String? ??
                  variant['base64'] as String?;

              if (imageData != null && imageData.isNotEmpty) {
                // If it's base64 data, return as data URL
                if (!imageData.startsWith('data:') &&
                    !imageData.startsWith('http')) {
                  allImages.add('data:image/jpeg;base64,$imageData');
                } else {
                  allImages.add(imageData);
                }
              }
            }
          }
        }
      }

      return allImages;
    } catch (e) {
      debugPrint('Error getting product images: $e');
    }
    return [];
  }

  Future<Map<String, dynamic>> fetchCategory({required String query}) async {
    try {
      final url = '${webApi['domain']}${endPoint['getCategory']}?$query';

      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
      );

      if (response['success'] == true && response['data'] is List) {
        List<Category> fetchedCategories = (response['data'] as List)
            .map(
              (category) =>
                  Category.jsonToCategory(Map<String, dynamic>.from(category)),
            )
            .toList();

        _categories = fetchedCategories;
        notifyListeners();
      }

      return response;
    } catch (error) {

      return {'success': false, 'message': 'failedGetCategories'};
    }
  }

  Future<Map<String, dynamic>> getProductsByCategory({
    String? bodyType,
    String? gender,
  }) async {
    try {
      _isLoadingProducts = true;
      notifyListeners();

      final url = '${webApi['domain']}${endPoint['getProductsByCategory']}';

      final requestBody = <String, dynamic>{};
      if (bodyType != null) requestBody['bodyType'] = bodyType;
      if (gender != null) requestBody['gender'] = gender;

      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: requestBody,
      );

      if (response['success'] == true && response['data'] != null) {
        _categoryProducts = response;

        // Debug: Log the structure to help troubleshoot
        debugProductStructure();

        // Update categories from the response
        final categoryData = categoryList;
        if (categoryData.isNotEmpty) {
          List<Category> fetchedCategories = categoryData
              .map(
                (category) => Category.jsonToCategory(
                  Map<String, dynamic>.from(category),
                ),
              )
              .toList();
          _categories = fetchedCategories;
        }

        notifyListeners();
      }

      return response;
    } catch (error) {
      debugPrint('Error getting products by category: $error');
      return {'success': false, 'message': 'failedGetCategoryProducts'};
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  // Clear products when needed
  void clearProducts() {
    _categoryProducts = {};
    notifyListeners();
  }

  // Debug method to log product structure (call this to see what data is available)
  void debugProductStructure() {
    debugPrint('=== DEBUG: Category Products Response ===');
    debugPrint('Response keys: ${_categoryProducts.keys}');

    if (_categoryProducts['data'] != null) {
      final data = _categoryProducts['data'] as List<dynamic>;
      debugPrint('Data sections: ${data.length}');

      for (int i = 0; i < data.length; i++) {
        final section = data[i];
        if (section is Map<String, dynamic>) {
          debugPrint('Section $i keys: ${section.keys}');

          if (section['name'] != null) {
            debugPrint('Section name: ${section['name']}');
            if (section['products'] is List) {
              final products = section['products'] as List<dynamic>;
              debugPrint('Products count: ${products.length}');

              if (products.isNotEmpty) {
                final firstProduct = products[0];
                if (firstProduct is Map<String, dynamic>) {
                  debugPrint('First product keys: ${firstProduct.keys}');
                  debugPrint('First product price: ${firstProduct['price']}');
                  debugPrint('First product rating: ${firstProduct['rating']}');

                  if (firstProduct['images'] != null) {
                    debugPrint('Images structure: ${firstProduct['images']}');
                    final images = firstProduct['images'];
                    if (images is List && images.isNotEmpty) {
                      final firstImage = images[0];
                      if (firstImage is Map<String, dynamic>) {
                        debugPrint('First image keys: ${firstImage.keys}');
                      }
                    }
                  }

                  if (firstProduct['variants'] != null) {
                    debugPrint(
                      'Variants structure: ${firstProduct['variants']}',
                    );
                    final variants = firstProduct['variants'];
                    if (variants is List && variants.isNotEmpty) {
                      final firstVariant = variants[0];
                      if (firstVariant is Map<String, dynamic>) {
                        debugPrint('First variant keys: ${firstVariant.keys}');
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    debugPrint('=== END DEBUG ===');
  }
}
