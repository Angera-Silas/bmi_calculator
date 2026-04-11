import 'package:flutter/material.dart';
import '../constants.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard({
    super.key,
    required this.colour,
    this.cardChild,
    this.onPress,
    this.borderColor,
  });

  final Color colour;
  final Widget? cardChild;
  final VoidCallback? onPress;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.all(kSpaceSM),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(kRadiusMD),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: cardChild,
      ),
    );
  }
}
