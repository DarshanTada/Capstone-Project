// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../authModule/providers/auth_provider.dart';
import '../colors.dart';
import '../common_functions.dart';
import 'circular_loader.dart';

class MyDialogBox extends StatefulWidget {
  final String header;
  final String confirmDescription;
  final Function rightBtnFunc;
  final String rightBtnTxt;
  final Function leftBtnFunc;
  final String leftBtnTxt;
  final bool highlightRight;

  const MyDialogBox({
    super.key,
    required this.header,
    required this.confirmDescription,
    required this.rightBtnFunc,
    required this.rightBtnTxt,
    required this.leftBtnFunc,
    required this.leftBtnTxt,
    this.highlightRight = true,
  });

  @override
  State<MyDialogBox> createState() => MyDialogBoxState();
}

class MyDialogBoxState extends State<MyDialogBox> {
  double dW = 0.0;
  double tS = 0.0;
  Map language = {};

  bool isSaving = false;

  Widget button(String text, Function function, bool highlight) => Container(
    decoration: BoxDecoration(
      gradient: highlight ? LinearGradient(colors: gradientColors) : null,
      borderRadius: BorderRadius.circular(10),
      border: !highlight
          ? Border.all(width: 1, color: Theme.of(context).primaryColor)
          : null,
    ),
    child: SizedBox(
      width: dW * 0.32,
      height: dW * 0.11,
      child: isSaving && highlight
          ? circularForButton(dW * 0.045, sW: 2)
          : TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(
                  navigatorKey as BuildContext,
                ).primaryColor,
              ),
              onPressed: isSaving ? () {} : () => function(),
              child: Text(
                language[text],
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: tS * 16,
                  color: highlight
                      ? Colors.white
                      : Theme.of(navigatorKey as BuildContext).primaryColor,
                ),
              ),
            ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 8),
            spreadRadius: 0,
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            offset: const Offset(0, -1),
            spreadRadius: 0,
            blurRadius: 2,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      width: dW * 0.83,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: dW * 0.06,
              right: dW * 0.06,
              top: dW * 0.04,
              bottom: dW * 0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.header,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    letterSpacing: .3,
                    wordSpacing: .1,
                    fontSize: tS * 16,
                    color: darkBlue,
                  ),
                ),
                SizedBox(height: dW * 0.03),
                Text(
                  widget.confirmDescription,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    letterSpacing: .3,
                    wordSpacing: .1,
                    height: 1.7,
                    fontSize: tS * 16,
                    color: const Color(0xFF5E5E5E),
                  ),
                ),
                SizedBox(height: dW * 0.07),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    button(
                      widget.leftBtnTxt,
                      () => widget.leftBtnFunc(),
                      !widget.highlightRight,
                    ),
                    button(
                      widget.rightBtnTxt,
                      () => widget.rightBtnFunc(),
                      widget.highlightRight,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
