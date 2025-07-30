import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api.dart';

class UserApiService {
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    
    // For testing purposes, use hardcoded token if none exists
    if (token == null || token.isEmpty) {
      token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2ODY1OTcxN2ZkZThiNWM5OTk0MjYzZTMiLCJwaG9uZV9udW1iZXIiOiIrMTIyMjIyMjIyMjIiLCJpYXQiOjE3NTE0ODgyODAsImV4cCI6MTc1MjA5MzA4MH0.-_P76H6GyJUXfhcsKOwtC2bTu1tSlhc7_J7TPS0IWCk";
      print('🔑 Using test token for authentication');
    }
    return token;
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    
    // For testing purposes, use hardcoded user ID if none exists
    if (userId == null || userId.isEmpty) {
      userId = "68659717fde8b5c9994263e3";
      print('👤 Using test user ID: $userId');
    }
    return userId;
  }

  /// Update user profile and preferences via the updateUser endpoint
  static Future<Map<String, dynamic>?> updateUserProfile({
    String? phoneNumber,
    String? email,
    String? username,
    String? gender,
    int? age,
    int? height,
    String? bodyType,
    String? skinTone,
    List<String>? styles,
    List<String>? occasions,
    List<String>? festivals,
    List<String>? colorTones,
    String? size,
    String? undertone,
    String? avatarUrl,
  }) async {
    try {
      final token = await getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final url = Uri.parse('${webApi['domain']}${endPoint['updateUser']}');
      
      // Prepare the request body matching backend structure
      final body = <String, dynamic>{};
      
      // User fields
      if (phoneNumber != null) body['phone_number'] = phoneNumber;
      if (email != null) body['email'] = email;
      
      // Preference fields - matching backend preference.model.ts exactly
      if (username != null) body['username'] = username;
      if (gender != null) {
        // Convert to lowercase to match GENDER enum (male, female, other)
        body['gender'] = gender.toLowerCase();
      }
      if (age != null) body['age'] = age; // Keep as number, not string
      if (height != null) body['height'] = height; // Keep as number, not string
      if (bodyType != null) {
        // Map frontend body type names to backend BODYTYPE enum values
        body['body_type'] = _mapBodyTypeToBackend(bodyType);
      }
      if (skinTone != null) body['skin_tone'] = skinTone;
      if (styles != null && styles.isNotEmpty) {
        // Keep styles as provided (the backend expects array of strings)
        body['style'] = styles;
      }
      if (occasions != null && occasions.isNotEmpty) {
        body['occasion'] = occasions;
      }
      if (festivals != null && festivals.isNotEmpty) {
        body['festivals'] = festivals;
      }
      if (colorTones != null && colorTones.isNotEmpty) {
        body['color_tones'] = colorTones;
      }
      if (size != null) body['size'] = size;
      if (undertone != null) body['undertone'] = undertone.toLowerCase();
      if (avatarUrl != null) body['avartarURL'] = avatarUrl; // Note: backend uses 'avartarURL' (typo)

      print('🚀 Sending updateUser request to: $url');
      print('📋 Request body: $body');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
        },
        body: body.map((key, value) => MapEntry(key, value.toString())), // Convert all values to strings for form-data
      );

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['data'];
        } else {
          throw Exception(responseData['message'] ?? 'Update failed');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error updating user profile: $e');
      rethrow;
    }
  }

  /// Map frontend body type names to backend BODYTYPE enum values
  static String _mapBodyTypeToBackend(String frontendBodyType) {
    switch (frontendBodyType) {
      case 'Hourglass':
        return 'Hourglass';
      case 'Triangle': // Frontend name for pear
        return 'Triangle';
      case 'Round': // Frontend name for apple
        return 'Round';
      case 'Straight': // Frontend name for rectangle
        return 'Straight'; // Note: backend has typo "STRIGHT" but value is "Straight"
      case 'Inverted Triangle':
        return 'Inverted Triangle';
      case 'Ectomorph':
        return 'Ectomorph';
      case 'Mesomorph':
        return 'Mesomorph';
      case 'Endomorph':
        return 'Endomorph';
      default:
        return frontendBodyType; // Fallback to original value
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  /// Validate phone number (basic validation)
  static bool isValidPhoneNumber(String phone) {
    // Remove all non-digit characters
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    // Check if it's a valid length (10-15 digits)
    return digits.length >= 10 && digits.length <= 15;
  }
}
