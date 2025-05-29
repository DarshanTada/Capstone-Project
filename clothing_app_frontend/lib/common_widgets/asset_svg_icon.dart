// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AssetSvgIcon extends StatelessWidget {
  final String iconName;
  final Color? color;
  final double? height;
  final double? width;
  final Function? onTap;
  const AssetSvgIcon(
    this.iconName, {
    super.key,
    this.color,
    this.height,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap == null ? null : () => onTap!(),
      child: SvgPicture.asset(
        'assets/svgIcons/$iconName.svg',
        color: color,
        height: height,
        width: width,
      ),
    );
  }
}

class CustomAssetImage extends StatelessWidget {
  final String iconName;
  final Color? color;
  final double? height;
  final double? width;
  final Function? onTap;

  const CustomAssetImage(
    this.iconName, {
    super.key,
    this.color,
    this.height,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap == null ? null : () => onTap!(),
      child: Image.asset(
        'assets/svgIcons/$iconName.svg',
        color: color,
        height: height,
        width: width,
      ),
    );
  }
}
