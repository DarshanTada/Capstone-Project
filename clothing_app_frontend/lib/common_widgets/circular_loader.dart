import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class CircularLoader extends StatelessWidget {
  final double android;
  final double iOS;
  final Color? color;

  const CircularLoader({
    super.key,
    this.android = 0.07,
    this.iOS = 12.0,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    final dW = MediaQuery.of(context).size.width;

    return Platform.isIOS
        ? CupertinoActivityIndicator(
            radius: iOS,
            color: color,
          )
        : Center(
            child: SizedBox(
              height: dW * android,
              width: dW * android,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                    color ?? Theme.of(context).primaryColor),
              ),
            ),
          );
  }
}

Widget circularForButton(double width,
    {Color color = Colors.white, double sW = 2.3}) {
  return Center(
    child: SizedBox(
      height: width,
      width: width,
      child: CircularProgressIndicator(
        strokeWidth: sW,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    ),
  );
}

Widget lazyLoader(double dW, [double tpf = 0.06]) {
  return Padding(
    padding: EdgeInsets.only(top: dW * tpf, bottom: dW * 0.1),
    child: const Center(child: CircularLoader()),
  );
}
