import 'package:flutter/material.dart';
import 'storage_manager.dart';

// 'Outfit'

class ThemeNotifier with ChangeNotifier {
//
  final lightTheme = ThemeData(
    primaryColor: const Color(0xFF0197FC),
    brightness: Brightness.light,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: Colors.white,
    dividerColor: Colors.white54,
    disabledColor: Colors.purple[300],
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.w600),
      displayMedium: TextStyle(fontWeight: FontWeight.w500),
      displaySmall: TextStyle(fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(fontFamily: 'Inria Serif', fontWeight: FontWeight.w400)
    ), 
    // colorScheme: ColorScheme(background: Colors.white),
  );

  final darkTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    fontFamily: 'Outfit',
    disabledColor: Colors.purple[300],
    dividerColor: Colors.black12,
    textTheme: const TextTheme(), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(background: const Color(0xFF212121)),
  );

  ThemeData? _themeData;
  ThemeData? getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
