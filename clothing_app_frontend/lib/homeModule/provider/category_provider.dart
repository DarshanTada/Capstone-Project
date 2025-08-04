import 'package:clothing_app_frontend/api.dart';
import 'package:clothing_app_frontend/homeModule/model/category_model.dart';
import 'package:clothing_app_frontend/http_helper.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  List<dynamic> _categoryProducts = [];
  bool _isLoadingProducts = false;

  List<Category> get categories => _categories;
  List<dynamic> get categoryProducts => _categoryProducts;
  bool get isLoadingProducts => _isLoadingProducts;

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
      final url = '${webApi['domain']}${endPoint['getProductsByCategory']}';
      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: {'bodyType': bodyType, 'gender': gender},
      );

      if (response['success'] == true && response['data'] is List) {
        _categoryProducts = response['data'];
        notifyListeners();
      }

      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedGetHomeData'};
    }
  }
}
