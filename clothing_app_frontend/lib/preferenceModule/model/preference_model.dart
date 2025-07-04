import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Preference {
  final int userObjectId;
  final String? gender;
  final int? age;
  final int? height;
  final String? bodyType;
  final String? skinTone;
  final List<String>? style;
  final List<String>? occasion;
  final List<String>? festivals;
  final List<String>? colorTones;
  final String? undertone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Preference({
    required this.userObjectId,
    this.gender,
    this.age,
    this.height,
    this.bodyType,
    this.skinTone,
    this.style,
    this.occasion,
    this.festivals,
    this.colorTones,
    this.undertone,
    this.createdAt,
    this.updatedAt,
  });

  factory Preference.fromJson(Map<String, dynamic> json) {
    return Preference(
      userObjectId: json['user_objectId'],
      gender: json['gender'],
      age: json['age'],
      height: json['height'],
      bodyType: json['body_type'],
      skinTone: json['skin_tone'],
      style: (json['style'] as List?)?.cast<String>(),
      occasion: (json['occasion'] as List?)?.cast<String>(),
      festivals: (json['festivals'] as List?)?.cast<String>(),
      colorTones: (json['color_tones'] as List?)?.cast<String>(),
      undertone: json['undertone'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_objectId': userObjectId,
      'gender': gender,
      'age': age,
      'height': height,
      'body_type': bodyType,
      'skin_tone': skinTone,
      'style': style,
      'occasion': occasion,
      'festivals': festivals,
      'color_tones': colorTones,
      'undertone': undertone,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

extension PreferencePrefs on Preference {
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final preferenceMap = toJson();
    await prefs.setString('preference_data', jsonEncode(preferenceMap));
  }

  static Future<Preference?> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('preference_data');
    if (jsonString == null) return null;
    final preferenceMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return Preference.fromJson(preferenceMap);
  }

  static Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('preference_data');
  }
}
