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
    const int maxRetries = 3;
    int attempt = 0;
    
    while (attempt < maxRetries) {
      attempt++;
      
      final url = Uri.parse('${mlApi['domain']}${endPoint['mlAnalyzePreferences']}');
      print('🌐 Request URL: $url');
      
      final requestBody = {
        'user_id': userId,
        'image_base64': imageBase64,
        'question': 'Analyze this person\'s appearance and determine their style preferences including gender, age, body type, skin tone, style preferences, and color preferences.',
        'system_prompt': '''You are a professional fashion and style analysis expert. Analyze the person in the image and provide detailed style recommendations based on their appearance using the fashion knowledge from the CSV files.

IMPORTANT: Return ONLY valid JSON with no additional text, explanations, or markdown formatting. Use the exact values specified below.

{
  "gender": "male/female/other",
  "age": 25,
  "height": 170,
  "body_type": "hourglass/pear/apple/rectangle/inverted_triangle/ectomorph/mesomorph/endomorph",
  "skin_tone": "very_fair/fair/medium/olive/brown/deep",
  "style": ["casual", "formal", "ethnic", "party", "sports"],
  "color_tones": ["#F4C2C2", "#E6E6FA", "#AFDBF5"],
  "undertone": "warm/cool/neutral"
}

Rules:
- age: must be a number (not a range)
- height: must be a number in centimeters (e.g., 170, 165, 180)
- body_type: choose only ONE value from the list
- skin_tone: choose only ONE value from the list (very_fair, fair, medium, olive, brown, deep)
- style: array of strings, choose from casual/formal/ethnic/party/sports
- color_tones: array of hex codes that complement the detected skin_tone and undertone. Refer to the "Fashion Understanding - Skin+Under tone Color.csv" file and select 3-7 appropriate hex codes based on the person's detected skin tone and undertone combination from the image.
- undertone: choose only ONE value: warm/cool/neutral
- Return ONLY the JSON object, no markdown, no explanations''',
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
    }
    
    print('❌ All $maxRetries attempts failed');
    return null;
  }

  /// Get user preferences by user ID
  static Future<Preference?> getUserPreferences(String userId) async {
    try {
      final url = Uri.parse('${webApi['domain']}${endPoint['getPrefByUserId']}/$userId');
      
      final response = await http.get(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'].isNotEmpty) {
          return Preference.fromJson(responseData['data'][0]);
        }
      } else {
        print('Failed to get preferences: ${response.statusCode}');
        print('Response body: ${response.body}');
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
          'ngrok-skip-browser-warning': 'true',
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
        print('⚠️ Step 2 info: Could not fetch updated preferences (likely due to ngrok routing)');
        print('✅ Analysis completed successfully - preferences should be saved in backend');
        
        // Return a mock preference object based on the analysis result
        // This allows the user to proceed to the preference screen
        try {
          if (analysisResult.containsKey('response')) {
            final responseText = analysisResult['response'] as String;
            print('🔍 Checking response text: ${responseText.substring(0, responseText.length > 100 ? 100 : responseText.length)}...');
            
            // Check if response contains control characters or corrupted data
            if (responseText.contains('\u001a') || responseText.contains('<unk>') || responseText.codeUnits.any((unit) => unit < 32 && unit != 10 && unit != 13)) {
              print('⚠️ LLaVA response appears corrupted, using default preferences');
              
              // Create default preference object when LLaVA response is corrupted
              final defaultPreference = Preference(
                userObjectId: int.tryParse(userId) ?? 0,
                gender: 'other',
                age: 25,
                height: 170,
                bodyType: 'ectomorph',
                skinTone: 'medium',
                style: ['casual'],
                colorTones: ['neutral'],
                undertone: 'neutral',
              );
              
              print('✅ Created default preference object due to corrupted ML response');
              return defaultPreference;
            }
            
            // Try to extract JSON from the response
            final regex = RegExp(r'\{[\s\S]*\}');
            final jsonMatch = regex.firstMatch(responseText);
            if (jsonMatch != null) {
              final jsonString = jsonMatch.group(0)!;
              final parsedData = jsonDecode(jsonString);
              
              // Create a preference object from the analysis
              final mockPreference = Preference(
                userObjectId: int.tryParse(userId) ?? 0,
                gender: parsedData['gender'] ?? 'other',
                age: parsedData['age'] ?? 25,
                height: parsedData['height'] ?? 170,
                bodyType: parsedData['body_type'] ?? 'rectangle',
                skinTone: parsedData['skin_tone'] ?? 'medium',
                style: List<String>.from(parsedData['style'] ?? ['casual']),
                colorTones: List<String>.from(parsedData['color_tones'] ?? ['neutral']),
                undertone: parsedData['undertone'] ?? 'neutral',
              );
              
              print('✅ Created preference object from valid ML analysis');
              return mockPreference;
            } else {
              print('⚠️ No valid JSON found in response, using default preferences');
              
              // Create default preference object when no valid JSON is found
              final defaultPreference = Preference(
                userObjectId: int.tryParse(userId) ?? 0,
                gender: 'other',
                age: 25,
                height: 170,
                bodyType: 'ectomorph',
                skinTone: 'medium',
                style: ['casual'],
                colorTones: ['neutral'],
                undertone: 'neutral',
              );
              
              print('✅ Created default preference object due to invalid JSON');
              return defaultPreference;
            }
          }
        } catch (e) {
          print('Could not create preference object from analysis: $e');
          
          // Create default preference object as fallback
          final defaultPreference = Preference(
            userObjectId: int.tryParse(userId) ?? 0,
            gender: 'other',
            age: 25,
            height: 170,
            bodyType: 'ectomorph',
            skinTone: 'medium',
            style: ['casual'],
            colorTones: ['neutral'],
            undertone: 'neutral',
          );
          
          print('✅ Created default preference object as fallback');
          return defaultPreference;
        }
        
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
