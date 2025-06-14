import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import '../colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Icon? backIcon;
  final double dW;
  final double elevation;
  final Function? actionMethod;
  final List<Widget>? actions;
  final Color? bgColor;
  final bool? centerTitle;
  final int fontSize;

  CustomAppBar({
    super.key,
    this.title = '',
    this.leading,
    this.fontSize = 18,
    this.backIcon,
    required this.dW,
    this.elevation = 0.0,
    this.actionMethod,
    this.actions,
    this.bgColor,
    this.centerTitle,
  });

  final double topMargin = Platform.isIOS ? 0 : 0.03;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Container(
      margin: EdgeInsets.only(top: dW * topMargin),
      child: AppBar(
        centerTitle: true,
        backgroundColor: bgColor ?? Colors.white,
        elevation: elevation,
        leadingWidth: dW * 0.21,
        leading: leading ??
            GestureDetector(
              onTap: () {
                if (actionMethod != null) {
                  actionMethod!();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Container(
                // padding:
                //     Platform.isIOS ? EdgeInsets.only(right: dW * 0.005) : null,
                margin: EdgeInsets.only(
                  left: dW * 0.06,
                  right: dW * 0.03,
                  top: dW * 0.012,
                  bottom: dW * 0.013,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Center(
                  child: backIcon ??
                      (Platform.isIOS
                          ? const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 22, color: backButtonColor)
                          : const Icon(Icons.arrow_back,
                              color: backButtonColor)),
                ),
              ),
            ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: appBarTitleColor,
                fontSize: textScale * fontSize,
              ),
        ),
        titleSpacing: 0,
        actions: actions ?? [],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(dW * (0.145 + topMargin));
}
