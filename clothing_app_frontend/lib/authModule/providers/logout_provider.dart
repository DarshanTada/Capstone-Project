import 'package:flutter/material.dart';
import '../../http_helper.dart';
import '../../api.dart';
import 'auth_service_firebase.dart';

class LogoutProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// Logout user from both backend API and Firebase
  Future<Map<String, dynamic>> logoutUser({
    required BuildContext context,
    required String token,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Step 1: Call logout API to clear token from backend
      final String url = '${webApi['domain']}${endPoint['logout']}';

      print('Making logout request to: $url');

      final responseData = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        accessToken: token,
      );

      print('Logout API Response: $responseData');

      // Check if API logout was successful
      if (responseData['success'] == true) {
        // Step 2: Logout from Firebase and clear local data
        AuthRepo.logoutApp(context);

        _isLoading = false;
        notifyListeners();

        return {'status': true, 'message': 'Logout successful'};
      } else {
        // API logout failed, but still proceed with local logout
        print('API logout failed, proceeding with local logout');
        _isLoading = false;
        notifyListeners();

        return {
          'status': false,
          'message': responseData['message'] ?? 'Logout completed locally',
        };
      }
    } catch (error) {
      print('Logout error: $error');

      // Even if API call fails, logout locally
      try {
      } catch (localError) {
        print('Local logout error: $localError');
      }

      _isLoading = false;
      notifyListeners();

      return {
        'status': false,
        'message': 'Logout completed despite error: $error',
      };
    }
  }

  /// Quick logout without API call (for emergency situations)
  Future<void> forceLogout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      AuthRepo.logoutApp(context);
    } catch (error) {
      print('Force logout error: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
