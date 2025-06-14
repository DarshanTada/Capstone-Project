import 'package:flutter/material.dart';

class ScreenLayoutValues {
  final double dW;
  final double dH;
  final double tS;
  final TextTheme textTheme;
  final Map language;
  final void Function(bool) setLoading;
  final void Function(String message, {Color color, int duration}) showSnackBar;

  ScreenLayoutValues({
    required this.dW,
    required this.dH,
    required this.tS,
    required this.textTheme,
    required this.language,
    required this.setLoading,
    required this.showSnackBar,
  });
}
