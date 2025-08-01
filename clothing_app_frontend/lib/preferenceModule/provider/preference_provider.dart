import '../../http_helper.dart';
import '../model/preference_model.dart';
import 'package:flutter/material.dart';
// import 'package:localstorage/localstorage.dart';
import '../../api.dart';

class PreferenceProvider with ChangeNotifier {
  late Preference preference;

  Map get selectedLanguage => {
    // Preference
    "welcomeTo": "Welcome to",
    "signIn": "Sign In",
    "yourStyleYourWay": "Your Style, Your Way",
    "phoneNumber": "000-000-0000",
    "otpVerification": "OTP Verification",
  };

  //Get all preference
  Future<Map<String, dynamic>> getAllPreferences(BuildContext context) async {
    final String url = '${webApi['domain']}${endPoint['getAllPreferences']}';

    try {
      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
      );

      final responseData = response.body;

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {'status': true, 'data': responseData['data']};
      } else {
        return {
          'status': false,
          'message': responseData['message'] ?? 'Fetch failed',
        };
      }
    } catch (e) {
      // Log error instead of showing SnackBar to avoid widget tree issues
      print('Error in getAllPreferences: $e');
      return {'status': false, 'message': 'Unexpected error occurred'};
    }
  }

  // Get preference by User Id
  Future<Map<String, dynamic>> getPreferencesByUserId(
    BuildContext context,
    String userId,
  ) async {
    final String url = '${webApi['domain']}${endPoint['getPrefByUserId']}/$userId';

    try {
      final response = await RemoteServices.httpRequest(
        method: 'POST',  // Changed to POST as per backend API
        url: url,
        body: {'userId': userId},  // Send userId in body
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = response.body;

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Extract preference from user data structure
        final data = responseData['data'];
        if (data != null && data['preference'] != null) {
          return {'status': true, 'data': data['preference']};
        } else {
          return {'status': false, 'message': 'No preferences found'};
        }
      } else {
        return {
          'status': false,
          'message': responseData['message'] ?? 'No preferences found',
        };
      }
    } catch (error) {
      // Log error instead of showing SnackBar to avoid widget tree issues
      print('Error in getPreferencesByUserId: $error');
      return {'status': false, 'message': 'Unexpected error occurred'};
    }
  }

  //Update preference
  Future<Map<String, dynamic>> updatePreference({
    required BuildContext context,
    required String id,  // This is now userId instead of preferenceId
    required Map<String, dynamic> data,
  }) async {
    final String url = '${webApi['domain']}${endPoint['updatePreference']}';  // Removed /$id

    try {
      final response = await RemoteServices.httpRequest(
        method: 'PUT',
        url: url,
        body: data,
        // Note: Add token handling if needed through SharedPreferences or UserApiService
      );

      final responseData = response.body;

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Extract preference from updated user data structure
        final updatedData = responseData['data'];
        if (updatedData != null && updatedData['preference'] != null) {
          return {'status': true, 'data': updatedData['preference']};
        } else {
          return {'status': true, 'data': updatedData};
        }
      } else {
        return {
          'status': false,
          'message': responseData['message'] ?? 'Update failed',
        };
      }
    } catch (e) {
      // Log error instead of showing SnackBar to avoid widget tree issues
      print('Error in updatePreference: $e');
      return {'status': false, 'message': 'Unexpected error occurred'};
    }
  }

  //Delete preference
  Future<Map<String, dynamic>> deletePreference({
    required BuildContext context,
    required String id,
  }) async {
    final String url = '${webApi['domain']}${endPoint['deletePreference']}/$id';

    try {
      final response = await RemoteServices.httpRequest(
        method: 'DELETE',
        url: url,
      );

      final responseData = response.body;

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {'status': true, 'message': responseData['message']};
      } else {
        return {
          'status': false,
          'message': responseData['message'] ?? 'Delete failed',
        };
      }
    } catch (e) {
      // Log error instead of showing SnackBar to avoid widget tree issues
      print('Error in deletePreference: $e');
      return {'status': false, 'message': 'Unexpected error occurred'};
    }
  }
}
