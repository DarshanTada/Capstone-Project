// ignore_for_file: unused_import, depend_on_referenced_packages

import 'package:clothing_app_frontend/cartModule/screens/cart_screen.dart';
import 'package:clothing_app_frontend/categoryModule/screens/category_screen.dart';
import 'package:clothing_app_frontend/homeModule/screens/home_screen.dart';
import 'package:clothing_app_frontend/profileModule/screens/profile_screen.dart';
import 'package:clothing_app_frontend/searchModule/screens/search_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:clothing_app_frontend/authModule/model/user_model.dart';

import '../../navigation/arguments.dart';
import '../../main.dart';
import '../authModule/providers/auth_provider.dart';
import '../colors.dart';
import '../common_functions.dart';
import '../navigation/navigators.dart';
import '../navigation/routes.dart';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'asset_svg_icon.dart';
import 'gradient_widget.dart';
import 'in_app_browser_screen.dart';

class BottomNavBar extends StatefulWidget {
  final BottomNavArgumnets args;
  const BottomNavBar({super.key, required this.args});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  final LocalStorage storage = LocalStorage('yolochec');

  int _currentIndex = 0;
  bool isLoading = false;

  double dW = 0;
  double dH = 0;
  double tS = 0;
  Map language = {};

  String? notificationId;
  final unselectedColor = const Color(0xFF969698);
  // User user;

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  initFcm() async {
    // FirebaseMessaging messaging = FirebaseMessaging.instance;

    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );

    // if (settings.authorizationStatus == AuthorizationStatus.authorized ||
    //     settings.authorizationStatus == AuthorizationStatus.provisional) {
    //   LocalNotificationService.initialize(
    //       navigatorKey.currentContext!, handleNotificationClick);

    //   FirebaseMessaging.onBackgroundMessage(
    //       (RemoteMessage message) => handleNotificationClick(message));

    //   FirebaseMessaging.instance.getInitialMessage().then((message) {
    //     if (message != null) {
    //       message.data['notificationId'] = message.messageId;
    //       handleNotificationClick(message.data);
    //     }
    //   });

    //   FirebaseMessaging.onMessage.listen((message) async {
    //     if (message.notification != null) {
    //       message.data['notificationId'] = message.messageId;

    //       LocalNotificationService.display(message);
    //     }
    //   });

    //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //     if (message.notification != null) {
    //       message.data['notificationId'] = message.messageId;
    //       handleNotificationClick(message.data);
    //     }
    //   });
    //   awaitStoreReady();
    // }
  }

  // awaitStoreReady() async {
  //   await storage.ready;
  // }

  // handleNotificationClick(data) async {
  //   final notificationIdString = storage.getItem('fcmNotificationIds');
  //   if (notificationIdString != null) {
  //     notificationId = json.decode(notificationIdString);
  //     if (notificationId == data['notificationId']) {
  //       return;
  //     }
  //   }
  //   storage.setItem('fcmNotificationIds', json.encode(data['notificationId']));

  //   switch (data['type']) {
  //     // case 'Signup':
  //     //   pushAndRemoveUntil(NamedRoute.bottomNavBarScreen,
  //     //       arguments: BottomNavArgumnets(index: 0));
  //     //   break;
  //   }
  // }

  Future<bool> _willPopCallback() async {
    // customDialogBox(
    //   okBtnPress: () {
    //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    //     return true;
    //   },
    //   cancelBtnPress: () {
    //     Navigator.of(context).pop();
    //     return true;
    //   },
    //   context: context,
    //   title: language['alert'],
    //   titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    //   content: language['wantToExit'],
    //   okBtnText: language['yes'],
    //   cancelBtnText: language['no'],
    //   cancelBtnStyle: const TextStyle(color: Colors.blue),
    // );

    if (_currentIndex == 0) {
      return true;
    } else {
      setState(() {
        _currentIndex = 0;
      });
      return true;
    }
  }

  List<Widget> get _children => [
    HomeScreen(),
    const CategoryScreen(),
    const SearchScreen(),
    MyCartScreen(),
    ProfileScreen(),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  Widget navbarItemContent({
    required String label,
    required String svg,
    required String colouredsvg,
    required bool isSelected,
  }) => Container(
    margin: iOSCondition(dH)
        ? EdgeInsets.only(top: dW * 0.02)
        : EdgeInsets.symmetric(vertical: dW * 0.048),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isSelected
                ? AssetSvgIcon(colouredsvg, height: 26)
                : AssetSvgIcon(svg, height: 26),
            SizedBox(width: dW * 0.025),
            isSelected
                ? Text(
                    label,
                    style: TextStyle(
                      color: const Color(0xff272559),
                      // fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: tS * 10,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      // fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: tS * 10,
                      color: lightGray,
                    ),
                  ),
          ],
        ),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.args.index ?? 0;

    // initFcm();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    dH = MediaQuery.of(context).size.height;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Scaffold(
      
      // backgroundColor: Colors.white,
      extendBody: true, // This allows body to extend behind the bottom nav
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _children[_currentIndex], // Remove SafeArea and Padding wrapper
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          bottom: dW * 0.05,
          left: dW * 0.04,
          right: dW * 0.04,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(0, 4),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(width: 1, color: Colors.grey[200]!),
          color: Colors.white, // Make it transparent
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            backgroundColor: Colors.white.withOpacity(
              0.9,
            ), // Semi-transparent white
            elevation: 0,
            currentIndex: _currentIndex,
            onTap: onTapped,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).primaryColor,
            items: [
              BottomNavigationBarItem(
                icon: navbarItemContent(
                  label: language['home'] ?? 'Home',
                  colouredsvg: 'coloured_home',
                  svg: 'home',
                  isSelected: _currentIndex == 0,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: navbarItemContent(
                  label: language['shop'] ?? 'Shop',
                  colouredsvg: 'coloured_wallet',
                  svg: 'wallet',
                  isSelected: _currentIndex == 1,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: navbarItemContent(
                  label: language['search'] ?? 'Search',
                  colouredsvg: 'search',
                  svg: 'search',
                  isSelected: _currentIndex == 2,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: navbarItemContent(
                  label: language['cart'] ?? 'Cart',
                  colouredsvg: 'coloured_rewards',
                  svg: 'reward',
                  isSelected: _currentIndex == 3,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: navbarItemContent(
                  label: language['profile'] ?? 'Profile',
                  colouredsvg: 'coloured_more',
                  svg: 'more',
                  isSelected: _currentIndex == 4,
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
