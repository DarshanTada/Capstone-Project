import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserPhoto {
  final String? base64;
  final String? contentType;

  UserPhoto({this.base64, this.contentType});

  factory UserPhoto.fromJson(Map<String, dynamic> json) {
    return UserPhoto(base64: json['base64'], contentType: json['contentType']);
  }

  Map<String, dynamic> toJson() {
    return {'base64': base64, 'contentType': contentType};
  }
}

class Preference {
  final String? id;
  final String? userId;
  final String? username;
  final String? gender;
  final int? age;
  final double? height;
  final String? bodyType;
  final String? skinTone;
  final List<String>? style;
  final List<String>? occasion;
  final List<String>? festivals;
  final List<String>? colorTones;
  final String? size;
  final String? undertone;
  final UserPhoto? userPhoto;
  final String? avatarURL;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Preference({
    this.id,
    this.userId,
    this.username,
    this.gender,
    this.age,
    this.height,
    this.bodyType,
    this.skinTone,
    this.style,
    this.occasion,
    this.festivals,
    this.colorTones,
    this.size,
    this.undertone,
    this.userPhoto,
    this.avatarURL,
    this.createdAt,
    this.updatedAt,
  });

  factory Preference.fromJson(Map<String, dynamic> json) {
    return Preference(
      id: json['_id'],
      userId: json['user'],
      username: json['username'],
      gender: json['gender'],
      age: json['age'],
      height: (json['height'] is int)
          ? (json['height'] as int).toDouble()
          : json['height'],
      bodyType: json['body_type'],
      skinTone: json['skin_tone'],
      style: json['style'] != null ? List<String>.from(json['style']) : null,
      occasion: json['occasion'] != null
          ? List<String>.from(json['occasion'])
          : null,
      festivals: json['festivals'] != null
          ? List<String>.from(json['festivals'])
          : null,
      colorTones: json['color_tones'] != null
          ? List<String>.from(json['color_tones'])
          : null,
      size: json['size'],
      undertone: json['undertone'],
      userPhoto: json['userPhoto'] != null
          ? UserPhoto.fromJson(json['userPhoto'])
          : null,
      avatarURL: json['avartarURL'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']).toLocal()
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt']).toLocal()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'username': username,
      'gender': gender,
      'age': age,
      'height': height,
      'body_type': bodyType,
      'skin_tone': skinTone,
      'style': style,
      'occasion': occasion,
      'festivals': festivals,
      'color_tones': colorTones,
      'size': size,
      'undertone': undertone,
      'userPhoto': userPhoto?.toJson(),
      'avartarURL': avatarURL,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

extension PreferencePrefs on Preference {
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_preference', jsonEncode(toJson()));
  }

  static Future<Preference?> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_preference');
    if (jsonString == null) return null;
    final preferenceMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return Preference.fromJson(preferenceMap);
  }

  static Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_preference');
  }
}
