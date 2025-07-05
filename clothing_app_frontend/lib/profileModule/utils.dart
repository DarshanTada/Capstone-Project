import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileData {
  ProfileData(this.avatarId, {this.avatarUrl});
  final String? avatarId;
  final String? avatarUrl;
}

ProfileData? userFromPrefs(SharedPreferences prefs) {
  final String? jsonStr = prefs.getString('avatar');
  if (jsonStr == null) return null;

  final Map<String, dynamic> json = jsonDecode(jsonStr);
  final String? avatarUrl = json['data']?['url'];
  if (avatarUrl == null) return null;

  final String avatarId = avatarUrl.split('/').last.replaceAll('.glb', '');
  return ProfileData(avatarId, avatarUrl: avatarUrl);
}
