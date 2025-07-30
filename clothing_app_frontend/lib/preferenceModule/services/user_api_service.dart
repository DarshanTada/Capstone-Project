import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api.dart';

class UserApiService {
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
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
      
      // Preference fields
      if (username != null) body['username'] = username;
      if (gender != null) body['gender'] = gender.toLowerCase(); // Convert to lowercase for backend
      if (age != null) body['age'] = age.toString();
      if (height != null) body['height'] = height.toString();
      if (bodyType != null) body['body_type'] = bodyType;
      if (skinTone != null) body['skin_tone'] = skinTone;
      if (styles != null && styles.isNotEmpty) {
        // Convert styles to lowercase for backend
        body['style'] = styles.map((s) => s.toLowerCase()).toList();
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
      if (avatarUrl != null) body['avartarURL'] = avatarUrl;

      print('🚀 Sending updateUser request to: $url');
      print('📋 Request body: $body');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
        },
        body: body,
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
