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
        "enterMobileNumber": "Enter mobile number",
        "weWillSendYouAn": "We will send you an ",
        "oneTimePassword": "One Time Password ",
        "onThisMobileNumber": "on this mobile number",
        "mobileNumber": "Mobile number",
        "searchCafes": "Search cafes",
        "noCafesFound": "No cafes found",
        "selectGender": "Select Gender",
        "outOfAttempts": "You are out of attempts. Please Try again later",
        "in": "in",
        "didntGetOtp": "Didn't receive the OTP? ",
        "getOtp": "Get OTP",
        "orLoginWith": "or Login with",
        "continueAsGuest": "Continue as guest",
        "otpVerification": "OTP verification",
        "enterTheOtpSendTo": "Enter the OTP send to",
        "didn’tReceiveTheOtp?": "Didn’t receive the OTP? ",
        "resend": "RESEND ",
        "in00:30Sec": "in 00:30 Sec",
        "byContinuingYouAgreeToThe": "By continuing you agree to the ",
        "tos": "Terms of services ",
        "message": "message",
        "and": "and ",
        "privacyPolicy": "Privacy policy",
        "continue": "Continue",
        "welcome!": "Welcome!",
        "letsMakeAProfile": "Let's make a profile",
        "fullName": "Full name",
        "enterFullName": "Enter full name",
        "emailAddress": "Email Address",
        "enterEmailAddress": "Enter email address",
        "birthday": "Birthday",
        "enterBirthday": "Enter birthday",
        "gender": "Gender",
        "selectACafe": "Select A Cafe",
        "srchByLocOrCafe": "Search by location or cafe name",
        "favourites": "Favourites",
        "nearbyCafes": "Nearby Cafes",
        "locationAccessPermissionIsRequired":
            "Location access permission is required.",
        "pleaseEnableYourLocationToFindTheNearestIteehaCafe":
            "Please enable your location to find the nearest iteeha cafe",
        "allowLocationAccess": "Allow location access",
        "enterLocationManually": "Enter location manually",
        "registerSuccess": "User registered",
        "failedToRegister": "Failed to signup",
        "failedGetCafe": "Failed to get cafe",
        "termsOfServicesDescription":
            "These Terms of Use (${'"Terms"'}) govern the access or use by you, an individual, from within India of applications, websites, content, products, and services (the “Services”) made available by UrbanClap Technologies India Private Limited, a private limited company established in India, having its registered office at R-5, PNR House, Green Park Market, New Delhi- 110016 and head office at Plot No 416, Udyog Vihar, Phase 3, Sector 20, Gurugram, Haryana - 122016 (“ Urban Company”). PLEASE READ THESE TERMS CAREFULLY BEFORE ACCESSING OR USING THE SERVICES. Your access and use of the Services constitutes your agreement to be bound by these Terms, which establishes a contractual relationship between you and Urban Company. If you do not agree to these Terms, you may not access or use the Services. These Terms expressly supersede prior written agreements with you. Supplemental terms may apply to certain Services, such as policies for a particular event, activity or promotion, and such supplemental terms will be disclosed to you in connection with the applicable Services. Supplemental terms are in addition to, and shall be deemed a part of, the Terms for the purposes of the applicable Services. Supplemental terms shall prevail over these Terms in the event of a conflict with respect to the applicable Services. Urban Company may restrict you from accessing or using the Services, or any part of them, immediately, without notice, in circumstances where Urban Company reasonably suspects that: you have, or are likely to, breach these Terms; and/or you do not, or are likely not to, qualify, under applicable law or the standards and policies of Urban Company and its affiliates, to access and use the Services.",
        "privacyPolicyDescription":
            "These Terms of Use (${'"Terms"'}) govern the access or use by you, an individual, from within India of applications, websites, content, products, and services (the “Services”) made available by UrbanClap Technologies India Private Limited, a private limited company established in India, having its registered office at R-5, PNR House, Green Park Market, New Delhi- 110016 and head office at Plot No 416, Udyog Vihar, Phase 3, Sector 20, Gurugram, Haryana - 122016 (“ Urban Company”). PLEASE READ THESE TERMS CAREFULLY BEFORE ACCESSING OR USING THE SERVICES. Your access and use of the Services constitutes your agreement to be bound by these Terms, which establishes a contractual relationship between you and Urban Company. If you do not agree to these Terms, you may not access or use the Services. These Terms expressly supersede prior written agreements with you. Supplemental terms may apply to certain Services, such as policies for a particular event, activity or promotion, and such supplemental terms will be disclosed to you in connection with the applicable Services. Supplemental terms are in addition to, and shall be deemed a part of, the Terms for the purposes of the applicable Services. Supplemental terms shall prevail over these Terms in the event of a conflict with respect to the applicable Services. Urban Company may restrict you from accessing or using the Services, or any part of them, immediately, without notice, in circumstances where Urban Company reasonably suspects that: you have, or are likely to, breach these Terms; and/or you do not, or are likely not to, qualify, under applicable law or the standards and policies of Urban Company and its affiliates, to access and use the Services. Urban Company may terminate these Terms or any Services with respect to you, or generally cease offering or deny access to the Services or any portion thereof: immediately, where Urban Company reasonably suspects that: you have, or are likely to, materially breach these Terms; and/or you do not, or are likely not to, qualify, under applicable law or the standards and policies of Urban Company and its affiliates, to access and use the Services; or on 30 days' written notice to you, where Urban Company, acting reasonably, terminates these Terms or any Services for any legitimate business, legal or regulatory reason. Without limiting its other rights under these Terms, Urban Company may immediately restrict or deactivate your access to the Services if you breach the Community Guidelines at any time. You may terminate these Terms at any time, for any reason. Urban Company may and the any policies ",
