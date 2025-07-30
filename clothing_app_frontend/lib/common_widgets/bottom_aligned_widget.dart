// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../authModule/providers/auth_provider.dart';
import '../common_functions.dart';
import 'custom_button.dart';

class BottomAlignedWidget extends StatelessWidget {
  final double dW;
  final double dH;
  final Widget? child;
  final Function? onPressed;
  final bool isLoading;
  final String buttonText;
  final double keyBoardHeight;
  final Color bkgColor;
  final Widget? topWidget;

  BottomAlignedWidget({
    super.key,
    required this.dW,
    required this.dH,
    this.child,
    this.onPressed,
    this.buttonText = '',
    this.keyBoardHeight = 0,
    this.isLoading = false,
    this.bkgColor = Colors.white,
    this.topWidget,
  });

  Map language = {};

  @override
  Widget build(BuildContext context) {
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      width: dW,
      decoration: BoxDecoration(color: bkgColor, boxShadow: [
        if (bkgColor == Colors.white)
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, -1),
            spreadRadius: 0,
            blurRadius: 5,
          )
      ]),
      padding: EdgeInsets.only(
        top: dW * 0.015,
        bottom: dW *
            (keyBoardHeight > 0
                ? 0.025
                : iOSCondition(dH)
                    ? 0.06
                    : 0.04),
        left: dW * horizontalPaddingFactor,
        right: dW * horizontalPaddingFactor,
      ),
      child: Column(
        children: [
          if (topWidget != null) topWidget!,
          child ??
              CustomButton(
                width: dW * 0.9,
                height: dW * 0.14,
                onPressed: onPressed,
                isLoading: isLoading,
                buttonText: buttonText,
              ),
        ],
      ),
    );
  }
}
