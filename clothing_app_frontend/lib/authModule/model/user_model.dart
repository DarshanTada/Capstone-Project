import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:clothing_app_frontend/common_functions.dart';

class User {
  final String id;
  String fullName;
  String phone;
  String countryCode;
  String avatar;
  String email;
  DateTime? dob;
  String gender;
  num totalSavings;
  num walletBalance;
  String walletId;
  String accessToken;
  String fcmToken;
  bool isActive;
  bool isGuest;
  bool isLocationAllowed;
  bool isNotificationAllowed;
  LatLng? coordinates;

  User({
    required this.id,
    this.fullName = '',
    this.email = '',
    this.dob,
    this.phone = '',
    this.countryCode = '',
    this.avatar = '',
    this.gender = '',
    this.totalSavings = 00,
    this.walletBalance = 00,
    this.walletId = '',
    this.accessToken = '',
    this.fcmToken = '',
    this.isActive = false,
    // required this.fcmToken,
    this.isGuest = false,
    this.isLocationAllowed = false,
    this.isNotificationAllowed = false,
    this.coordinates,
  });

  static User jsonToUser(Map user, {required String accessToken}) => User(
    id: user['_id'],
    fullName: user['fullName'],
    phone: user['phone'],
    countryCode: user['countryCode'],
    gender: user['gender'],
    email: user['email'],
    dob: getParseDate(user['dob'])!,
    // dob: DateTime.parse(user['dob']).toLocal(),
    avatar: user['avatar'] ?? '',
    totalSavings: user['totalSavings'] ?? 0,
    walletBalance: user['walletBalance'] ?? 0,
    walletId: user['walletId'] ?? '',
    accessToken: accessToken,
    isActive: user['isActive'] ?? true,
    isLocationAllowed: user['isLocationAllowed'] ?? false,
    isNotificationAllowed: user['isNotificationAllowed'] ?? false,

    // fcmToken: user['fcmToken'] ?? '',
  );
}