//Home Screen
        "home": "Home",
        "wallet": "Wallet",
        "rewards": "Rewards",
        "more": "More",
        "login": "Login",
        "photos": "Photos",
        "goodMorning": "Good Morning, ",
        "goodAfternoon": "Good Afternoon, ",
        "goodEvening": "Good Evening, ",
        "selectAStore": "Select A Store",
        "reward:-": "Reward :- ",
        "totalSavings": "Total Savings",
        "exclusiveOffers": "Exclusive Offers",
        "referAFriend": "Refer a Friend",
        "1freeBeverageAsACompletionReward":
            "1 Free beverage as a completion reward",
        "notifications": "Notifications",
        "newNotifications": "New Notifications",
        "viewMore": "View More",
        "failedToGetTransactionCount": "Failed to get transaction count",

// Wallet Screen
        "currentBalance": "Current Balance",
        "scanBarcode": "Scan Barcode",
        "transactionHistory": "Transaction History",
        "addMoney": "Add Money",
        "enterAmount": "Enter Amount",
        "enterAmountToAdd": "Enter amount to add",
        "clear": "clear",
        "payNow": "Pay Now",
        "noTransactionsYet": "No transactions yet !",
        "viewAll": "View all",
        "transactions": "Transactions",
        "scanAndPay": "Scan the barcode and pay at the store",

// Offer Screen
        "offerDetails": "Offer Details",
        "terms&Condition": "Terms & Condition",
        "share": "Share",

// Cafe Images Screen
        "images": "Images",

// Cafe Details Screen
        "cafeDetails": "Cafe Details",
        "menu": "Menu",
        "amenities": "Amenities",
        "getDirection": "Get Direction",
        "cafeTimings": "Cafe Timings",
        "open": "OPEN",
        "closed": "CLOSED",
        "opens": "Opens ",
        "closes": "Closes ",

// All Cafes Screen
        "ourCafes": "Our Cafes",
        "noFavouriteCafes": "No Favourite Cafes",

// Loyalty Levels / reward Screen
        "failedGetLoyaltyLevels": "failed to get loyalty levels",
        "loyaltyProgramBenefits": "Loyalty Program Benefits",
        "ongoing": "Ongoing",
        "benefits": "Benefits",
        "birthdayBeverage": "Birthday\nbeverage",
        "loyaltyPoints": "Loyalty\npoints",
        "1FreeBeveragesAfter": "1 Free\nbeverages\nAfter",
        "discountOnFood": "Discount on\nFood",
        "purchase": "Purchase",
        "loyaltyProgramLevels": "Loyalty Program Levels",
        "level": "Level",
        "forLevel": "For Level",
        "toMaintainLevel": "To Maintain Level",
        "note:-": "Note:-",
        "validTill": "Valid till",
        "noOfrsAvailbl": "No Offers Available",

// More Screen
        "help&Support": "Help & Support",
        "permissions": "Permissions",
        "logout": "Logout",
        "no": "NO",
        "yes": "Yes",
        "editProfile": "Edit Profile",
        "save": "Save",
        "location": "Location",
        "failedToUpdate": "Failed To Update",
        "wantToLogout": "Are you sure you want to logout?",

        // Faqs screen
        "faqsTopics": "FAQ’s Topics",
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
        user =
            User.jsonToUser(response['result'], accessToken: user.accessToken);

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
    final location = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low)
        .catchError((e) {
      print(e);
    });
    coord = LatLng(location.latitude, location.longitude);
    user.coordinates = coord;
    notifyListeners();
    return true;
  }

  sendOTPtoUser(String mobileNo, {bool business = false}) async {
    final url = '${webApi['domain']}${endPoint['sendOTPtoUser']}';
    Map body = {
      'mobileNo': mobileNo,
    };
    try {
      final response = await RemoteServices.httpRequest(
          method: 'POST', url: url, body: body);

      return response;
    } catch (error) {
      return {'success': false, 'login': false};
    }
  }

  resendOTPtoUser(String mobileNo, String type) async {
    final url = '${webApi['domain']}${endPoint['resendOTPtoUser']}';
    Map body = {
      'mobileNo': mobileNo,
      "type": type,
    };
    try {
      final response = await RemoteServices.httpRequest(
          method: 'POST', url: url, body: body);

      return response['result']['type'];
    } catch (error) {
      return {'success': false, 'login': false};
    }
  }

  verifyOTPofUser(String mobileNo, String otp) async {
    final url = '${webApi['domain']}${endPoint['verifyOTPofUser']}';
    Map body = {
      'mobileNo': mobileNo,
      "otp": otp,
    };
    try {
      final response = await RemoteServices.httpRequest(
          method: 'POST', url: url, body: body);

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
          method: 'POST', url: url, body: {"types": types});
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
      final response =
          await RemoteServices.httpRequest(method: 'GET', url: url);

      if (response['success'] && response['login']) {
        user = User.jsonToUser(
          response['result'],
          accessToken: response['accessToken'],
        );

        // user.fcmToken = fcmToken ?? '';

        await storage.ready;
        await storage.setItem(
            'accessToken',
            json.encode({
              "token": user.accessToken,
              "phone": user.phone,
            }));
      }
      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'login': false};
    }
  }

  Future register(
      {required Map<String, String> body,
      required Map<String, String> files}) async {
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
            json.encode({
              "token": user.accessToken,
              "phone": user.phone,
            }));
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
      final response =
          await RemoteServices.httpRequest(method: 'POST', url: url, body: {
        "types": [type]
      });
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
