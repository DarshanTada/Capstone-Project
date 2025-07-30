import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../api.dart';
// import '../../storage_manager.dart'; // TODO: Uncomment when login flow is implemented
import '../model/preference_model.dart';

class MLPreferenceService {
  
  /// Analyze user preferences from base64 image
  static Future<Map<String, dynamic>?> analyzeUserPreferences({
    required String userId,
    required String imageBase64,
  }) async {
    try {
      print('🔄 Starting ML analysis for user: $userId');
      print('📱 Image size: ${imageBase64.length} characters');
      
      final url = Uri.parse('${mlApi['domain']}${endPoint['mlAnalyzePreferences']}');
      print('🌐 Request URL: $url');
      
      final requestBody = {
        'user_id': userId,
        'image_base64': imageBase64,
      };
      
      print('📤 Sending request to backend...');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode(requestBody),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body preview: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('✅ Analysis successful');
        return responseData;
      } else {
        print('❌ Failed to analyze preferences: ${response.statusCode}');
        print('📄 Full response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('💥 Error analyzing user preferences: $e');
      return null;
    }
  }

  /// Get user preferences by user ID
  static Future<Preference?> getUserPreferences(String userId) async {
    try {
      final url = Uri.parse('${webApi['domain']}${endPoint['getPrefByUserId']}/$userId');
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'].isNotEmpty) {
          return Preference.fromJson(responseData['data'][0]);
        }
      } else {
        print('Failed to get preferences: ${response.statusCode}');
      }
      return null;
    } catch (e) {
      print('Error getting user preferences: $e');
      return null;
    }
  }

  /// Update user preferences
  static Future<bool> updateUserPreferences({
    required String preferenceId,
    required Preference preferences,
  }) async {
    try {
      final url = Uri.parse('${webApi['domain']}${endPoint['updatePreference']}/$preferenceId');
      
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(preferences.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update preferences: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating user preferences: $e');
      return false;
    }
  }

  /// Complete flow: Analyze image and get/update preferences
  static Future<Preference?> analyzeAndGetPreferences({
    required String userId,
    required String imageBase64,
  }) async {
    try {
      print('🚀 Starting complete preference analysis flow...');
      
      // Step 1: Analyze the image to extract preferences
      print('📸 Step 1: Analyzing user image...');
      final analysisResult = await analyzeUserPreferences(
        userId: userId,
        imageBase64: imageBase64,
      );

      if (analysisResult == null) {
        print('❌ Step 1 failed: Could not analyze image');
        return null;
      }

      print('✅ Step 1 completed: Analysis successful');
      print('📊 Analysis result: $analysisResult');

      // Wait a moment for the backend to process and save
      print('⏳ Waiting for backend processing...');
      await Future.delayed(Duration(seconds: 2));

      // Step 2: Get the updated preferences from the database
      print('📥 Step 2: Fetching updated preferences...');
      final preferences = await getUserPreferences(userId);
      
      if (preferences != null) {
        print('✅ Step 2 completed: Preferences fetched successfully');
        print('👤 Final preferences: Gender=${preferences.gender}, Age=${preferences.age}, Skin=${preferences.skinTone}');
        return preferences;
      } else {
        print('❌ Step 2 failed: Could not fetch updated preferences');
        return null;
      }
    } catch (e) {
      print('💥 Error in complete preference analysis flow: $e');
      return null;
    }
  }

  /// Get current user ID from storage
  static Future<String?> getCurrentUserId() async {
    try {
      // For testing purposes, use static user ID since login flow isn't set up
      print('🆔 Using static user ID for testing');
      return "68659717fde8b5c9994263e3";
      
      // TODO: Uncomment this when login flow is implemented
      /*
      final userData = await StorageManager.readData('userData');
      if (userData != null) {
        final userMap = jsonDecode(userData);
        return userMap['_id'] ?? userMap['id'];
      }
      return null;
      */
    } catch (e) {
      print('Error getting current user ID: $e');
      // Fallback to static ID
      return "68659717fde8b5c9994263e3";
    }
  }
}
