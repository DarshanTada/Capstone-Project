import 'dart:convert';
import '../../http_helper.dart';
import '../model/user_model.dart';
import '../model/preference_model.dart';
import '../model/relation_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../../api.dart';

class AuthProvider with ChangeNotifier {
  final LocalStorage storage = LocalStorage('yolochic');
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
    "phoneNumber": "000-000-0000",
    "otpVerification": "OTP Verification",

    //Home Screen
    "sizeChart": "Size Chart",
    'jeans': 'Jeans',
    'shirts': 'Shirts',
    'pants': 'Pants',
    'home': 'Home',
    'shop': 'Shop',
    'cart': 'Cart',
    'profile': 'Profile',
    'search': 'Search',
    "personalizedSearch": "Personalized Search",
    "all": "ALL",
    "men": "MEN",
    "women": "WOMEN",
    "boys": "BOYS",
    "girls": "GIRLS",
    "popularProducts": "Popular Products",
    "viewAll": "View All",
    "chicStartsHere": "Chic Starts Here",
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

  AuthProvider() {
    // Initialize with guest user by default
    setGuestUser();
  }

  // Debug method to test model creation
  void testModelCreation() {
    try {
      // Test creating models manually
      print('Testing model creation...');

      final testUser = User(
        id: 'test123',
        phoneNumber: '+1234567890',
        email: 'test@example.com',
        role: 'user',
        token: 'test_token',
        isGuest: false,
      );

      print('User model created successfully: ${testUser.id}');

      final testPreference = Preference(
        id: 'pref123',
        userId: 'test123',
        username: 'Test User',
        gender: 'male',
        age: 25,
      );

      print(
        'Preference model created successfully: ${testPreference.username}',
      );
    } catch (error) {
      print('Error testing model creation: $error');
    }
  }

  setGuestUser() {
    user = User(isGuest: true, id: '');
  }

  // Load user from shared preferences
  Future<void> loadUserFromPrefs() async {
    try {
      final savedUser = await UserPrefs.loadFromPrefs();
      if (savedUser != null) {
        user = savedUser;
        notifyListeners();
      } else {
        // If no saved user, set as guest
        setGuestUser();
      }
    } catch (error) {
      print('Error loading user from preferences: $error');
      // Fallback to guest user
      setGuestUser();
    }
  }

  // Check if user is logged in
  bool get isLoggedIn {
    try {
      return !user.isGuest && user.id != null && user.id!.isNotEmpty;
    } catch (error) {
      print('Error checking isLoggedIn: $error');
      return false;
    }
  }

  // Get active preference (either from relation profile or user's own preference)
  Preference? get activePreference {
    try {
      return user.activePreference;
    } catch (error) {
      print('Error getting activePreference: $error');
      return null;
    }
  }

  // Helper method to update only preference fields
  Future<Map<String, dynamic>> updatePreference({
    String? username,
    String? gender,
    int? age,
    double? height,
    String? bodyType,
    String? skinTone,
    List<String>? style,
    List<String>? occasion,
    List<String>? festivals,
    List<String>? colorTones,
    String? size,
    String? undertone,
    String? userPhotoBase64,
    String? userPhotoContentType,
    String? avatarURL,
  }) async {
    if (!isLoggedIn) {
      return {'status': false, 'message': 'User not logged in'};
    }

    return await updateUser(
      token: user.token!,
      username: username,
      gender: gender,
      age: age,
      height: height,
      bodyType: bodyType,
      skinTone: skinTone,
      style: style,
      occasion: occasion,
      festivals: festivals,
      colorTones: colorTones,
      size: size,
      undertone: undertone,
      userPhotoBase64: userPhotoBase64,
      userPhotoContentType: userPhotoContentType,
      avatarURL: avatarURL,
    );
  }

  // Helper method to update only user account fields
  Future<Map<String, dynamic>> updateUserAccount({
    String? phoneNumber,
    String? email,
    String? role,
  }) async {
    if (!isLoggedIn) {
      return {'status': false, 'message': 'User not logged in'};
    }

    return await updateUser(
      token: user.token!,
      phoneNumber: phoneNumber,
      email: email,
      role: role,
    );
  }

  // void updatePermission({
  //   required String permissionType,
  //   required bool newValue,
  // }) {
  //   if (permissionType == 'location') {
  //     user.isLocationAllowed = newValue;
  //   } else {
  //     user.isNotificationAllowed = newValue;
  //   }
  //   notifyListeners();
  // }

