import 'package:clothing_app_frontend/http_helper.dart';
import 'package:flutter/material.dart';
import '../model/subcategory.dart';
import '../../api.dart';

class SubCategoryProvider extends ChangeNotifier {
  List<SubCategory> _subCategories = [];
  final bool _isLoading = false;

  List<SubCategory> get subCategories => _subCategories;
  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> fetchSubCategories({
    required String query,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['getSubCategories']}?$query';
      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
      );
      if (response['success'] == true && response['data'] is List) {
        List<SubCategory> fetchedSubCategories = (response['data'] as List)
            .map(
              (subcat) =>
                  SubCategory.fromJson(Map<String, dynamic>.from(subcat)),
            )
            .toList();
        _subCategories = fetchedSubCategories;
        notifyListeners();
      }
      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedGetSubCategories'};
    }
  }
}
