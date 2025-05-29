// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../authModule/providers/auth_provider.dart';
import '../colors.dart';
import '../common_functions.dart';

class MyTextButton extends StatelessWidget {
  //
  final String text;
  final double hF;
  final double hPF;
  final Color color;
  final Function? onPressed;

  MyTextButton({
    super.key,
    required this.text,
    this.hF = .0,
    this.hPF = 0.03,
    required this.color,
    this.onPressed,
  });

  Map language = {};
  double dW = 0.0;
  double tS = 0.0;

  TextTheme get textTheme => Theme.of(bContext).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    return TextButton(
      onPressed: onPressed != null ? () => onPressed!() : null,
      style: TextButton.styleFrom(
        fixedSize: Size.fromHeight(dW * hF),
        backgroundColor: white,
        padding: EdgeInsets.symmetric(horizontal: dW * hPF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: textTheme.displayMedium!.copyWith(
            fontSize: tS * 14,
            color: color,
            letterSpacing: .3,
          ),
        ),
      ),
    );
  }
}
