import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:convert';
import '../../http_helper.dart';
import '../model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../../api.dart';

class AuthProvider with ChangeNotifier {
  final LocalStorage storage = LocalStorage('re_household');
  List availableLanguages = [];

  String razorpayId = 'rzp_test_T4eGUVSdlEPgNm';
  String helpAndSuppWhatsApp = '7666136015';

  Map get selectedLanguage => {
    "iteeha": "Iteeha",
    // Corousel Screen
    "skip": "SKIP",
    "keepTrackOfYourWalletBalanceInRealTime":
        "Keep Track of your wallet balance in real time",
    "findTheNearestCafeLocationsUsingOurStoreLocatorFeature":
        "Find the nearest cafe locations using our store locator feature",
    "joinOurLoyaltyProgram&EarnExcitingRewards":
        "Join our loyalty program & earn exciting rewards",

    // Auth Screen
    "welcomeTo": "Welcome to",
    "signIn": "Sign In",
    "yourStyleYourWay": "Your Style, Your Way",
    "000-000-0000": "000-000-0000",

    //Home Screen

    // Wallet Screen

    // Offer Screen

    // Cafe Images Screen

    // Cafe Details Screen

    // All Cafes Screen
  };

  late User user;

  String androidVersion = '0';
  String iOSVersion = '0';
  Map? deleteFeature;

  setGuestUser() {
    user = User(isGuest: true, id: '');
  }

  void updatePermission({
    required String permissionType,
    required bool newValue,
  }) {
    if (permissionType == 'location') {
      user.isLocationAllowed = newValue;
    } else {
      user.isNotificationAllowed = newValue;
    }
    notifyListeners();
  }

