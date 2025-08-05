import 'package:clothing_app_frontend/http_helper.dart';
import 'package:flutter/material.dart';
import '../../api.dart';

class HomeProvider extends ChangeNotifier {
  List _homeData = [];
  bool _isLoading = false;

  List get homeData => _homeData;
  bool get isLoading => _isLoading;



 

  

  Future<Map<String, dynamic>> fetchHomeData() async {
    try {
      _isLoading = true;
      final url = '${webApi['domain']}${endPoint['getHomeData']}';
      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
      );
      
      if (response['success'] == true && response['data'] is List) {
        
        _homeData = response['data'];
        notifyListeners();
      }
      _isLoading = false;
      return response;
    } catch (error) {
      _isLoading = false;
      return {'success': false, 'message': 'failedGetHomeData'};
    }
  }


}
