// ignore_for_file: prefer_const_constructors_in_immutables, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../authModule/providers/auth_provider.dart';
import '../../colors.dart';

import '../../common_functions.dart';
import '../../main.dart' hide navigatorKey;

class SingleResponseDialogBox extends StatefulWidget {
  final String title;
  final String description;
  final Function onPressed;
  final String btnText;

  SingleResponseDialogBox({
    Key? key,
    required this.title,
    required this.description,
    required this.onPressed,
    required this.btnText,
  }) : super(key: key);

  @override
  State<SingleResponseDialogBox> createState() =>
      _SingleResponseDialogBoxState();
}

class _SingleResponseDialogBoxState extends State<SingleResponseDialogBox> {
  double dW = 0.0;
  double tS = 0.0;
  Map language = {};

  Widget button() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: gradientColors),
      borderRadius: BorderRadius.circular(10),
    ),
    child: SizedBox(
      width: dW * 0.32,
      height: dW * 0.11,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(navigatorKey  as BuildContext).primaryColor,
        ),
        onPressed: () => widget.onPressed(),
        child: Text(
          widget.btnText,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: tS * 16,
            color: Colors.white,
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
                  widget.title,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    letterSpacing: .3,
                    wordSpacing: .1,
                    fontSize: tS * 16,
                    color: redColor,
                  ),
                ),
                SizedBox(height: dW * 0.03),
                Text(
                  widget.description,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    letterSpacing: .2,
                    height: 1.4,
                    fontSize: tS * 14,
                    color: grayColor,
                  ),
                ),
                SizedBox(height: dW * 0.07),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [button()],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
