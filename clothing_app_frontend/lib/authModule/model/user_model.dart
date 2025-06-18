import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class User {
  final String? id;
  final String? phone;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? age;
  final String? colorPalette;
  final String? email;
  final String? gender;
  final double? height;
  final String? fullName;
  final String? size;
  final String? accessToken;
  final String? userId;
  final String? token;
  bool isGuest;
  bool isLocationAllowed;
  bool isNotificationAllowed;

  User({
    this.id,
    this.phone,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.age,
    this.colorPalette,
    this.email,
    this.gender,
    this.height,
    this.fullName,
    this.size,
    this.accessToken,
    this.userId,
    this.token,
    this.isGuest = false,
    this.isLocationAllowed = false,
    this.isNotificationAllowed = false,
  });

  static User jsonToUser(Map<String, dynamic> user) {
    return User(
      id: user['_id'],
      phone: user['phone_number'],
      role: user['role'],
      createdAt: user['createdAt'] != null
          ? DateTime.parse(user['createdAt']).toLocal()
          : null,
      updatedAt: user['updatedAt'] != null
          ? DateTime.parse(user['updatedAt']).toLocal()
          : null,
      age: user['age'],
      colorPalette: user['color_palette'],
      email: user['email'],
      gender: user['gender'],
      height: (user['height'] is int)
          ? (user['height'] as int).toDouble()
          : user['height'],
      fullName: user['name'],
      size: user['size'],
      userId: user['userId'],
      token: user['token'],
      isLocationAllowed: user['isLocationAllowed'] ?? false,
      isNotificationAllowed: user['isNotificationAllowed'] ?? false,
    );
  }
}

extension UserPrefs on User {
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userMap = {
      '_id': id,
      'phone_number': phone,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'age': age,
      'color_palette': colorPalette,
      'email': email,
      'gender': gender,
      'height': height,
      'name': fullName,
      'size': size,
      'userId': userId,
      'token': token,
      'isLocationAllowed': isLocationAllowed,
      'isNotificationAllowed': isNotificationAllowed,
      'isGuest': isGuest,
    };
    await prefs.setString('user_data', jsonEncode(userMap));
  }

  static Future<User?> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_data');
    if (jsonString == null) return null;
    final userMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return User.jsonToUser(userMap)..isGuest = userMap['isGuest'] ?? false;
  }

  static Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
  }
}
