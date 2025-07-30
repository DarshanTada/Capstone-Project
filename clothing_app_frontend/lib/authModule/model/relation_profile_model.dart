import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'preference_model.dart';

class RelationProfile {
  final Preference? preference;
  final bool? isActive;
  final String? userId;

  RelationProfile({this.preference, this.isActive, this.userId});

  factory RelationProfile.fromJson(Map<String, dynamic> json) {
    return RelationProfile(
      preference: json['preference'] != null
          ? Preference.fromJson(json['preference'])
          : null,
      isActive: json['isActive'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preference': preference?.toJson(),
      'isActive': isActive,
      'userId': userId,
    };
  }
}

extension RelationProfilePrefs on List<RelationProfile> {
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> profilesJson = map(
      (profile) => profile.toJson(),
    ).toList();
    await prefs.setString('relation_profiles', jsonEncode(profilesJson));
  }

  static Future<List<RelationProfile>> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('relation_profiles');
    if (jsonString == null) return [];
    final List<dynamic> profilesList = jsonDecode(jsonString);
    return profilesList
        .map(
          (profileJson) =>
              RelationProfile.fromJson(profileJson as Map<String, dynamic>),
        )
        .toList();
  }

  static Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('relation_profiles');
  }
}
