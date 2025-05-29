import 'package:flutter/material.dart';

import '../colors.dart';
import 'circular_loader.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Function? onPressed;
  final String buttonText;
  final Color? buttonColor;
  final Color? diabledButtonColor;
  final TextStyle? buttonTextSyle;
  final bool isLoading;
  final double bottomMargin;
  final Widget? child;
  final double elevation;
  final Color? borderColor;

  const CustomButton(
      {super.key,
      required this.width,
      required this.height,
      this.radius = 10,
      this.onPressed,
      required this.buttonText,
      this.buttonColor,
      this.diabledButtonColor,
      this.buttonTextSyle,
      this.bottomMargin = 0,
      this.isLoading = false,
      this.child,
      this.elevation = 2,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    final double tS = MediaQuery.of(context).textScaleFactor;
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: ElevatedButton(
        onPressed:
            onPressed == null ? null : () => isLoading ? () {} : onPressed!(),
        style: ElevatedButton.styleFrom(
            elevation: elevation,
            backgroundColor: buttonColor ?? Theme.of(context).primaryColor,
            disabledBackgroundColor: diabledButtonColor ?? disabledColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
                side: borderColor != null
                    ? BorderSide(color: borderColor!)
                    : BorderSide.none)),
        child: Center(
          child: isLoading
              ? circularForButton(width * 0.07)
              // ? SizedBox(
              //     height: width * 0.055,
              //     width: width * 0.055,
              //     child: circularForButton(width)
              //  CircularProgressIndicator(
              //   strokeWidth: 2.5,
              //   color: Colors.white,
              // ))
              : child ??
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      buttonText,
                      style: buttonTextSyle ??
                          Theme.of(context).textTheme.displayLarge!.copyWith(
                                fontSize: tS * 18,
                                color: Colors.white,
                              ),
                    ),
                  ),
        ),
      ),
    );
  }
}
