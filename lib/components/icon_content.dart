import 'package:flutter/material.dart';
import '../constants.dart';

class IconContent extends StatelessWidget {
  const IconContent({super.key, this.icon, this.label, this.isSelected = false});

  final String? label;
  final IconData? icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 32.0,
          color: isSelected ? kAccent : DynamicColors.iconColor(context),
        ),
        const SizedBox(height: kSpaceXS),
        Text(
          '$label',
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? kAccent : DynamicColors.textSecondary(context),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
