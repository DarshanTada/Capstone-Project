import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'preference_model.dart';
import 'relation_profile_model.dart';

class User {
  final String? id;
  final String? phoneNumber;
  final String? email;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? token;
  bool isGuest;
  bool isLocationAllowed;
  bool isNotificationAllowed;

  // New fields for structured data
  Preference? preference;
  List<RelationProfile>? relationProfiles;

  User({
    this.id,
    this.phoneNumber,
    this.email,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.token,
    this.preference,
    this.relationProfiles,
    this.isGuest = false,
    this.isLocationAllowed = false,
    this.isNotificationAllowed = false,
  });

  // Keep old phone property for backward compatibility
  String? get phone => phoneNumber;

  static User jsonToUser(Map<String, dynamic> responseData, {String? token}) {
    try {
      final userData = responseData['user'];
      final preferenceData = responseData['preference'];
      final relationProfileData = responseData['relationProfile'];

      print('Parsing User Data:');
      print('- userData: $userData');
      print('- preferenceData: $preferenceData');
      print('- relationProfileData: $relationProfileData');

      if (userData == null) {
        throw Exception('User data is null in response');
      }

      return User(
        id: userData['_id'],
        phoneNumber: userData['phone_number'],
        email: userData['email'],
        role: userData['role'],
        createdAt: userData['createdAt'] != null
            ? DateTime.parse(userData['createdAt']).toLocal()
            : null,
        updatedAt: userData['updatedAt'] != null
            ? DateTime.parse(userData['updatedAt']).toLocal()
            : null,
        token: token,
        preference: preferenceData != null
            ? Preference.fromJson(preferenceData)
            : null,
        relationProfiles:
            relationProfileData != null && relationProfileData is List
            ? relationProfileData
                  .map((profile) => RelationProfile.fromJson(profile))
                  .toList()
            : [],
        isLocationAllowed: false, // Default values
        isNotificationAllowed: false,
      );
    } catch (error) {
      print('Error in User.jsonToUser: $error');
      print('ResponseData: $responseData');
      rethrow;
    }
  }

  // Getter for active preference (either from relation profile or user's own preference)
  Preference? get activePreference {
    if (relationProfiles != null) {
      final activeRelation = relationProfiles!.firstWhere(
        (profile) => profile.isActive == true,
        orElse: () => RelationProfile(),
      );
      if (activeRelation.preference != null) {
        return activeRelation.preference;
      }
    }
    return preference;
  }
}

extension UserPrefs on User {
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userMap = {
      '_id': id,
      'phone_number': phoneNumber,
      'email': email,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'token': token,
      'isLocationAllowed': isLocationAllowed,
      'isNotificationAllowed': isNotificationAllowed,
      'isGuest': isGuest,
    };
    await prefs.setString('user_data', jsonEncode(userMap));

    // Save preference and relation profiles separately
    if (preference != null) {
      await preference!.saveToPrefs();
    }
    if (relationProfiles != null) {
      await relationProfiles!.saveToPrefs();
    }
  }

  static Future<User?> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_data');
    if (jsonString == null) return null;

    final userMap = jsonDecode(jsonString) as Map<String, dynamic>;

    // Load preference and relation profiles separately
    final preference = await PreferencePrefs.loadFromPrefs();
    final relationProfiles = await RelationProfilePrefs.loadFromPrefs();

    return User(
      id: userMap['_id'],
      phoneNumber: userMap['phone_number'],
      email: userMap['email'],
      role: userMap['role'],
      createdAt: userMap['createdAt'] != null
          ? DateTime.parse(userMap['createdAt']).toLocal()
          : null,
      updatedAt: userMap['updatedAt'] != null
          ? DateTime.parse(userMap['updatedAt']).toLocal()
          : null,
      token: userMap['token'],
      preference: preference,
      relationProfiles: relationProfiles,
      isLocationAllowed: userMap['isLocationAllowed'] ?? false,
      isNotificationAllowed: userMap['isNotificationAllowed'] ?? false,
      isGuest: userMap['isGuest'] ?? false,
    );
  }

  static Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    await PreferencePrefs.clearPrefs();
    await RelationProfilePrefs.clearPrefs();
  }
}
