import 'package:clothing_app_frontend/http_helper.dart';
import 'package:flutter/material.dart';
import '../model/product.dart';
import '../../api.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;



 

  

  Future<Map<String, dynamic>> fetchProducts({required String query}) async {
    try {
      final url = '${webApi['domain']}${endPoint['getProducts']}?$query';
      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
      );
      if (response['success'] == true && response['data'] is List) {
        List<Product> fetchedProducts = (response['data'] as List)
            .map(
              (product) => Product.fromJson(Map<String, dynamic>.from(product)),
            )
            .toList();
        _products = fetchedProducts;
        notifyListeners();
      }
      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedGetProducts'};
    }
  }
}
