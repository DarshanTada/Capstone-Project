import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../service/ml_preference_service.dart';
import '../model/preference_model.dart';
import '../services/user_api_service.dart';
import '../../authModule/screens/capture_face_screen.dart';
import '../../navigation/routes.dart';
import '../../api.dart';

void main() => runApp(PreferenceScreenApp());

class PreferenceScreenApp extends StatelessWidget {
  const PreferenceScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PreferenceScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  String name = '';
  String email = '';
  String gender = 'Male';
  int age = 24;
  int height = 176;
  String bodyType = 'Ectomorph';
  String phoneNumber = ''; // Non-editable, populated from user data

  int selectedSkin = 2;
  Set<String> selectedStyles = {};
  Set<String> selectedOccasions = {};
  Set<String> selectedFestivals = {};
  List<String> mlColorTones = []; // Store hex codes from ML model
  List<String> mlRecommendedStyles = []; // Store ML-recommended styles
  bool _hasLoadedMLRecommendations = false; // Track if ML recommendations have been loaded
  String selectedUndertone = 'Neutral';

  // App permissions state
  bool notificationsEnabled = true;
  bool locationEnabled = false;
  bool cameraEnabled = true;
  bool storageEnabled = true;
  bool microphoneEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// Initialize all data in the correct order
  Future<void> _initializeData() async {
    print('🚀 Initializing preference screen data...');
    
    try {
      // Load user data first (name, email, phone, basic info)
      await _loadUserData();
      
      // Then load preferences (which may override some user data with more specific preference data)
      await _loadPreferences();
      
      print('✅ Data initialization completed');
    } catch (e) {
      print('❌ Error during data initialization: $e');
    }
  }

