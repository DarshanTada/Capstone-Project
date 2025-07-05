import 'dart:io';
import 'dart:convert';
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      return {'status': false, 'message': 'Unexpected error occurred'};
    }
  }

  // Get preference by User Id
  Future<Map<String, dynamic>> getPreferencesByUserId(
    BuildContext context,
    String userId,
  ) async {
    final String url =
        '${webApi['domain']}${endPoint['getPrefByUserId']}/$userId';

    try {
      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = response.body;

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {'status': true, 'data': responseData['data']};
      } else {
        return {
          'status': false,
          'message': responseData['message'] ?? 'No preferences found',
        };
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error')));
      return {'status': false, 'message': 'Unexpected error occurred'};
    }
  }

  //Update preference
  Future<Map<String, dynamic>> updatePreference({
    required BuildContext context,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final String url = '${webApi['domain']}${endPoint['updatePreference']}/$id';

    try {
      final response = await RemoteServices.httpRequest(
        method: 'PUT',
        url: url,
        body: data,
      );

      final responseData = response.body;

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {'status': true, 'data': responseData['data']};
      } else {
        return {
          'status': false,
          'message': responseData['message'] ?? 'Update failed',
        };
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      return {'status': false, 'message': 'Unexpected error occurred'};
    }
  }
}
