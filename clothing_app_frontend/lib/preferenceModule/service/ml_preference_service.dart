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
        'analysis_mode': 'ACTUAL_IMAGE_ANALYSIS',
        'instruction': 'ANALYZE THE REAL PERSON IN THE PROVIDED IMAGE - DO NOT USE DEFAULT VALUES',
        'temperature': 0.7, // Add randomness to avoid default responses
        'max_tokens': 500,
        'question': 'Please carefully analyze the ACTUAL PERSON in this image. Look at their face, skin tone, body type, age, and overall appearance. Do NOT use example values. Provide detailed analysis of: gender (from facial features and appearance), estimated age (realistic number based on face), estimated height (based on body proportions), body type (from visible body shape), actual skin tone (from the image), suitable style preferences, and appropriate color palette hex codes that complement their actual skin tone and undertone. Reference the CSV data for accurate color recommendations.',
        'system_prompt': '''You are a professional fashion and style analysis expert. You MUST analyze the ACTUAL PERSON in the provided image.
        CRITICAL INSTRUCTIONS: 
        - LOOK AT THE IMAGE and analyze the real person
        - DO NOT return default/example values
        - PROVIDE realistic estimates based on what you see in the image

        ANALYSIS GUIDELINES:
        - AGE: Look at facial features, skin texture, estimate between 18-65
        - HEIGHT: Estimate from body proportions, typically 150-200cm  
        - SKIN_TONE: Examine actual skin color in the image carefully
        - COLORS: Use CSV data to find colors that match the DETECTED skin tone
        - BODY_TYPE: Analyze visible body shape and proportions

        REQUIRED JSON FORMAT (fill with your actual analysis):
        {
          "gender": "analyze_from_image",
          "age": your_age_estimate_not_25,
          "height": your_height_estimate_not_170,
          "body_type": "your_analysis_of_body_shape",
          "skin_tone": "your_detected_skin_tone",
          "style": ["your_style_recommendations"],
          "color_tones": ["your_color_analysis_not_examples"],
          "undertone": "your_undertone_analysis"
        }

        VALID OPTIONS:
        - gender: male, female, other
        - body_type: hourglass, pear, apple, rectangle, inverted_triangle, ectomorph, mesomorph, endomorph
        - skin_tone: very_fair, fair, medium, olive, brown, deep
        - style: casual, formal, ethnic, party, sports (choose 1-3)
        - undertone: warm, cool, neutral

        🎯 ANALYZE THE REAL PERSON - NOT EXAMPLES!
        Return ONLY valid JSON, no explanations.''',
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
        
        // Check if the response contains default values and warn
        if (responseData.containsKey('response')) {
          final responseText = responseData['response'] as String;
          
          // Check for default values
          if (responseText.contains('"age": 25') || responseText.contains('"height": 170') ||
              responseText.contains('#F4C2C2') || responseText.contains('#E6E6FA') || responseText.contains('#AFDBF5')) {
            print('⚠️ WARNING: ML model returned default values instead of analyzing the image!');
            print('🔍 Response contains: age=25, height=170, or example colors');
            print('📄 Full response: $responseText');
          } else {
            print('✅ ML analysis appears to contain custom values (not defaults)');
          }
        }
        
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
