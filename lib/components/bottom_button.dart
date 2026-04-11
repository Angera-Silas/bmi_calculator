import 'package:flutter/material.dart';
import '../constants.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({
    super.key,
    required this.buttonTitle,
    required this.onTap,
    this.isLoading = false,
  });

  final String buttonTitle;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: kSpaceXS, horizontal: kSpaceMD),
        width: double.infinity,
        height: kBottomContainerHeight,
        decoration: BoxDecoration(
          color: isLoading ? kAccent.withOpacity(0.6) : kAccent,
          borderRadius: BorderRadius.circular(kRadiusMD),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Text(buttonTitle, style: kLargeButtonTextStyle),
        ),
      ),
    );
  }
}