  refreshUser() async {
    final String url = '${webApi['domain']}${endPoint['refreshUser']}';
    try {
      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
        accessToken: user.accessToken,
      );

      if (response['success']) {
        user = User.jsonToUser(
          response['result'],
          accessToken: user.accessToken,
        );

        notifyListeners();
      }

      notifyListeners();
      return response;
    } catch (e) {
      return {'success': false, 'message': 'failedToRefresh'};
    }
  }

  fetchMyLocation() async {
    late LatLng coord;
    final location =
        await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        ).catchError((e) {
          print(e);
        });
    coord = LatLng(location.latitude, location.longitude);
    user.coordinates = coord;
    notifyListeners();
    return true;
  }

  sendOTPtoUser(String mobileNo, {bool business = false}) async {
    final url = '${webApi['domain']}${endPoint['sendOTPtoUser']}';
    Map body = {'mobileNo': mobileNo};
    try {
      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: body,
      );

      return response;
    } catch (error) {
      return {'success': false, 'login': false};
    }
  }

  resendOTPtoUser(String mobileNo, String type) async {
    final url = '${webApi['domain']}${endPoint['resendOTPtoUser']}';
    Map body = {'mobileNo': mobileNo, "type": type};
    try {
      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: body,
      );

      return response['result']['type'];
    } catch (error) {
      return {'success': false, 'login': false};
    }
  }

  verifyOTPofUser(String mobileNo, String otp) async {
    final url = '${webApi['domain']}${endPoint['verifyOTPofUser']}';
    Map body = {'mobileNo': mobileNo, "otp": otp};
    try {
      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: body,
      );

      return response['result']['type'];
    } catch (error) {
      return {'success': false, 'login': false};
    }
  }

  // get app config from DBDB
  getAppConfig(List<String> types) async {
    final url = '${webApi['domain']}${endPoint['getAppConfigs']}';

    try {
      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: {"types": types},
      );
      if (response['success']) {
        (response['result'] as List).forEach((config) {
          if (config['type'].contains("user_availableLanguages")) {
            availableLanguages = config['value'];
          } else if (config['type'].contains("user-")) {
            // selectedLanguage = config['value'];
          } else if (config['type'] == 'delete_feature') {
            deleteFeature = Platform.isAndroid
                ? config['value']['android']
                : config['value']['iOS'];
          } else if (config['type'] == 'Razorpay') {
            razorpayId = config['value'];
          } else if (config['type'] == 'helpAndSuppWhatsApp') {
            helpAndSuppWhatsApp = config['value'];
          }
        });
      }
      return response;
      //
    } catch (error) {
      return {'success': false, 'message': 'Failed to get data'};
    }
  }

  setLanguageInStorage(String language) async {
    await storage.ready;
    storage.setItem('language', json.encode({"language": language}));
    notifyListeners();
  }

  Future login({required String query}) async {
    // String? fcmToken = await FirebaseMessaging.instance.getToken();
    // if (fcmToken != null && fcmToken != '') {
    //   query += '&fcmToken=$fcmToken';
    // }

    try {
      final url = '${webApi['domain']}${endPoint['login']}$query';
      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
      );

      if (response['success'] && response['login']) {
        user = User.jsonToUser(
          response['result'],
          accessToken: response['accessToken'],
        );

        // user.fcmToken = fcmToken ?? '';

        await storage.ready;
        await storage.setItem(
          'accessToken',
          json.encode({"token": user.accessToken, "phone": user.phone}),
        );
      }
      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'login': false};
    }
  }

  Future register({
    required Map<String, String> body,
    required Map<String, String> files,
  }) async {
    // String? fcmToken = await FirebaseMessaging.instance.getToken();
    // if (fcmToken != null && fcmToken != '') {
    //   body['fcmToken'] = fcmToken;
    // }

    try {
      final url = '${webApi['domain']}${endPoint['register']}';
      final response = await RemoteServices.formDataRequest(
        method: 'POST',
        url: url,
        body: body,
        files: files,
      );

      if (response['success']) {
        user = User.jsonToUser(
          response['result'],
          accessToken: response['accessToken'],
        );

        // user.fcmToken = fcmToken ?? '';

        await storage.ready;
        await storage.setItem(
          'accessToken',
          json.encode({"token": user.accessToken, "phone": user.phone}),
        );
      }
      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedToRegister'};
    }
  }

  Future editProfile({
    required Map<String, String> body,
    required Map<String, String> files,
    // bool isLocationActive = true,
    // bool isNotificationActive = true,
  }) async {
    try {
      // body['isLocationActive'] = isLocationActive.toString();
      // body['isNotificationActive'] = isNotificationActive.toString();

      final url = '${webApi['domain']}${endPoint['editProfile']}';
      final response = await RemoteServices.formDataRequest(
        method: 'PUT',
        url: url,
        body: body,
        files: files,
        accessToken: user.accessToken,
      );

      if (response['success']) {
        if (body['isLocationAllowed'] != null) {
          user.isLocationAllowed = body['isLocationAllowed'] == 'true';
        } else if (body['isNotificationAllowed'] != null) {
          user.isNotificationAllowed = body['isNotificationAllowed'] == 'true';
        } else {
          user = User.jsonToUser(
            response['result'],
            accessToken: user.accessToken,
          );
        }
      }
      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedToSave'};
    }
  }

  logout() async {
    // user = null;
    // await deleteFCMToken();
    await storage.clear();
    notifyListeners();
    return true;
  }

  deleteFCMToken() async {
    Map<String, String> body = {'fcmToken': user.fcmToken};

    final String url = '${webApi['domain']}${endPoint['deleteFCMToken']}';
    try {
      final response = await RemoteServices.httpRequest(
        method: 'PUT',
        url: url,
        body: body,
        accessToken: user.accessToken,
      );

      if (!response['success']) {
      } else {
        notifyListeners();
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  fetchPolicy(String type) async {
    final url = '${webApi['domain']}${endPoint['getAppConfigs']}';
    try {
      final response = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: {
          "types": [type],
        },
      );
      if (response['success'] && response['result'] != null) {
        return response['result'][0];
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  deleteAccount() async {
    final String url = '${webApi['domain']}${endPoint['deleteAccount']}';
    try {
      final response = await RemoteServices.httpRequest(
        method: 'PUT',
        url: url,
        accessToken: user.accessToken,
      );

      if (!response['success']) {
      } else {}

      notifyListeners();
      return response;
    } catch (e) {
      return {'success': false, 'message': 'deleteAccountFail'};
    }
  }

  updateWalletBalance(num walletBalance) {
    user.walletBalance = walletBalance;
    notifyListeners();
  }
}
