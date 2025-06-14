import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool?>? onChanged;
  final Color activeColor;
  CustomRadioButton(
      {required this.label,
      required this.isSelected,
      required this.onChanged,
      required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!isSelected);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Radio<bool>(
              value: true,
              activeColor: activeColor,
              groupValue: isSelected,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
