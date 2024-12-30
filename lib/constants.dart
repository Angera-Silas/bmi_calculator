import 'package:flutter/material.dart';

const kBottomContainerHeight = 50.0;

// used for dark theme
const kDarkPrimaryColor = Color(0xFF0A0E21);
const kLightPrimaryColor = Color(0xFFFFFFFF);
const kDarkActiveCardColor = Color(0xFF1D1E33);
const kDarkInactiveCardColor = Color(0xFF111328);
const kDarkBottomContainerColor = Color(0xFFEB1555);
const kDarkLabelColor = Color(0xFF8D8E98);

// used for light theme
const kLightActiveCardColor = Color(0xFF5D5D5D);
const kLightInactiveCardColor = Color(0xFF8D8E98);
const kLightBottomContainerColor = Color(0xFF000000);
const kLightLabelColor = Color(0xFFf1f1f1);

TextStyle labelStyle(BuildContext context) {
  return TextStyle(
    fontSize: 18.0,
    color: DynamicColors.labelColor(context),
  );
}

const kNumberTextStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w900,
);

const kLargeButtonTextStyle = TextStyle(
  fontSize: 25.0,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

const kTitleTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 40.0,
);

const kResultTextStyle = TextStyle(
  color: Color(0xFF24D876),
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

const kBMITextStyle = TextStyle(
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
);

const kBodyTextStyle = TextStyle(
  fontSize: 22.0,
);

class DynamicColors {
  // Retrieve active colors based on theme brightness
  static Color activeCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkActiveCardColor
        : kLightActiveCardColor;
  }

  static Color inactiveCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkInactiveCardColor
        : kLightInactiveCardColor;
  }

  static Color bottomContainerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkBottomContainerColor
        : kLightBottomContainerColor;
  }

  static Color labelColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkLabelColor
        : kLightLabelColor;
  }

  static Color primaryCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? kDarkPrimaryColor
        : kLightPrimaryColor;
  }

  static Color activesliderCardColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
