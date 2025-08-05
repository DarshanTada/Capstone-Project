import 'package:clothing_app_frontend/http_helper.dart';
import 'package:flutter/material.dart';
import '../../api.dart';

class ProductDetailProvider extends ChangeNotifier {
  List<dynamic> _rawProductDetails = [];
  bool _isLoading = false;

  List<dynamic> get rawProductDetails => _rawProductDetails;
  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> fetchProductDetails({
    required String productId,
  }) async {
    try {
      _isLoading = true;

      final url =
          '${webApi['domain']}${endPoint['getProductDetail']}/$productId';
      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
      );

      if (response['success'] == true) {
        _rawProductDetails = [
          response,
        ]; // Store the entire response including data key
      } else {
        _rawProductDetails = []; // Clear raw data on failure
      }

      _isLoading = false;
      notifyListeners();
      return response;
    } catch (error) {
      _isLoading = false; // Reset loading state on error
      _rawProductDetails = []; // Clear raw data on error
      notifyListeners(); // Notify UI about the error state
      return {'success': false, 'message': 'failedGetProductDetails'};
    }
  }
}