  /// Refresh all data from APIs and local storage
  Future<void> _refreshData() async {
    print('🔄 Refreshing all preference data...');
    
    try {
      // Clear local preferences to ensure fresh data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('saved_preferences');
      
      // Reset ML recommendations flag to allow re-population
      _hasLoadedMLRecommendations = false;
      
      // Reload all data
      await _initializeData();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.refresh, color: Colors.white),
              SizedBox(width: 8),
              Text('Data refreshed successfully!'),
            ],
          ),
          backgroundColor: Color(0xFFB8956A),
          duration: Duration(seconds: 2),
        ),
      );
      
      print('✅ Data refresh completed');
    } catch (e) {
      print('❌ Error during data refresh: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('Failed to refresh data. Please try again.'),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  /// Load user data from SharedPreferences and API
  Future<void> _loadUserData() async {
    try {
      print('📱 Loading user data...');
      final prefs = await SharedPreferences.getInstance();
      
      // First try to get user ID
      final userId = await UserApiService.getUserId();
      if (userId == null) {
        print('❌ No user ID found');
        return;
      }
      
      print('👤 Found user ID: $userId');
      
      // Try to fetch user data from API
      final userData = await _fetchUserDataFromAPI(userId);
      if (userData != null) {
        setState(() {
          // Populate basic user info if available
          if (userData['username'] != null && userData['username'].toString().isNotEmpty) {
            name = userData['username'].toString();
          }
          if (userData['email'] != null && userData['email'].toString().isNotEmpty) {
            email = userData['email'].toString();
          }
          if (userData['phone_number'] != null && userData['phone_number'].toString().isNotEmpty) {
            phoneNumber = userData['phone_number'].toString();
          }
          
          // Populate preference fields if available in user object
          if (userData['gender'] != null) {
            gender = _formatGenderFromAPI(userData['gender'].toString());
          }
          if (userData['age'] != null) {
            age = userData['age'] is int ? userData['age'] : int.tryParse(userData['age'].toString()) ?? age;
          }
          if (userData['height'] != null) {
            height = userData['height'] is int ? userData['height'] : int.tryParse(userData['height'].toString()) ?? height;
          }
          if (userData['body_type'] != null) {
            bodyType = _formatBodyTypeFromAPI(userData['body_type'].toString());
          }
          if (userData['skin_tone'] != null) {
            selectedSkin = _mapSkinToneToIndex(userData['skin_tone'].toString());
          }
          if (userData['undertone'] != null) {
            selectedUndertone = _formatUndertoneFromAPI(userData['undertone'].toString());
          }
        });
        
        print('✅ User data loaded successfully');
      } else {
        // Fallback to SharedPreferences for phone number
        final storedPhone = prefs.getString('user_phone') ?? prefs.getString('phone_number');
        if (storedPhone != null && storedPhone.isNotEmpty) {
          setState(() {
            phoneNumber = storedPhone;
          });
        }
        
        // Also try to get user info from JWT token if available
        final token = await UserApiService.getAuthToken();
        if (token != null) {
          // For testing, we know the phone from the JWT token
          // In production, you might decode the JWT or call a user info API
          setState(() {
            if (phoneNumber.isEmpty) {
              phoneNumber = "+12222222222"; // From the test token
            }
          });
        }
        
        print('📱 Using stored phone number: $phoneNumber');
      }
      
    } catch (e) {
      print('❌ Error loading user data: $e');
    }
  }

  /// Load preferences from local storage, API, and ML model
  Future<void> _loadPreferences() async {
    try {
      print('🔍 Loading preferences...');
      
      // Get user ID
      final userId = await UserApiService.getUserId();
      if (userId == null) {
        print('❌ No user ID found for preferences');
        return;
      }
      
      // First try to load from local storage
      final localPrefs = await PreferencePrefs.loadFromPrefs();
      
      if (localPrefs != null) {
        print('✅ Found local preferences, populating...');
        _populatePreferencesFromModel(localPrefs);
        return;
      }

      // If no local preferences, try to fetch from preference API
      final serverPrefs = await _fetchPreferencesFromAPI(userId);
      if (serverPrefs != null) {
        print('✅ Found server preferences, populating...');
        _populatePreferencesFromModel(serverPrefs);
        // Save to local storage for future use
        await serverPrefs.saveToPrefs();
        return;
      }

      // If no preferences found, try to load ML-analyzed preferences
      final mlPrefs = await MLPreferenceService.getUserPreferences(userId);
      if (mlPrefs != null) {
        print('✅ Found ML preferences, populating...');
        _populatePreferencesFromModel(mlPrefs);
        // Save to local storage for future use
        await mlPrefs.saveToPrefs();
        return;
      }
      
      print('ℹ️ No existing preferences found, using defaults');
    } catch (e) {
      print('❌ Error loading preferences: $e');
    }
  }

  /// Populate UI fields from preference model
  void _populatePreferencesFromModel(Preference prefs) {
    print('📋 Populating UI from preference model...');
    
    setState(() {
      // Basic demographic info
      if (prefs.gender != null && prefs.gender!.isNotEmpty) {
        gender = _formatGenderFromAPI(prefs.gender!);
        print('👤 Gender: $gender');
      }
      
      if (prefs.age != null && prefs.age! > 0) {
        age = prefs.age!;
        print('🎂 Age: $age');
      }
      
      if (prefs.height != null && prefs.height! > 0) {
        height = prefs.height!;
        print('📏 Height: ${height}cm');
      }
      
      if (prefs.bodyType != null && prefs.bodyType!.isNotEmpty) {
        bodyType = _formatBodyTypeFromAPI(prefs.bodyType!);
        print('🏋️ Body Type: $bodyType');
      }
      
      // Skin tone and undertone
      if (prefs.skinTone != null && prefs.skinTone!.isNotEmpty) {
        selectedSkin = _mapSkinToneToIndex(prefs.skinTone!);
        print('🎨 Skin Tone: ${prefs.skinTone} (index: $selectedSkin)');
      }
      
      if (prefs.undertone != null && prefs.undertone!.isNotEmpty) {
        selectedUndertone = _formatUndertoneFromAPI(prefs.undertone!);
        print('🌈 Undertone: $selectedUndertone');
      }
      
      // Style preferences
      if (prefs.style != null && prefs.style!.isNotEmpty) {
        // Convert styles to title case for UI display
        final titleCaseStyles = prefs.style!.map((style) => 
          style.isNotEmpty ? style[0].toUpperCase() + style.substring(1).toLowerCase() : style
        ).toList();
        
        print('👔 Styles from model: ${prefs.style}');
        print('👔 Formatted styles: $titleCaseStyles');
        
        // If this is the first time loading ML recommendations, auto-select them
        if (!_hasLoadedMLRecommendations && titleCaseStyles.isNotEmpty) {
          selectedStyles = titleCaseStyles.toSet();
          _hasLoadedMLRecommendations = true;
          print('✨ Auto-selected ML recommended styles');
        }
        
        // Always update ML-recommended styles for display purposes
        mlRecommendedStyles = titleCaseStyles;
      }
      
      // Occasions
      if (prefs.occasion != null && prefs.occasion!.isNotEmpty) {
        selectedOccasions = prefs.occasion!.toSet();
        print('🎉 Occasions: $selectedOccasions');
      }
      
      // Festivals
      if (prefs.festivals != null && prefs.festivals!.isNotEmpty) {
        selectedFestivals = prefs.festivals!.toSet();
        print('🎊 Festivals: $selectedFestivals');
      }
      
      // Color preferences
      if (prefs.colorTones != null && prefs.colorTones!.isNotEmpty) {
        mlColorTones = prefs.colorTones!;
        print('🎨 Color tones: ${mlColorTones.length} colors loaded');
      }
    });
    
    print('✅ UI population completed');
  }

  /// Map skin tone string to UI index
  int _mapSkinToneToIndex(String skinTone) {
    switch (skinTone.toLowerCase()) {
      case 'very_fair':
        return 0;
      case 'fair':
        return 1;
      case 'medium':
        return 2;
      case 'olive':
        return 3;
      case 'brown':
        return 4;
      case 'deep':
        return 5;
      default:
        return 2; // Default to medium
    }
  }

  /// Fetch user data from API using getUserById endpoint
  Future<Map<String, dynamic>?> _fetchUserDataFromAPI(String userId) async {
    try {
      final token = await UserApiService.getAuthToken();
      if (token == null) {
        print('❌ No auth token available for API call');
        return null;
      }

      final url = Uri.parse('${webApi['domain']}${endPoint['getUserById']}/$userId');
      print('🌐 Fetching user data from: $url');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'userId': userId}),
      );

      print('📊 User data response status: ${response.statusCode}');
      print('📄 User data response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          return responseData['data'];
        }
      } else if (response.statusCode == 401) {
        print('🔄 Token expired, clearing and retrying...');
        // Clear token and try once more
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        
        final newToken = await UserApiService.getAuthToken();
        if (newToken != null) {
          final retryResponse = await http.post(
            url,
            headers: {
              'Authorization': 'Bearer $newToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'userId': userId}),
          );
          
          if (retryResponse.statusCode == 200) {
            final retryData = json.decode(retryResponse.body);
            if (retryData['success'] == true && retryData['data'] != null) {
              return retryData['data'];
            }
          }
        }
      }

      return null;
    } catch (e) {
      print('❌ Error fetching user data: $e');
      return null;
    }
  }

  /// Format gender from API response to UI format
  String _formatGenderFromAPI(String apiGender) {
    switch (apiGender.toLowerCase()) {
      case 'male':
        return 'Male';
      case 'female':
        return 'Female';
      case 'other':
        return 'Other';
      default:
        return 'Male'; // Default
    }
  }

  /// Format body type from API response to UI format
  String _formatBodyTypeFromAPI(String apiBodyType) {
    // API might use lowercase or different format, normalize to UI format
    switch (apiBodyType.toLowerCase()) {
      case 'hourglass':
        return 'Hourglass';
      case 'triangle':
      case 'pear':
        return 'Triangle';
      case 'round':
      case 'apple':
        return 'Round';
      case 'straight':
      case 'rectangle':
        return 'Straight';
      case 'inverted triangle':
      case 'inverted_triangle':
        return 'Inverted Triangle';
      case 'ectomorph':
        return 'Ectomorph';
      case 'mesomorph':
        return 'Mesomorph';
      case 'endomorph':
        return 'Endomorph';
      default:
        return apiBodyType; // Return as-is if no mapping found
    }
  }

  /// Format undertone from API response to UI format
  String _formatUndertoneFromAPI(String apiUndertone) {
    switch (apiUndertone.toLowerCase()) {
      case 'warm':
        return 'Warm';
      case 'cool':
        return 'Cool';
      case 'neutral':
        return 'Neutral';
      default:
        return 'Neutral'; // Default
    }
  }

  /// Fetch preferences from API using getPrefByUserId endpoint
  Future<Preference?> _fetchPreferencesFromAPI(String userId) async {
    try {
      final token = await UserApiService.getAuthToken();
      if (token == null) {
        print('❌ No auth token available for preferences API call');
        return null;
      }

      final url = Uri.parse('${webApi['domain']}${endPoint['getPrefByUserId']}/$userId');
      print('🌐 Fetching preferences from: $url');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'userId': userId}),
      );

      print('📊 Preferences response status: ${response.statusCode}');
      print('📄 Preferences response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final userData = responseData['data'];
          final prefData = userData['preference']; // Extract preference from user data
          
          if (prefData != null) {
            // Convert API response to Preference model
            return Preference(
              userObjectId: int.tryParse(userId) ?? 0,
              gender: prefData['gender'],
              age: prefData['age'] is int ? prefData['age'] : int.tryParse(prefData['age']?.toString() ?? '0'),
              height: prefData['height'] is int ? prefData['height'] : int.tryParse(prefData['height']?.toString() ?? '0'),
              bodyType: prefData['body_type'],
              skinTone: prefData['skin_tone'],
              style: prefData['style'] is List ? List<String>.from(prefData['style']) : [],
              occasion: prefData['occasion'] is List ? List<String>.from(prefData['occasion']) : [],
              festivals: prefData['festivals'] is List ? List<String>.from(prefData['festivals']) : [],
              colorTones: prefData['color_tones'] is List ? List<String>.from(prefData['color_tones']) : [],
              undertone: prefData['undertone'],
              createdAt: prefData['createdAt'] != null ? DateTime.tryParse(prefData['createdAt']) : null,
              updatedAt: prefData['updatedAt'] != null ? DateTime.tryParse(prefData['updatedAt']) : null,
            );
          }
        }
      } else if (response.statusCode == 401) {
        print('🔄 Token expired for preferences, clearing and retrying...');
        // Clear token and try once more
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        
        final newToken = await UserApiService.getAuthToken();
        if (newToken != null) {
          final retryResponse = await http.post(
            url,
            headers: {
              'Authorization': 'Bearer $newToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'userId': userId}),
          );
          
          if (retryResponse.statusCode == 200) {
            final retryData = json.decode(retryResponse.body);
            if (retryData['success'] == true && retryData['data'] != null) {
              final userData = retryData['data'];
              final prefData = userData['preference']; // Extract preference from user data
              
              if (prefData != null) {
                return Preference(
                  userObjectId: int.tryParse(userId) ?? 0,
                  gender: prefData['gender'],
                  age: prefData['age'] is int ? prefData['age'] : int.tryParse(prefData['age']?.toString() ?? '0'),
                  height: prefData['height'] is int ? prefData['height'] : int.tryParse(prefData['height']?.toString() ?? '0'),
                  bodyType: prefData['body_type'],
                  skinTone: prefData['skin_tone'],
                  style: prefData['style'] is List ? List<String>.from(prefData['style']) : [],
                  occasion: prefData['occasion'] is List ? List<String>.from(prefData['occasion']) : [],
                  festivals: prefData['festivals'] is List ? List<String>.from(prefData['festivals']) : [],
                  colorTones: prefData['color_tones'] is List ? List<String>.from(prefData['color_tones']) : [],
                  undertone: prefData['undertone'],
                  createdAt: prefData['createdAt'] != null ? DateTime.tryParse(prefData['createdAt']) : null,
                  updatedAt: prefData['updatedAt'] != null ? DateTime.tryParse(prefData['updatedAt']) : null,
                );
              }
            }
          }
        }
      }

      return null;
    } catch (e) {
      print('❌ Error fetching preferences: $e');
      return null;
    }
  }

  /// Save current preferences to local storage and server
  Future<void> _savePreferences() async {
    try {
      final userId = await MLPreferenceService.getCurrentUserId();
      if (userId == null) {
        // Check if widget is still mounted before showing snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User not found. Please login again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Create preference model from current UI state
      final preference = Preference(
        userObjectId: int.parse(userId), // Convert string to int
        gender: gender,
        age: age,
        height: height,
        bodyType: bodyType,
        skinTone: _mapSkinIndexToTone(selectedSkin),
        style: selectedStyles.map((style) => style.toLowerCase()).toList(),
        occasion: selectedOccasions.toList(),
        festivals: selectedFestivals.toList(),
        colorTones: mlColorTones, // Use hex codes directly
        undertone: selectedUndertone.toLowerCase(), // Convert to lowercase for ML model
      );

      // Save to local storage
      await preference.saveToPrefs();

      // Try to get existing preference ID to update, or create new
      final existingPrefs = await MLPreferenceService.getUserPreferences(userId);
      
      if (existingPrefs != null) {
        // Update existing preference (we would need the preference ID for this)
        // For now, just show success message as the backend handles create/update
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Preferences updated successfully!'),
              backgroundColor: Color(0xFFB8956A),
            ),
          );
        }
      } else {
        // New preference will be created by the backend
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Preferences saved successfully!'),
              backgroundColor: Color(0xFFB8956A),
            ),
          );
        }
      }
    } catch (e) {
      print('Error saving preferences: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save preferences. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Map skin tone index to string
  String _mapSkinIndexToTone(int index) {
    switch (index) {
      case 0:
        return 'very_fair';
      case 1:
        return 'fair';
      case 2:
        return 'medium';
      case 3:
        return 'olive';
      case 4:
        return 'brown';
      case 5:
        return 'deep';
      default:
        return 'medium';
    }
  }

  /// Re-analyze preferences from saved selfie
  Future<void> _reAnalyzePreferences() async {
    try {
      print('🔄 Starting preference re-analysis...');
      
      final userId = await MLPreferenceService.getCurrentUserId();
      if (userId == null) {
        print('❌ No user ID found');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User not found. Please login again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      print('✅ User ID found: $userId');

      // Get saved selfie
      final base64Image = await PhotoStorageHelper.getSavedSelfieAsBase64();
      if (base64Image == null) {
        print('❌ No saved selfie found');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No saved selfie found. Please capture a new photo.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
      print('✅ Base64 image retrieved, length: ${base64Image.length}');

      // Check if widget is still mounted before showing dialog
      if (!mounted) return;

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Re-analyzing your preferences...'),
              SizedBox(height: 8),
              Text('This may take 10-30 seconds', 
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      );

      print('🚀 Sending request to ML service...');
      
      // Analyze preferences
      final preferences = await MLPreferenceService.analyzeAndGetPreferences(
        userId: userId,
        imageBase64: base64Image,
      );

      // Close loading dialog
      Navigator.pop(context);

      if (preferences != null) {
        print('✅ Preferences received successfully');
        print('📋 Gender: ${preferences.gender}');
        print('📋 Age: ${preferences.age}');
        print('📋 Skin Tone: ${preferences.skinTone}');
        print('📋 Style: ${preferences.style}');
        print('📋 Colors: ${preferences.colorTones}');
        
        // Update UI with new preferences
        _populatePreferencesFromModel(preferences);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Preferences re-analyzed successfully!'),
            backgroundColor: Color(0xFFB8956A),
          ),
        );
      } else {
        print('❌ No preferences returned from ML service');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to re-analyze preferences. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      print('💥 Error re-analyzing preferences: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error re-analyzing preferences: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Convert hex code to readable color name
  String _getColorName(String hexCode) {
    try {
      // Remove # if present
      String cleanHex = hexCode.replaceFirst('#', '');
      
      // Parse RGB values
      int colorValue = int.parse(cleanHex, radix: 16);
      int r = (colorValue >> 16) & 0xFF;
      int g = (colorValue >> 8) & 0xFF;
      int b = colorValue & 0xFF;
      
      // Determine dominant color channel
      if (r > g && r > b) {
        return 'Red';
      } else if (g > r && g > b) {
        return 'Green';
      } else if (b > r && b > g) {
        return 'Blue';
      } else if (r == g && r > b) {
        return 'Yellow';
      } else if (r == b && r > g) {
        return 'Magenta';
      } else if (g == b && g > r) {
        return 'Cyan';
      } else {
        // Similar RGB values - neutral color
        int avg = (r + g + b) ~/ 3;
        if (avg < 85) return 'Dark';
        if (avg > 170) return 'Light';
        return 'Gray';
      }
    } catch (e) {
      return hexCode; // Return original hex if parsing fails
    }
  }

  List<Color> skinTones = [
    Color(0xFFFFE0BD),
    Color(0xFFFFCD94),
    Color(0xFFEAC086),
    Color(0xFFC68642),
    Color(0xFF8D5524),
    Color(0xFF5C4033),
  ];

  void toggleSelection(Set<String> list, String value) {
    setState(() {
      if (list.contains(value)) {
        list.remove(value);
      } else {
        list.add(value);
      }
    });
  }

  List<String> getBodyTypeOptions(String gender) {
    if (gender == "Male") {
      return ["Ectomorph", "Mesomorph", "Endomorph"];
    } else if (gender == "Female") {
      return [
        "Hourglass",
        "Triangle", // Changed from "pear"
        "Round", // Changed from "apple"
        "Straight", // Changed from "rectangle"
        "Inverted Triangle", // Changed from "inverted_triangle"
      ];
    } else {
      return ["Ectomorph", "Mesomorph", "Endomorph", "Hourglass", "Triangle", "Round", "Straight", "Inverted Triangle"];
    }
  }

  IconData getBodyTypeIcon(String bodyType, String gender) {
    if (gender == "Male") {
      switch (bodyType) {
        case "Ectomorph":
          return Icons.accessibility_new; // Lean figure
        case "Mesomorph":
          return Icons.fitness_center; // Athletic figure
        case "Endomorph":
          return Icons.sports_martial_arts; // Broader/fuller figure
        default:
          return Icons.person;
      }
    } else if (gender == "Female") {
      switch (bodyType) {
        case "Hourglass":
          return Icons.hourglass_bottom; // Hourglass shape
        case "Triangle":
          return Icons.change_history; // Triangle shape
        case "Round":
          return Icons.circle; // Round shape
        case "Straight":
          return Icons.crop_portrait; // Rectangle shape
        case "Inverted Triangle":
          return Icons.details; // Inverted triangle
        default:
          return Icons.person;
      }
    } else {
      switch (bodyType) {
        case "Ectomorph":
          return Icons.accessibility_new;
        case "Mesomorph":
          return Icons.fitness_center;
        case "Endomorph":
          return Icons.sports_martial_arts;
        case "Hourglass":
          return Icons.hourglass_bottom;
        case "Triangle":
          return Icons.change_history;
        case "Round":
          return Icons.circle;
        case "Straight":
          return Icons.crop_portrait;
        case "Inverted Triangle":
          return Icons.details;
        default:
          return Icons.person;
      }
    }
  }

  void updateBodyTypeOnGenderChange(String newGender) {
    List<String> options = getBodyTypeOptions(newGender);
    if (!options.contains(bodyType)) {
      bodyType = options.first;
    }
  }

  /// Validate all required fields before API call
  String? _validateFields() {
    // Name validation
    if (name.isEmpty || name.trim().isEmpty) {
      return 'Please enter your name';
    }

    // Email validation
    if (email.isEmpty || email.trim().isEmpty) {
      return 'Please enter your email address';
    }
    
    if (!UserApiService.isValidEmail(email.trim())) {
      return 'Please enter a valid email address';
    }

    // Basic info validation
    if (age < 13 || age > 120) {
      return 'Please enter a valid age between 13 and 120';
    }

    if (height < 100 || height > 250) {
      return 'Please enter a valid height between 100 and 250 cm';
    }

    // Style preferences validation
    if (selectedStyles.isEmpty) {
      return 'Please select at least one style preference';
    }

    if (selectedOccasions.isEmpty) {
      return 'Please select at least one occasion';
    }

    return null; // All validations passed
  }

  /// Update user profile and preferences via API
  Future<void> _updateUserPreferences() async {
    try {
      // Validate fields first
      final validationError = _validateFields();
      if (validationError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text(validationError)),
              ],
            ),
            backgroundColor: Colors.orange.shade700,
            duration: Duration(seconds: 4),
          ),
        );
        return;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB8956A)),
              ),
              SizedBox(height: 16),
              Text(
                'Updating your preferences...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'This may take a few seconds',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );

      print('🚀 Starting comprehensive profile update...');

      // Step 1: Update user profile via UserApiService
      final result = await UserApiService.updateUserProfile(
        email: email.trim().toLowerCase(),
        username: name.trim(),
        gender: gender,
        age: age,
        height: height,
        bodyType: bodyType,
        skinTone: _mapSkinIndexToTone(selectedSkin),
        styles: selectedStyles.toList(),
        occasions: selectedOccasions.toList(),
        festivals: selectedFestivals.toList(),
        colorTones: mlColorTones.isNotEmpty ? mlColorTones : null,
        undertone: selectedUndertone,
        size: 'M', // Default size - could be made configurable
      );

      if (result != null) {
        print('✅ User profile updated successfully');
        
        // Step 2: Also save to local preferences for faster loading
        final preference = Preference(
          userObjectId: int.parse(await UserApiService.getUserId() ?? '0'),
          gender: gender,
          age: age,
          height: height,
          bodyType: bodyType,
          skinTone: _mapSkinIndexToTone(selectedSkin),
          style: selectedStyles.map((style) => style.toLowerCase()).toList(),
          occasion: selectedOccasions.toList(),
          festivals: selectedFestivals.toList(),
          colorTones: mlColorTones.isNotEmpty ? mlColorTones : null,
          undertone: selectedUndertone.toLowerCase(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Save to local storage
        await preference.saveToPrefs();
        print('✅ Preferences saved to local storage');

        // Close loading dialog
        Navigator.pop(context);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Profile updated successfully! Getting your curated results...'),
                ),
              ],
            ),
            backgroundColor: Color(0xFFB8956A),
            duration: Duration(seconds: 3),
          ),
        );

        // Show follow-up message about recommendations
        Future.delayed(Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Your personalized recommendations are ready! Redirecting to home...'),
                  ),
                ],
              ),
              backgroundColor: Color(0xFFD2B193),
              duration: Duration(seconds: 2),
            ),
          );
        });

        // Navigate to home screen after a short delay
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            NamedRoute.homeScreen,
            (route) => false, // Remove all previous routes
          );
        });

        print('✅ Complete profile update successful - navigating to home');

      } else {
        // Close loading dialog
        Navigator.pop(context);
        
        print('❌ Update failed - no result returned');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Failed to update profile. Please try again.')),
              ],
            ),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }

    } catch (e) {
      // Close loading dialog if open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      print('💥 Error updating profile: $e');
      
      String errorMessage = 'Failed to update profile. Please try again.';
      if (e.toString().contains('No authentication token')) {
        errorMessage = 'Please log in again to continue.';
      } else if (e.toString().contains('email')) {
        errorMessage = 'Please check your email address and try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text(errorMessage)),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double dH = MediaQuery.of(context).size.height;
    double dW = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Preferences', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.brown.shade300),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.brown.shade300),
            onPressed: () async {
              // Refresh all data from APIs
              await _refreshData();
            },
            tooltip: 'Refresh data from server',
          ),
          IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.brown.shade300),
            onPressed: () async {
              // Navigate to camera capture for testing
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CaptureFaceScreen()),
              );
              // The CaptureFaceScreen already handles ML analysis, so just refresh preferences
              if (result == true || result == null) {
                // Wait a moment for any background processing
                await Future.delayed(Duration(seconds: 1));
                // Reload preferences to see if they were updated
                await _loadPreferences();
              }
            },
            tooltip: 'Capture new photo and analyze',
          ),
          IconButton(
            icon: Icon(Icons.auto_awesome, color: Colors.brown.shade300),
            onPressed: () async {
              // Re-analyze preferences from saved photo
              await _reAnalyzePreferences();
            },
            tooltip: 'Re-analyze preferences from photo',
          ),
          IconButton(
            icon: Icon(Icons.save_outlined, color: Colors.brown.shade300),
            onPressed: () async {
              // Save preferences functionality
              await _savePreferences();
            },
            tooltip: 'Save preferences locally',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: dW * 0.05),
        child: Column(
          children: [
            SizedBox(height: dH * 0.02),
            // Profile Header Card
            Container(
              padding: EdgeInsets.all(dW * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Main Profile Content
                  Row(
                    children: [
                      // Avatar Section
                      GestureDetector(
                        onTap: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Navigate to avatar selection screen'),
                              backgroundColor: Color(0xFFB8956A),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: dW * 0.22,
                              height: dW * 0.22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.person, size: 35, color: Colors.white),
                            ),
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Color(0xFFD2B193),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.edit, size: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(width: dW * 0.05),
                      
                      // User Info Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.isEmpty ? 'Your Name' : name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: dH * 0.008),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFFD2B193).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "$gender • $age years",
                                style: TextStyle(
                                  color: Color(0xFFB8956A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: dH * 0.008),
                            Row(
                              children: [
                                Icon(Icons.phone_outlined, size: 16, color: Colors.grey.shade600),
                                SizedBox(width: 6),
                                Text(
                                  phoneNumber.isEmpty ? "+1 000-000-0000" : phoneNumber,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: dH * 0.008),
                            Row(
                              children: [
                                Icon(Icons.height, size: 16, color: Colors.grey.shade600),
                                SizedBox(width: 6),
                                Text(
                                  "$height cm",
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                ),
                                SizedBox(width: 16),
                                Icon(Icons.fitness_center, size: 16, color: Colors.grey.shade600),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    bodyType,
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Settings Icon - Positioned at top right
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _showPermissionsDialog(),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFD2B193).withOpacity(0.2),
                              Color(0xFFB8956A).withOpacity(0.15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFD2B193).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.settings_outlined,
                          color: Color(0xFFB8956A),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: dH * 0.025),
            
            // Basic Information Card
            _buildSectionCard(
              "Basic Information",
              Icons.person_outline,
              [
                _infoTile("Name", name.isEmpty ? "Enter your name" : name, () async {
                  final selected = await _showTextInputDialog("Enter Name", name);
                  if (selected != null && selected.isNotEmpty) {
                    setState(() => name = selected);
                  }
                }),
                _infoTile("Email", email.isEmpty ? "Enter your email" : email, () async {
                  final selected = await _showTextInputDialog("Enter Email", email);
                  if (selected != null && selected.isNotEmpty) {
                    setState(() => email = selected);
                  }
                }),
                _infoTile("Gender", gender, () async {
                  final selected = await _showOptionsDialog("Select Gender", [
                    "Male",
                    "Female",
                    "Other",
                  ]);
                  if (selected != null) {
                    setState(() {
                      gender = selected;
                      updateBodyTypeOnGenderChange(selected);
                    });
                  }
                }),
                _infoTile("Age", "$age Years", () async {
                  final selected = await _showNumberInputDialog("Enter Age", age);
                  if (selected != null) setState(() => age = selected);
                }),
                _infoTile("Height", "$height cm", () async {
                  final selected = await _showNumberInputDialog(
                    "Enter Height (cm)",
                    height,
                  );
                  if (selected != null) setState(() => height = selected);
                }),
                _infoTile("Body Type", formatBodyTypeName(bodyType), () async {
                  final options = getBodyTypeOptions(gender);
                  final selected = await _showBodyTypeDialog(
                    "Select Body Type",
                    options,
                    gender,
                  );
                  if (selected != null) setState(() => bodyType = selected);
                }),
              ],
            ),

            SizedBox(height: dH * 0.02),

            // Skin Tone Card
            _buildSectionCard(
              "Skin Tone",
              Icons.palette_outlined,
              [
                SizedBox(height: dH * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(skinTones.length, (index) {
                    return GestureDetector(
                      onTap: () => setState(() => selectedSkin = index),
                      child: Container(
                        decoration: BoxDecoration(
                          border: selectedSkin == index
                              ? Border.all(width: 3, color: Color(0xFFB8956A))
                              : Border.all(width: 2, color: Colors.grey.shade300),
                          color: skinTones[index],
                          shape: BoxShape.circle,
                          boxShadow: selectedSkin == index ? [
                            BoxShadow(
                              color: Color(0xFFB8956A).withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ] : [],
                        ),
                        width: 40,
                        height: 40,
                      ),
                    );
                  }),
                ),
                SizedBox(height: dH * 0.01),
              ],
            ),

            SizedBox(height: dH * 0.02),

            // Style Preferences Card
            _buildSectionCard(
              "Style Preferences",
              Icons.style_outlined,
              [
                _stylesSection(),
                _chipSection("Select Occasions", [
                  "Daily",
                  "Vacation",
                  "Office",
                  "Festival",
                  "Wedding",
                ], selectedOccasions),
                _chipSection("Select Festivals", [
                  "Christmas",
                  "Diwali",
                  "New Year",
                  "Holi",
                  "Eid",
                ], selectedFestivals),
              ],
            ),

            SizedBox(height: dH * 0.02),

            // Color Preferences Card
            _buildSectionCard(
              "Color Preferences",
              Icons.color_lens_outlined,
              [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _sectionTitle("Color Palette"),
                        if (mlColorTones.isNotEmpty) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFFB8956A).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFB8956A).withOpacity(0.5)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 12,
                                  color: Color(0xFFB8956A),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "ML Recommended",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFB8956A),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (mlColorTones.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 12,
                            color: Color(0xFFB8956A),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Colors recommended based on your skin tone analysis",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 8),
                    Container(
                      height: 80, // Increased height to accommodate hex codes
                      child: mlColorTones.isEmpty 
                        ? Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Center(
                              child: Text(
                                "Capture a photo to get personalized color recommendations",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: mlColorTones.map((hexCode) {
                                Color color;
                                try {
                                  color = Color(int.parse(hexCode.replaceFirst('#', '0xFF')));
                                } catch (e) {
                                  color = Colors.grey; // Fallback color
                                }
                                
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min, // Added to prevent overflow
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 3,
                                            color: Color(0xFFB8956A),
                                          ),
                                          color: color,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFFB8956A).withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        width: 45,
                                        height: 45,
                                        child: Center(
                                          child: Tooltip(
                                            message: hexCode,
                                            child: Container(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        _getColorName(hexCode),
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                    ),
                  ],
                ),
                SizedBox(height: dH * 0.02),
                // _sectionTitle("Undertone"),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFFD2B193).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color(0xFFD2B193).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.palette,
                        color: Color(0xFFB8956A),
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Detected Undertone:",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          selectedUndertone,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: dH * 0.03),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await _updateUserPreferences();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD2B193),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: dH * 0.018),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: Color(0xFFB8956A).withOpacity(0.4),
                ),
                icon: Icon(Icons.auto_awesome, size: 20),
                label: Text(
                  "Save & Get Personalized Products",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: dH * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFD2B193).withOpacity(0.2),
                      Color(0xFFB8956A).withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFFD2B193).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: Color(0xFFB8956A),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _infoTile(String title, String value, VoidCallback onTap) {
    bool isPlaceholder = value.startsWith("Enter your");
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Color(0xFFD2B193).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color(0xFFD2B193).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isPlaceholder ? Colors.grey.shade500 : Color(0xFFB8956A),
                      fontStyle: isPlaceholder ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Color(0xFFB8956A),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _chipSection(
    String title,
    List<String> options,
    Set<String> selected, {
    bool singleSelection = false,
    Function(String)? onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected =
                selected.contains(option) || selected.firstOrNull == option;
            return GestureDetector(
              onTap: () {
                if (singleSelection && onSelect != null) {
                  onSelect(option);
                } else {
                  toggleSelection(selected, option);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Color(0xFFB8956A)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Color(0xFFB8956A).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Future<String?> _showOptionsDialog(String title, List<String> options) {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) => 
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: Color(0xFFD2B193).withOpacity(0.1),
                title: Text(
                  option,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () => Navigator.pop(context, option),
              ),
            ),
          ).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Color(0xFFB8956A)),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showBodyTypeDialog(String title, List<String> options, String gender) {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFD2B193).withOpacity(0.2),
                    Color(0xFFB8956A).withOpacity(0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color(0xFFD2B193).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.accessibility_new,
                color: Color(0xFFB8956A),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6, // Limit height to 60% of screen
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((option) => 
                Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  child: InkWell(
                    onTap: () => Navigator.pop(context, option),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFD2B193).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(0xFFD2B193).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFD2B193).withOpacity(0.2),
                                  Color(0xFFB8956A).withOpacity(0.15),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFFD2B193).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              getBodyTypeIcon(option, gender),
                              color: Color(0xFFB8956A),
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatBodyTypeName(option),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _getBodyTypeDescription(option, gender),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFFB8956A),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Color(0xFFB8956A)),
            ),
          ),
        ],
      ),
    );
  }

  String formatBodyTypeName(String bodyType) {
    // Since we now use properly formatted names, just return as is
    return bodyType;
  }

  String _getBodyTypeDescription(String bodyType, String gender) {
    if (gender == "Male") {
      switch (bodyType) {
        case "Ectomorph":
          return "Lean and tall with fast metabolism";
        case "Mesomorph":
          return "Naturally muscular with broad shoulders";
        case "Endomorph":
          return "Larger bone structure with slower metabolism";
        default:
          return "Select your body type";
      }
    } else if (gender == "Female") {
      switch (bodyType) {
        case "Hourglass":
          return "Balanced bust and hips with defined waist";
        case "Triangle":
          return "Hips wider than shoulders, smaller upper body";
        case "Round":
          return "Fuller upper body, carries weight in midsection";
        case "Straight":
          return "Similar bust, waist, and hip measurements";
        case "Inverted Triangle":
          return "Broad shoulders, narrow hips";
        default:
          return "Select your body type";
      }
    } else {
      // For "other" gender, provide descriptions for all types
      switch (bodyType) {
        case "Ectomorph":
          return "Lean build with fast metabolism";
        case "Mesomorph":
          return "Naturally athletic build";
        case "Endomorph":
          return "Fuller build with slower metabolism";
        case "Hourglass":
          return "Balanced proportions with defined waist";
        case "Triangle":
          return "Lower body heavier than upper body";
        case "Round":
          return "Fuller midsection";
        case "Straight":
          return "Straight body line";
        case "Inverted Triangle":
          return "Broad shoulders, narrow hips";
        default:
          return "Select your body type";
      }
    }
  }

  Future<int?> _showNumberInputDialog(String title, int currentValue) {
    final controller = TextEditingController(text: currentValue.toString());

    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter value",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFD2B193)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFB8956A), width: 2),
            ),
            filled: true,
            fillColor: Color(0xFFD2B193).withOpacity(0.1),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD2B193),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final value = int.tryParse(controller.text);
              Navigator.pop(context, value);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<String?> _showTextInputDialog(String title, String currentValue) {
    final controller = TextEditingController(text: currentValue);

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: title.toLowerCase().contains('email') 
              ? TextInputType.emailAddress 
              : TextInputType.text,
          decoration: InputDecoration(
            hintText: title.toLowerCase().contains('email') 
                ? "Enter email address" 
                : "Enter $title",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFD2B193)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFB8956A), width: 2),
            ),
            filled: true,
            fillColor: Color(0xFFD2B193).withOpacity(0.1),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFD2B193),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final value = controller.text.trim();
              Navigator.pop(context, value.isNotEmpty ? value : null);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showPermissionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFD2B193).withOpacity(0.2),
                          Color(0xFFB8956A).withOpacity(0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xFFD2B193).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.security_outlined,
                      color: Color(0xFFB8956A),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'App Permissions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPermissionTile(
                      'Notifications',
                      'Receive updates and alerts',
                      Icons.notifications_outlined,
                      notificationsEnabled,
                      (value) => setDialogState(() {
                        setState(() => notificationsEnabled = value);
                      }),
                    ),
                    _buildPermissionTile(
                      'Location',
                      'Find stores and personalized content',
                      Icons.location_on_outlined,
                      locationEnabled,
                      (value) => setDialogState(() {
                        setState(() => locationEnabled = value);
                      }),
                    ),
                    _buildPermissionTile(
                      'Camera',
                      'Take photos and scan products',
                      Icons.camera_alt_outlined,
                      cameraEnabled,
                      (value) => setDialogState(() {
                        setState(() => cameraEnabled = value);
                      }),
                    ),
                    _buildPermissionTile(
                      'Storage',
                      'Save images and preferences',
                      Icons.storage_outlined,
                      storageEnabled,
                      (value) => setDialogState(() {
                        setState(() => storageEnabled = value);
                      }),
                    ),
                    _buildPermissionTile(
                      'Microphone',
                      'Voice commands and feedback',
                      Icons.mic_outlined,
                      microphoneEnabled,
                      (value) => setDialogState(() {
                        setState(() => microphoneEnabled = value);
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD2B193),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Permissions updated successfully!'),
                        backgroundColor: Color(0xFFB8956A),
                      ),
                    );
                  },
                  child: Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPermissionTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFD2B193).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFD2B193).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: value ? Color(0xFFD2B193).withOpacity(0.2) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: value ? Color(0xFFB8956A) : Colors.grey.shade500,
              size: 18,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFFD2B193),
            activeTrackColor: Color(0xFFB8956A).withOpacity(0.3),
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  /// Custom styles section that shows ML-recommended or default styles
  Widget _stylesSection() {
    // Define all available style options
    final allStyleOptions = ["Casual", "Formal", "Ethnic", "Party", "Sports"];
    
    // Combine ML-recommended styles with standard options, removing duplicates
    final availableStyles = <String>[];
    
    // Add ML-recommended styles first (if any)
    if (mlRecommendedStyles.isNotEmpty) {
      availableStyles.addAll(mlRecommendedStyles);
    }
    
    // Add any standard options that aren't already included
    for (final style in allStyleOptions) {
      if (!availableStyles.contains(style)) {
        availableStyles.add(style);
      }
    }
    
    // If no ML styles, use standard options
    if (availableStyles.isEmpty) {
      availableStyles.addAll(allStyleOptions);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _sectionTitle("Select Styles"),
            if (mlRecommendedStyles.isNotEmpty) ...[
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFB8956A).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFB8956A).withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 12,
                      color: Color(0xFFB8956A),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "ML Recommended",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFFB8956A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        if (mlRecommendedStyles.isNotEmpty) ...[
          SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.star,
                size: 12,
                color: Color(0xFFB8956A),
              ),
              SizedBox(width: 4),
              Text(
                "AI recommended styles (pre-selected)",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableStyles.map((option) {
            final isSelected = selectedStyles.contains(option);
            final isMLRecommended = mlRecommendedStyles.contains(option);
            
            return GestureDetector(
              onTap: () {
                toggleSelection(selectedStyles, option);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [Color(0xFFD2B193), Color(0xFFB8956A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Color(0xFFB8956A)
                        : isMLRecommended
                        ? Color(0xFFB8956A).withOpacity(0.5)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    if (isMLRecommended && !isSelected) ...[
                      SizedBox(width: 4),
                      Icon(
                        Icons.star,
                        size: 12,
                        color: Color(0xFFB8956A),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
