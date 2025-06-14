// ignore_for_file: must_be_immutable, depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../authModule/providers/auth_provider.dart';
import 'asset_svg_icon.dart';

class SearchBoxWidget extends StatelessWidget {
  final String leadingSvg;
  String trailingSvg;
  final Function onTap;
  final String searchBarText;
  final Color bgColor;
  final Color borderColor;
  final double vPadding;

  SearchBoxWidget({
    super.key,
    this.leadingSvg = 'search_icon',
    this.trailingSvg = '',
    required this.onTap,
    this.searchBarText = 'Search....',
    this.bgColor = Colors.transparent,
    this.borderColor = const Color(0xFFBFC0C8),
    this.vPadding = 0.032,
  });

  double dW = 0.0;
  double tS = 0.0;
  Map language = {};

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: dW,
        padding: EdgeInsets.symmetric(
            vertical: dW * vPadding, horizontal: dW * 0.04),
        margin: EdgeInsets.only(bottom: dW * 0.05, top: dW * 0.03),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: borderColor),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: dW * 0.03),
              child: AssetSvgIcon(leadingSvg),
            ),
            Expanded(
              child: Text(
                searchBarText,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: tS * 14,
                    ),
              ),
            ),
            if (trailingSvg != '') AssetSvgIcon(trailingSvg),
          ],
        ),
      ),
    );
  }
}
