import 'package:flutter/material.dart';

class BottomSheetContent extends StatelessWidget {
  final String title;
  final String title2;
  final Icon icon;
  final String? svgImage;
  final Color? svgColor;
  final Function func;

  const BottomSheetContent({
    this.svgColor,
    required this.icon,
    this.svgImage,
    required this.title,
    required this.title2,
    required this.func,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => func(),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 30,
            child: SizedBox(height: 30, width: 30, child: icon
                // SvgPicture.asset(
                //   svgImage,
                //   color: svgColor,
                // ),
                ),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color.fromRGBO(121, 120, 128, 1),
              ),
            ),
            Text(
              title2,
              style: const TextStyle(
                color: Color.fromRGBO(121, 120, 128, 1),
              ),
            ),
          ],
        )
      ],
    );
  }
}