  // API Call
  Future<Map<String, dynamic>> loginUser(
    BuildContext context,
    String phoneNumber,
  ) async {
    final String url = '${webApi['domain']}${endPoint['login']}';
    Map<String, String> body = {'phone_number': phoneNumber};

    try {
      print('Making login request to: $url');
      print('Request body: $body');

      final responseData = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: body,
      );

      print('Raw response data: $responseData');
      print('Response type: ${responseData.runtimeType}');

      // The response is already parsed JSON, not an HttpResult object
      if (responseData['success'] == true) {
        // Debug: Print the structure we're receiving
        print('Login Response Data Structure:');
        print('- data: ${responseData['data']}');
        print('- token: ${responseData['token']}');

        try {
          User userData;

          // Check if response has the expected 'data' structure
          if (responseData['data'] != null) {
            // Use the new structured response
            userData = User.jsonToUser(
              responseData['data'],
              token: responseData['token'],
            );
          } else if (responseData['userId'] != null) {
            // Handle legacy response format with just userId
            print('Using legacy response format with userId');
            userData = User(
              id: responseData['userId'],
              token: responseData['token'],
              phoneNumber: null, // Will be populated later if needed
              email: null,
              role: 'user',
              isGuest: false,
            );
          } else {
            throw Exception('No user data or userId found in response');
          }

          await userData.saveToPrefs();

          // Update the provider's user instance
          user = userData;
          notifyListeners();

          return {
            'status': true,
            'data': userData,
            'isNewUser':
                responseData['isNewUser'] ??
                false, // Pass through the isNewUser flag
          };
        } catch (parseError) {
          print('Error parsing user data: $parseError');
          return {
            'status': false,
            'message': 'Failed to parse user data: $parseError',
          };
        }
      } else {
        return {
          'status': false,
          'message': responseData['message'] ?? 'Login or registration failed',
        };
      }
    } catch (error) {
      print('Login API Error: $error');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error')));
      return {'status': false, 'message': 'Unexpected error occurred: $error'};
    }
  }

  // Update user data including preferences
  Future<Map<String, dynamic>> updateUser({
    required String token,
    String? phoneNumber,
    String? email,
    String? role,
    String? username,
    String? gender,
    int? age,
    double? height,
    String? bodyType,
    String? skinTone,
    List<String>? style,
    List<String>? occasion,
    List<String>? festivals,
    List<String>? colorTones,
    String? size,
    String? undertone,
    String? userPhotoBase64,
    String? userPhotoContentType,
    String? avatarURL,
  }) async {
    final String url = '${webApi['domain']}api/user/updateUser';

    Map<String, dynamic> body = {};

    // Add user fields
    if (phoneNumber != null) body['phone_number'] = phoneNumber;
    if (email != null) body['email'] = email;
    if (role != null) body['role'] = role;

    // Add preference fields
    if (username != null) body['username'] = username;
    if (gender != null) body['gender'] = gender;
    if (age != null) body['age'] = age.toString();
    if (height != null) body['height'] = height.toString();
    if (bodyType != null) body['body_type'] = bodyType;
    if (skinTone != null) body['skin_tone'] = skinTone;
    if (style != null) body['style'] = style;
    if (occasion != null) body['occasion'] = occasion;
    if (festivals != null) body['festivals'] = festivals;
    if (colorTones != null) body['color_tones'] = colorTones;
    if (size != null) body['size'] = size;
    if (undertone != null) body['undertone'] = undertone;
    if (avatarURL != null) body['avartarURL'] = avatarURL;

    // Handle user photo
    if (userPhotoBase64 != null && userPhotoContentType != null) {
      body['userPhoto'] = {
        'base64': userPhotoBase64,
        'contentType': userPhotoContentType,
      };
    }

    try {
      print('Making update request to: $url');
      print('Request body: $body');

      final responseData = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: body,
        accessToken: token,
      );

      print('Update Response data: $responseData');

      if (responseData['success'] == true) {
        // Update the current user with new data
        final updatedUser = User.jsonToUser(responseData['data'], token: token);

        await updatedUser.saveToPrefs();

        // Update the provider's user instance
        user = updatedUser;
        notifyListeners();

        return {'status': true, 'data': updatedUser};
      } else {
        return {
          'status': false,
          'message': responseData['message'] ?? 'Update failed',
        };
      }
    } catch (error) {
      print('Update error: $error');
      return {'status': false, 'message': 'Unexpected error occurred'};
    }
  }

  // Get user by ID (useful for refreshing user data)
  Future<Map<String, dynamic>> getUserById(String userId, String token) async {
    final String url = '${webApi['domain']}api/user/getUserById';

    try {
      print('Making getUserById request to: $url');
      print('Request body: ${{'userId': userId}}');

      final responseData = await RemoteServices.httpRequest(
        method: 'POST',
        url: url,
        body: {'userId': userId},
        accessToken: token,
      );

      print('GetUserById Response data: $responseData');

      if (responseData['success'] == true) {
        final refreshedUser = User.jsonToUser(
          responseData['data'],
          token: token,
        );

        await refreshedUser.saveToPrefs();

        // Update the provider's user instance
        user = refreshedUser;
        notifyListeners();

        return {'status': true, 'data': refreshedUser};
      } else {
        return {
          'status': false,
          'message': responseData['message'] ?? 'Failed to fetch user data',
        };
      }
    } catch (error) {
      print('Get user error: $error');
      return {'status': false, 'message': 'Unexpected error occurred'};
    }
  }

  // refreshUser() async {
  //   final String url = '${webApi['domain']}${endPoint['refreshUser']}';
  //   try {
  //     final response = await RemoteServices.httpRequest(
  //       method: 'GET',
  //       url: url,
  //       accessToken: user.token,
  //     );

  //     if (response['success']) {
  //       user = User.jsonToUser(response['result'], token: user.token);

  //       notifyListeners();
  //     }

  //     notifyListeners();
  //     return response;
  //   } catch (e) {
  //     return {'success': false, 'message': 'failedToRefresh'};
  //   }
  // }

  // fetchMyLocation() async {
  //   late LatLng coord;
  //   final location =
  //       await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.low,
  //       ).catchError((e) {
  //         print(e);
  //       });
  //   coord = LatLng(location.latitude, location.longitude);
  //   user.coordinates = coord;
  //   notifyListeners();
  //   return true;
  // }

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

  // resendOTPtoUser(String mobileNo, String type) async {
  //   final url = '${webApi['domain']}${endPoint['resendOTPtoUser']}';
  //   Map body = {'mobileNo': mobileNo, "type": type};
  //   try {
  //     final response = await RemoteServices.httpRequest(
  //       method: 'POST',
  //       url: url,
  //       body: body,
  //     );

  //     return response['result']['type'];
  //   } catch (error) {
  //     return {'success': false, 'login': false};
  //   }
  // }

  // verifyOTPofUser(String mobileNo, String otp) async {
  //   final url = '${webApi['domain']}${endPoint['verifyOTPofUser']}';
  //   Map body = {'mobileNo': mobileNo, "otp": otp};
  //   try {
  //     final response = await RemoteServices.httpRequest(
  //       method: 'POST',
  //       url: url,
  //       body: body,
  //     );

  //     return response['result']['type'];
  //   } catch (error) {
  //     return {'success': false, 'login': false};
  //   }
  // }

  // get app config from DBDB
  // getAppConfig(List<String> types) async {
  //   final url = '${webApi['domain']}${endPoint['getAppConfigs']}';

  //   try {
  //     final response = await RemoteServices.httpRequest(
  //       method: 'POST',
  //       url: url,
  //       body: {"types": types},
  //     );
  //     if (response['success']) {
  //       (response['result'] as List).forEach((config) {
  //         if (config['type'].contains("user_availableLanguages")) {
  //           availableLanguages = config['value'];
  //         } else if (config['type'].contains("user-")) {
  //           // selectedLanguage = config['value'];
  //         } else if (config['type'] == 'delete_feature') {
  //           deleteFeature = Platform.isAndroid
  //               ? config['value']['android']
  //               : config['value']['iOS'];
  //         } else if (config['type'] == 'Razorpay') {
  //           razorpayId = config['value'];
  //         } else if (config['type'] == 'helpAndSuppWhatsApp') {
  //           helpAndSuppWhatsApp = config['value'];
  //         }
  //       });
  //     }
  //     return response;
  //     //
  //   } catch (error) {
  //     return {'success': false, 'message': 'Failed to get data'};
  //   }
  // }

  setLanguageInStorage(String language) async {
    await storage.ready;
    storage.setItem('language', json.encode({"language": language}));
    notifyListeners();
  }

  // Future login({required String query}) async {
  //   // String? fcmToken = await FirebaseMessaging.instance.getToken();
  //   // if (fcmToken != null && fcmToken != '') {
  //   //   query += '&fcmToken=$fcmToken';
  //   // }

  //   try {
  //     final url = '${webApi['domain']}${endPoint['login']}$query';
  //     final response = await RemoteServices.httpRequest(
  //       method: 'GET',
  //       url: url,
  //     );

  //     if (response['success'] && response['login']) {
  //       user = User.jsonToUser(
  //         response['result'],
  //         // token: response['accessToken'],
  //       );

  //       // user.fcmToken = fcmToken ?? '';

  //       await storage.ready;
  //       await storage.setItem(
  //         'accessToken',
  //         json.encode({"token": user.accessToken, "phone": user.phone}),
  //       );
  //     }
  //     notifyListeners();
  //     return response;
  //   } catch (error) {
  //     return {'success': false, 'login': false};
  //   }
  // }

  Future register({
    required Map<String, String> body,
    required Map<String, String> files,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['register']}';
      final response = await RemoteServices.formDataRequest(
        method: 'POST',
        url: url,
        body: body,
        files: files,
      );

      if (response['success']) {
        user = User.jsonToUser(response['result'], token: response['token']);

        await storage.ready;
        await storage.setItem(
          'accessToken',
          json.encode({"token": user.token, "phone": user.phoneNumber}),
        );
      }
      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedToRegister'};
    }
  }

  // Future editProfile({
  //   required Map<String, String> body,
  //   required Map<String, String> files,
  //   // bool isLocationActive = true,
  //   // bool isNotificationActive = true,
  // }) async {
  //   try {
  //     // body['isLocationActive'] = isLocationActive.toString();
  //     // body['isNotificationActive'] = isNotificationActive.toString();

  //     final url = '${webApi['domain']}${endPoint['editProfile']}';
  //     final response = await RemoteServices.formDataRequest(
  //       method: 'PUT',
  //       url: url,
  //       body: body,
  //       files: files,
  //       accessToken: user.token,
  //     );

  //     if (response['success']) {
  //       if (body['isLocationAllowed'] != null) {
  //         user.isLocationAllowed = body['isLocationAllowed'] == 'true';
  //       } else if (body['isNotificationAllowed'] != null) {
  //         user.isNotificationAllowed = body['isNotificationAllowed'] == 'true';
  //       } else {
  //         user = User.jsonToUser(
  //           response['result'],
  //           accessToken: user.accessToken,
  //         );
  //       }
  //     }
  //     notifyListeners();
  //     return response;
  //   } catch (error) {
  //     return {'success': false, 'message': 'failedToSave'};
  //   }
  // }

  logout() async {
    // Clear all user data including preferences and relation profiles
    await UserPrefs.clearPrefs();
    await storage.clear();

    // Reset to guest user
    setGuestUser();
    notifyListeners();
    return true;
  }

  // deleteFCMToken() async {
  //   Map<String, String> body = {'fcmToken': user.fcmToken};

  //   final String url = '${webApi['domain']}${endPoint['deleteFCMToken']}';
  //   try {
  //     final response = await RemoteServices.httpRequest(
  //       method: 'PUT',
  //       url: url,
  //       body: body,
  //       accessToken: user.accessToken,
  //     );

  //     if (!response['success']) {
  //     } else {
  //       notifyListeners();
  //       return;
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  // fetchPolicy(String type) async {
  //   final url = '${webApi['domain']}${endPoint['getAppConfigs']}';
  //   try {
  //     final response = await RemoteServices.httpRequest(
  //       method: 'POST',
  //       url: url,
  //       body: {
  //         "types": [type],
  //       },
  //     );
  //     if (response['success'] && response['result'] != null) {
  //       return response['result'][0];
  //     } else {
  //       return null;
  //     }
  //   } catch (error) {
  //     return null;
  //   }
  // }

  // deleteAccount() async {
  //   final String url = '${webApi['domain']}${endPoint['deleteAccount']}';
  //   try {
  //     final response = await RemoteServices.httpRequest(
  //       method: 'PUT',
  //       url: url,
  //       accessToken: user.token,
  //     );

  //     if (!response['success']) {
  //     } else {}

  //     notifyListeners();
  //     return response;
  //   } catch (e) {
  //     return {'success': false, 'message': 'deleteAccountFail'};
  //   }
  // }

  // updateWalletBalance(num walletBalance) {
  //   user.walletBalance = walletBalance;
  //   notifyListeners();
  // }
}
