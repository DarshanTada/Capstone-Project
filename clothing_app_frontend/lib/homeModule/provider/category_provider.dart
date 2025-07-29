import 'package:clothing_app_frontend/api.dart';
import 'package:clothing_app_frontend/homeModule/model/category_model.dart';
import 'package:clothing_app_frontend/http_helper.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  // List<Cafe> _likedCafes = [];

  // List<Cafe> get likedCafes => [..._likedCafes];
  // Cafe? selectedCafe;

  // selectCafe(Cafe cafe) {
  //   selectedCafe = cafe;
  //   notifyListeners();
  // }

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
    } catch (error, stackTrace) {
      return {'success': false, 'message': 'failedGetCategories'};
    }
  }

  // likeUnlike({required Map body, required String accessToken}) async {
  //   try {
  //     final url = '${webApi['domain']}${endPoint['likeUnlike']}';
  //     final response = await RemoteServices.httpRequest(
  //       method: 'POST',
  //       url: url,
  //       body: body,
  //       accessToken: accessToken,
  //     );
  //     if (response['success']) {
  //       if (body['like'] == false) {
  //         int i =
  //             _likedCafes.indexWhere((element) => element.id == body['cafe']);
  //         if (i != -1) {
  //           _likedCafes.removeAt(i);
  //         }
  //         int j = _cafes.indexWhere((element) => element.id == body['cafe']);
  //         if (j != -1) {
  //           _cafes[j].isLiked = body['like'];
  //         }
  //       }
  //     }
  //     notifyListeners();
  //     return response;
  //   } catch (e) {
  //     return {
  //       'success': false,
  //     };
  //   }
  // }
}
