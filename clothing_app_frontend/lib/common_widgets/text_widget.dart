import 'package:flutter/material.dart';
import 'package:clothing_app_frontend/colors.dart';

class TextWidget extends StatelessWidget {
  final String title;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
final String? fontFamily;
  final double letterSpacing;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;
  final TextDecoration textDecoration;

  const TextWidget({
    super.key,
    required this.title,
    this.color,
    this.fontFamily,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.letterSpacing = 0.25,
    this.maxLines,
    this.textOverflow,
    this.textAlign,
    this.textDecoration = TextDecoration.none,
  });

  @override
  Widget build(BuildContext context) {
    final double tS = MediaQuery.of(context).textScaleFactor;

    return Text(
      title,
      style: Theme.of(context).textTheme.displaySmall!.copyWith(
        fontSize: tS * fontSize,
        fontFamily: fontFamily ?? 'Kardia',
        color: color ?? getThemeColor(context),
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        decoration: textDecoration,
      ),
      maxLines: maxLines,
      overflow: textOverflow,
      textAlign: textAlign,
    );
  }
}
