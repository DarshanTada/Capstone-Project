import 'package:clothing_app_frontend/http_helper.dart';
import 'package:flutter/material.dart';
import '../model/product_image.dart';
import '../../api.dart';

class ProductImageProvider extends ChangeNotifier {
  List<ProductImage> _images = [];
  bool _isLoading = false;

  List<ProductImage> get images => _images;
  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> fetchProductImages({
    required String query,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['getProductImages']}?$query';
      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
      );
      if (response['success'] == true && response['data'] is List) {
        List<ProductImage> fetchedImages = (response['data'] as List)
            .map((img) => ProductImage.fromJson(Map<String, dynamic>.from(img)))
            .toList();
        _images = fetchedImages;
        notifyListeners();
      }
      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedGetProductImages'};
    }
  }
}
