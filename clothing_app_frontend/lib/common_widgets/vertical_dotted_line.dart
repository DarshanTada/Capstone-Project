import 'package:flutter/material.dart';

class VerticalSeparator extends StatelessWidget {
  Color? color;

  VerticalSeparator({
    Key? key,
    this.color,
    this.width = 1,
  }) : super(key: key);
  final double width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxHeight = constraints.constrainHeight();
        const dashHeight = 4.0;
        final dashWidth = width;
        final dashCount = (boxHeight / (2 * dashHeight)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.vertical,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color ?? Colors.black),
              ),
            );
          }),
        );
      },
    );
  }
}
