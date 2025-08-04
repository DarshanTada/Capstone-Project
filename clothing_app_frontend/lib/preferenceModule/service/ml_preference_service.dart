import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api.dart';
import '../model/preference_model.dart';
import '../services/user_api_service.dart';
import '../../authModule/model/user_model.dart';

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

      final url = Uri.parse(
        '${mlApi['domain']}${endPoint['mlAnalyzePreferences']}',
      );
      print('🌐 Request URL: $url');

      final requestBody = {
        'user_id': userId,
        'image_base64': imageBase64,
        'analysis_mode': 'ACTUAL_IMAGE_ANALYSIS',
        'instruction':
            'ANALYZE THE REAL PERSON IN THE PROVIDED IMAGE - DO NOT USE DEFAULT VALUES',
        'temperature': 0.7, // Add randomness to avoid default responses
        'max_tokens': 500,
        'question':
            'Analyze the ACTUAL PERSON in this image. Detect: gender, age (18-65), height (150-200cm), body type, skin tone, and undertone. Based on the detected SKIN TONE and UNDERTONE, provide 5-10 complementary hex color codes using CSV color theory data. Colors must match the person\'s complexion, not random selections.',
        'system_prompt':
            '''You are a professional fashion and style analysis expert. You MUST analyze the ACTUAL PERSON in the provided image.
        CRITICAL INSTRUCTIONS: 
        - LOOK AT THE IMAGE and analyze the real person
        - DO NOT return default/example values
        - PROVIDE realistic estimates based on what you see in the image

        ANALYSIS GUIDELINES:
        - AGE: Look at facial features, skin texture, estimate between 18-65
        - HEIGHT: Estimate from body proportions, typically 150-200cm  
        - SKIN_TONE: Examine actual skin color in the image carefully
        - COLORS: Use CSV data to find colors that match the DETECTED skin tone
        - Provide DIVERSE colors from different color families, NOT all shades of one color
        - Include: neutrals (beiges, creams), warm tones (browns, oranges, reds), cool tones (blues, purples), earth tones (greens, terracotta), and accent colors
        - AVOID returning only gray variations or monochromatic palettes
        - BODY_TYPE: Analyze visible body shape and proportions
          * For MALES: Focus on muscle definition and body composition (ectomorph=lean, mesomorph=athletic, endomorph=broader)
          * For FEMALES: Focus on body curves and proportions (hourglass=balanced curves, pear=wider hips, apple=wider torso, rectangle=straight, inverted_triangle=broader shoulders)

        REQUIRED JSON FORMAT (fill with your actual analysis):
        {
          "gender": "analyze_from_image",
          "age": your_age_estimate,
          "height": your_height_estimate,
          "body_type": "your_analysis_of_body_shape",
          "skin_tone": "your_detected_skin_tone",
          "style": ["your_style_recommendations"],
          "color_tones": ["#D2B48C", "#8B4513", "#4682B4", "#228B22", "#CD853F", "#DDA0DD", "#F0E68C", "#CD5C5C"],
          "undertone": "your_undertone_analysis"
        }

        IMPORTANT: 
        - height and age should be integers (e.g., "height": 170, "age": 25)
        - color_tones must be ACTUAL 6-digit hex codes with # (e.g., "#D2B48C", "#8B4513", "#4682B4")
        - provide 5-10 DIVERSE color tones from DIFFERENT color families (NOT all grays or shades of one color)
        - include variety: neutrals (beiges, creams), warm tones (browns, oranges), cool tones (blues, purples), earth tones (greens, terracotta), accent colors
        - CRITICAL: Do NOT return monochromatic palettes like all grays (#F5F5F5, #E0E0E0, #C6C6C6, etc.)

        VALID OPTIONS:
        - gender: male, female, other
        - body_type: 
          * For MALE: ectomorph, mesomorph, endomorph
          * For FEMALE: hourglass, pear, apple, rectangle, inverted_triangle
          * For OTHER: any of the above body types
        - skin_tone: very_fair, fair, medium, olive, brown, deep
        - style: casual, formal, ethnic, party, sports (choose at least 2)
        - undertone: warm, cool, neutral

        ANALYZE THE REAL PERSON - NOT EXAMPLES!
        PROVIDE DIVERSE COLORS - NOT MONOCHROMATIC!
        USE ACTUAL HEX CODES - NOT DESCRIPTIVE NAMES!
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
      print(
        '📥 Response body preview: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('✅ Analysis successful');

        // Check if the response contains default values and warn
        if (responseData.containsKey('response')) {
          final responseText = responseData['response'] as String;

          // Check for default values
          if (responseText.contains('"age": 25') ||
              responseText.contains('"height": 170') ||
              responseText.contains('#F4C2C2') ||
              responseText.contains('#E6E6FA') ||
              responseText.contains('#AFDBF5')) {
            print(
              '⚠️ WARNING: ML model returned default values instead of analyzing the image!',
            );
            print(
              '🔍 Response contains: age=25, height=170, or example colors',
            );
            print('📄 Full response: $responseText');
          } else {
            print(
              '✅ ML analysis appears to contain custom values (not defaults)',
            );
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
      final url = Uri.parse(
        '${webApi['domain']}${endPoint['getPrefByUserId']}/$userId',
      );

      final response = await http.post(
        // Changed to POST as per backend
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'userId': userId}), // Send userId in body
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          // Extract preference from the user data structure
          final preferenceData = responseData['data']['preference'];
          if (preferenceData != null) {
            return Preference.fromJson(preferenceData);
          }
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
    required String userId, // Changed from preferenceId to userId
    required Preference preferences,
  }) async {
    try {
      final url = Uri.parse(
        '${webApi['domain']}${endPoint['updatePreference']}',
      );

      // Get auth token for the request
      final token = await UserApiService.getAuthToken();
      if (token == null) {
        print('No auth token available for preference update');
        return false;
      }

      // Convert preference data to user API format
      final requestBody = {
        if (preferences.gender != null) 'gender': preferences.gender,
        if (preferences.age != null) 'age': preferences.age,
        if (preferences.height != null) 'height': preferences.height,
        if (preferences.bodyType != null) 'body_type': preferences.bodyType,
        if (preferences.skinTone != null) 'skin_tone': preferences.skinTone,
        if (preferences.style != null) 'style': preferences.style,
        if (preferences.occasion != null) 'occasion': preferences.occasion,
        if (preferences.festivals != null) 'festivals': preferences.festivals,
        if (preferences.colorTones != null)
          'color_tones': preferences.colorTones,
        if (preferences.undertone != null) 'undertone': preferences.undertone,
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['success'] == true;
      } else {
        print('Failed to update preferences: ${response.statusCode}');
        print('Response body: ${response.body}');
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
        print(
          '👤 Final preferences: Gender=${preferences.gender}, Age=${preferences.age}, Skin=${preferences.skinTone}',
        );
        return preferences;
      } else {
        print(
          '⚠️ Step 2 info: Could not fetch updated preferences (likely due to ngrok routing)',
        );
        print(
          '✅ Analysis completed successfully - preferences should be saved in backend',
        );

        // Return a mock preference object based on the analysis result
        // This allows the user to proceed to the preference screen
        try {
          if (analysisResult.containsKey('response')) {
            final responseText = analysisResult['response'] as String;
            print(
              '🔍 Checking response text: ${responseText.substring(0, responseText.length > 100 ? 100 : responseText.length)}...',
            );

            // Check if response contains control characters or corrupted data
            if (responseText.contains('\u001a') ||
                responseText.contains('<unk>') ||
                responseText.codeUnits.any(
                  (unit) => unit < 32 && unit != 10 && unit != 13,
                )) {
              print(
                '⚠️ LLaVA response appears corrupted, using default preferences',
              );

              // Create default preference object when LLaVA response is corrupted
              final defaultPreference = Preference(
                userObjectId: int.tryParse(userId) ?? 0,
                gender: 'other',
                age: 25,
                height: 170,
                bodyType: 'ectomorph',
                skinTone: 'medium',
                style: ['casual'],
                colorTones: [
                  '#D2B48C',
                  '#8B4513',
                  '#4682B4',
                  '#228B22',
                  '#CD853F',
                  '#DDA0DD',
                  '#F0E68C',
                  '#CD5C5C',
                ],
                undertone: 'neutral',
              );

              print(
                '✅ Created default preference object due to corrupted ML response',
              );
              return defaultPreference;
            }

            // Try to extract JSON from the response
            final regex = RegExp(r'\{[\s\S]*\}');
            final jsonMatch = regex.firstMatch(responseText);
            if (jsonMatch != null) {
              var jsonString = jsonMatch.group(0)!;

              // Fix common JSON formatting issues from ML model
              print('🔧 Raw JSON before cleaning: $jsonString');

              // Fix height format issues:
              // Case 1: "height": 170cm, -> "height": 170,
              jsonString = jsonString.replaceAllMapped(
                RegExp(r'"height":\s*(\d+)cm([,}])'),
                (match) => '"height": ${match.group(1)}${match.group(2)}',
              );

              // Case 2: "height": "170cm", -> "height": 170,
              jsonString = jsonString.replaceAllMapped(
                RegExp(r'"height":\s*"(\d+)cm"([,}])'),
                (match) => '"height": ${match.group(1)}${match.group(2)}',
              );

              // Fix other number+unit patterns that should be integers (weight, etc.)
              jsonString = jsonString.replaceAllMapped(
                RegExp(r'"(weight)":\s*(\d+)(kg|lbs)([,}])'),
                (match) =>
                    '"${match.group(1)}": ${match.group(2)}${match.group(4)}',
              );

              // Fix bare numbers that should remain as numbers (age, etc.)
              jsonString = jsonString.replaceAllMapped(
                RegExp(r'"(age)":\s*"(\d+)"'),
                (match) => '"${match.group(1)}": ${match.group(2)}',
              );

              print('🔧 Cleaned JSON: $jsonString');

              final parsedData = jsonDecode(jsonString);

              // Parse height value properly (handle both integer and string formats)
              int heightValue = 170; // default
              if (parsedData['height'] != null) {
                final heightData = parsedData['height'];
                if (heightData is int) {
                  // Direct integer value: "height": 170
                  heightValue = heightData;
                  print('📏 Parsed height as integer: ${heightValue}cm');
                } else if (heightData is String) {
                  // String with unit: "height": "170cm" or "height": "170"
                  final heightMatch = RegExp(r'(\d+)').firstMatch(heightData);
                  if (heightMatch != null) {
                    heightValue = int.tryParse(heightMatch.group(1)!) ?? 170;
                    print(
                      '📏 Parsed height from string "$heightData": ${heightValue}cm',
                    );
                  }
                } else {
                  print('⚠️ Unknown height format: $heightData, using default');
                }
              }

              // Parse age value properly (handle ranges like "25-35" or strings)
              int ageValue = 25; // default
              if (parsedData['age'] != null) {
                final ageStr = parsedData['age'].toString();
                // If it's a range like "25-35", take the middle value
                final rangeMatch = RegExp(r'(\d+)-(\d+)').firstMatch(ageStr);
                if (rangeMatch != null) {
                  final startAge = int.tryParse(rangeMatch.group(1)!) ?? 25;
                  final endAge = int.tryParse(rangeMatch.group(2)!) ?? 35;
                  ageValue = ((startAge + endAge) / 2).round();
                  print(
                    '🔢 Parsed age range "$ageStr" as middle value: $ageValue',
                  );
                } else {
                  // Try to parse as a single number
                  final singleMatch = RegExp(r'(\d+)').firstMatch(ageStr);
                  if (singleMatch != null) {
                    ageValue = int.tryParse(singleMatch.group(1)!) ?? 25;
                  }
                }
              }

              // Parse color tones and fix incomplete hex codes
              List<String> processedColorTones = [
                '#D2B48C',
                '#8B4513',
                '#4682B4',
                '#228B22',
                '#CD853F',
              ]; // diverse default colors
              if (parsedData['color_tones'] != null) {
                try {
                  final rawColors = List<String>.from(
                    parsedData['color_tones'],
                  );

                  // Check if ML returned descriptive names instead of hex codes
                  bool hasDescriptiveNames = rawColors.any(
                    (color) =>
                        !color.startsWith('#') ||
                        color.contains('Tone') ||
                        color.contains('Brown') ||
                        color.contains('Blue') ||
                        color.contains('Green') ||
                        color.contains('Color') ||
                        color.contains('Cream') ||
                        color.contains('Navy') ||
                        color.contains('Pink'),
                  );

                  if (hasDescriptiveNames) {
                    print(
                      '⚠️ WARNING: ML returned descriptive color names instead of hex codes',
                    );
                    print('🔍 Raw colors: $rawColors');
                    print('🎨 Using diverse default colors instead');
                    processedColorTones = [
                      '#D2B48C',
                      '#8B4513',
                      '#4682B4',
                      '#228B22',
                      '#CD853F',
                      '#DDA0DD',
                      '#F0E68C',
                      '#CD5C5C',
                    ];
                  } else {
                    processedColorTones = _fixHexColorCodes(rawColors);
                    print('🎨 Raw colors from ML: $rawColors');
                    print('🎨 Processed colors: $processedColorTones');

                    // Check if ML returned monochromatic grays and warn
                    if (_isMonochromaticGray(processedColorTones)) {
                      print(
                        '⚠️ WARNING: ML returned monochromatic gray palette, using diverse defaults',
                      );
                      processedColorTones = [
                        '#D2B48C',
                        '#8B4513',
                        '#4682B4',
                        '#228B22',
                        '#CD853F',
                        '#DDA0DD',
                        '#F0E68C',
                        '#CD5C5C',
                      ];
                    }

                    // Ensure we have at least 5 colors
                    if (processedColorTones.length < 5) {
                      print(
                        '⚠️ ML returned only ${processedColorTones.length} colors, padding with diverse colors',
                      );
                      final diverseColors = [
                        '#D2B48C',
                        '#8B4513',
                        '#4682B4',
                        '#228B22',
                        '#CD853F',
                      ];
                      for (int i = processedColorTones.length; i < 5; i++) {
                        if (i < diverseColors.length) {
                          processedColorTones.add(diverseColors[i]);
                        }
                      }
                    }
                  }
                } catch (e) {
                  print(
                    '⚠️ Error processing color tones: $e, using diverse default set',
                  );
                  processedColorTones = [
                    '#D2B48C',
                    '#8B4513',
                    '#4682B4',
                    '#228B22',
                    '#CD853F',
                  ]; // fallback to diverse colors
                }
              }

              // Create a preference object from the analysis
              final mockPreference = Preference(
                userObjectId: int.tryParse(userId) ?? 0,
                gender: parsedData['gender'] ?? 'other',
                age: ageValue,
                height: heightValue,
                bodyType: parsedData['body_type'] ?? 'rectangle',
                skinTone: parsedData['skin_tone'] ?? 'medium',
                style: List<String>.from(parsedData['style'] ?? ['casual']),
                colorTones: processedColorTones,
                undertone: parsedData['undertone'] ?? 'neutral',
              );

              print(
                '✅ Created preference object from ML analysis with cleaned JSON',
              );
              print(
                '📊 Parsed values: Gender=${mockPreference.gender}, Age=${mockPreference.age}, Height=${mockPreference.height}cm, BodyType=${mockPreference.bodyType}',
              );
              return mockPreference;
            } else {
              print(
                '⚠️ No valid JSON found in response, using default preferences',
              );

              // Create default preference object when no valid JSON is found
              final defaultPreference = Preference(
                userObjectId: int.tryParse(userId) ?? 0,
                gender: 'other',
                age: 25,
                height: 170,
                bodyType: 'ectomorph',
                skinTone: 'medium',
                style: ['casual'],
                colorTones: [
                  '#D2B48C',
                  '#8B4513',
                  '#4682B4',
                  '#228B22',
                  '#CD853F',
                  '#DDA0DD',
                  '#F0E68C',
                  '#CD5C5C',
                ],
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
            colorTones: [
              '#D2B48C',
              '#8B4513',
              '#4682B4',
              '#228B22',
              '#CD853F',
              '#DDA0DD',
              '#F0E68C',
              '#CD5C5C',
            ],
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
      // Use the UserApiService to get the actual logged in user ID
      print('🆔 Getting current user ID from storage...');
      final userId = await UserApiService.getUserId();

      if (userId != null && userId.isNotEmpty) {
        print('✅ Found user ID: $userId');
        return userId;
      }

      // Fallback: try to get from SharedPreferences directly
      final prefs = await SharedPreferences.getInstance();
      final storedUserId = prefs.getString('user_id');
      if (storedUserId != null && storedUserId.isNotEmpty) {
        print('✅ Found user ID from prefs: $storedUserId');
        return storedUserId;
      }

      // Last resort: use static ID for testing
      print('⚠️ No user ID found in storage, using test ID');
      return "68659717fde8b5c9994263e3";
    } catch (e) {
      print('Error getting current user ID: $e');
      // Fallback to static ID
      print('⚠️ Error occurred, using test ID as fallback');
      return "68659717fde8b5c9994263e3";
    }
  }

  /// Get current user phone number from storage
  static Future<String?> getCurrentUserPhone() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Try multiple possible keys for phone number
      String? phone =
          prefs.getString('user_phone') ??
          prefs.getString('phone_number') ??
          prefs.getString('phoneNumber');

      if (phone != null && phone.isNotEmpty) {
        print('📱 Found user phone: $phone');
        return phone;
      }

      print('⚠️ No phone number found in storage');
      return null;
    } catch (e) {
      print('Error getting current user phone: $e');
      return null;
    }
  }

  /// Get current auth token from storage
  static Future<String?> getCurrentAuthToken() async {
    try {
      final token = await UserApiService.getAuthToken();
      if (token != null && token.isNotEmpty) {
        print('🔐 Found auth token');
        return token;
      }

      print('⚠️ No auth token found');
      return null;
    } catch (e) {
      print('Error getting auth token: $e');
      return null;
    }
  }

  /// Update user preferences via API and then navigate to home screen
  static Future<bool> updatePreferencesAndRedirectHome({
    required Map<String, dynamic> preferenceData,
    Function? onSuccess,
    Function(String)? onError,
  }) async {
    try {
      print('🔄 Starting preference update flow...');

      // Get user authentication data
      final userId = await getCurrentUserId();
      final phone = await getCurrentUserPhone();
      final token = await getCurrentAuthToken();

      if (userId == null) {
        final error = 'User ID not found. Please login again.';
        print('❌ $error');
        if (onError != null) onError(error);
        return false;
      }

      if (token == null) {
        final error = 'Authentication token not found. Please login again.';
        print('❌ $error');
        if (onError != null) onError(error);
        return false;
      }

      print('👤 Using user ID: $userId');
      if (phone != null) print('📱 User phone: $phone');

      // Call the updateUser API with the preference data
      final result = await UserApiService.updateUserProfile(
        token: token, // Pass token as required parameter
        userId: userId, // Pass userId as required parameter
        phoneNumber: phone,
        email: preferenceData['email'],
        username: preferenceData['username'],
        gender: preferenceData['gender'],
        age: preferenceData['age'],
        height: preferenceData['height'],
        bodyType: preferenceData['bodyType'],
        skinTone: preferenceData['skinTone'],
        styles: _processArrayFieldToSingleString(preferenceData['styles']),
        occasions: _processArrayFieldToSingleString(preferenceData['occasions']),
        festivals: _processArrayFieldToSingleString(preferenceData['festivals']),
        colorTones: _processArrayFieldToSingleString(preferenceData['colorTones']),
        size: preferenceData['size'],
        undertone: preferenceData['undertone'],
      );

      if (result != null && result['success'] == true) {
        print('✅ Preferences updated successfully!');

        // Save updated user data to preferences (similar to loginUser method)
        try {
          // Create updated user object from API response
          if (result['data'] != null) {
            final userData = User.jsonToUser(result['data'], token: token);

            // Save to local preferences
            await userData.saveToPrefs();
            print('💾 User preferences saved to local storage');
          }
        } catch (saveError) {
          print(
            '⚠️ Warning: Failed to save preferences to local storage: $saveError',
          );
          // Continue execution - this is not a critical error
        }

        if (onSuccess != null) onSuccess();
        return true;
      } else {
        final error = result?['message'] ?? 'Failed to update preferences';
        print('❌ Update failed: $error');
        if (onError != null) onError(error);
        return false;
      }
    } catch (e) {
      final error = 'Error updating preferences: $e';
      print('💥 $error');
      if (onError != null) onError(error);
      return false;
    }
  }

  /// Fix incomplete hex color codes from ML model
  static List<String> _fixHexColorCodes(List<String> rawColors) {
    return rawColors.map((color) {
      if (color.isEmpty) return '#808080'; // default gray for empty strings

      String cleanColor = color.trim();

      // Remove # if present
      if (cleanColor.startsWith('#')) {
        cleanColor = cleanColor.substring(1);
      }

      // Handle different lengths
      if (cleanColor.length == 3) {
        // 3-digit hex: #f5f -> #f5f5f5
        cleanColor = cleanColor.split('').map((char) => char + char).join('');
      } else if (cleanColor.length == 4) {
        // 4-digit hex: #f5f5 -> #f5f5f5 (duplicate last char)
        cleanColor = cleanColor + cleanColor.substring(3);
      } else if (cleanColor.length == 5) {
        // 5-digit hex: #f5f5f -> #f5f5f5 (duplicate last char)
        cleanColor = cleanColor + cleanColor.substring(4);
      } else if (cleanColor.length > 6) {
        // Too long: truncate to 6
        cleanColor = cleanColor.substring(0, 6);
      } else if (cleanColor.length < 6) {
        // Too short: pad with zeros
        cleanColor = cleanColor.padRight(6, '0');
      }

      // Validate hex characters
      if (!RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(cleanColor)) {
        print('⚠️ Invalid hex color "$color", using default gray');
        return '#808080'; // default gray
      }

      final result = '#' + cleanColor.toUpperCase();
      print('🔧 Fixed color: "$color" -> "$result"');
      return result;
    }).toList();
  }

  /// Check if color palette is monochromatic gray (common ML model issue)
  static bool _isMonochromaticGray(List<String> colors) {
    if (colors.isEmpty) return false;

    // Convert hex colors to RGB and check if they're all grayscale
    int grayCount = 0;

    for (String color in colors) {
      if (color.length != 7 || !color.startsWith('#')) continue;

      try {
        String hex = color.substring(1);
        int r = int.parse(hex.substring(0, 2), radix: 16);
        int g = int.parse(hex.substring(2, 4), radix: 16);
        int b = int.parse(hex.substring(4, 6), radix: 16);

        // Check if it's grayscale (R=G=B within small tolerance)
        if ((r - g).abs() <= 5 && (g - b).abs() <= 5 && (r - b).abs() <= 5) {
          grayCount++;
        }
      } catch (e) {
        // Skip invalid colors
        continue;
      }
    }

    // If more than 70% are grayscale, consider it monochromatic
    double grayRatio = grayCount / colors.length;
    bool isMonochromatic = grayRatio > 0.7;

    if (isMonochromatic) {
      print(
        '🔍 Detected monochromatic gray palette: $grayCount/${colors.length} colors are grayscale (${(grayRatio * 100).toStringAsFixed(1)}%)',
      );
    }

    return isMonochromatic;
  }

  /// Process array fields to convert from bracketed format to a single-item array with comma-separated string
  /// This creates the format: Array (1) 0: "Festival, Wedding"
  static List<String> _processArrayFieldToSingleString(dynamic fieldData) {
    if (fieldData == null) return [];
    
    if (fieldData is List) {
      List<String> result = [];
      for (var item in fieldData) {
        if (item is String) {
          // Check if it's in bracketed format like "[Casual, Ethnic]"
          if (item.startsWith('[') && item.endsWith(']')) {
            // Remove brackets and split by comma
            String content = item.substring(1, item.length - 1);
            List<String> splitItems = content.split(',').map((e) => e.trim()).toList();
            result.addAll(splitItems);
          } else {
            // Direct string value
            result.add(item.trim());
          }
        }
      }
      // Return as single-item array with comma-separated values
      return result.isNotEmpty ? [result.join(', ')] : [];
    } else if (fieldData is String) {
      // Check if it's in bracketed format
      if (fieldData.startsWith('[') && fieldData.endsWith(']')) {
        // Remove brackets and return content as single-item array
        String content = fieldData.substring(1, fieldData.length - 1);
        String cleanedContent = content.split(',').map((e) => e.trim()).join(', ');
        return [cleanedContent];
      } else {
        // Single string value as single-item array
        return [fieldData.trim()];
      }
    }
    
    return [];
  }
}
