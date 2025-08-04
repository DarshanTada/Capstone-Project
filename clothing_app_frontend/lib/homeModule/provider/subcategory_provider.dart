import 'package:clothing_app_frontend/http_helper.dart';
import 'package:flutter/material.dart';
import '../../api.dart';

class SubCategoryProvider extends ChangeNotifier {
  List<dynamic> _rawSubCategories = []; // Store only raw API response
  bool _isLoading = false;

  List<dynamic> get rawSubCategories => _rawSubCategories; // Getter for raw data
  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> fetchAllSubCategories() async {
    try {
      _isLoading = true;
      notifyListeners();

      final url = '${webApi['domain']}${endPoint['getAllSubCategories']}';
      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
      );

      if (response['success'] == true && response['data'] is List) {
        _rawSubCategories = response['data'] as List; // Store only raw data
        
        // Debug print to see the raw data structure
        print('Raw subcategories data: $_rawSubCategories');
      } else {
        _rawSubCategories = []; // Clear raw data on failure
      }

      _isLoading = false;
      notifyListeners();
      return response;
    } catch (error) {
      _isLoading = false;
      _rawSubCategories = []; // Clear raw data on error
      notifyListeners();
      print('Error fetching subcategories: $error');
      return {'success': false, 'message': 'failedGetSubCategories'};
    }
  }
}
