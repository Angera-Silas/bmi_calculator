import 'package:flutter/material.dart';

// ─── Spacing ──────────────────────────────────────────────────────────────────
const double kSpaceXS = 4.0;
const double kSpaceSM = 8.0;
const double kSpaceMD = 16.0;
const double kSpaceLG = 24.0;
const double kSpaceXL = 32.0;
const double kSpaceXXL = 48.0;

// ─── Border Radius ────────────────────────────────────────────────────────────
const double kRadiusSM = 8.0;
const double kRadiusMD = 16.0;
const double kRadiusLG = 24.0;
const double kRadiusXL = 32.0;

// ─── Dark Theme Palette ───────────────────────────────────────────────────────
const Color kDarkBg = Color(0xFF0D1117);
const Color kDarkSurface = Color(0xFF161B27);
const Color kDarkCard = Color(0xFF1E2438);
const Color kDarkCardAlt = Color(0xFF191E30);
const Color kDarkBorder = Color(0xFF2A3050);

// ─── Light Theme Palette ──────────────────────────────────────────────────────
const Color kLightBg = Color(0xFFF2F4FF);
const Color kLightSurface = Color(0xFFFFFFFF);
const Color kLightCard = Color(0xFFFFFFFF);
const Color kLightCardAlt = Color(0xFFEEF0FF);
const Color kLightBorder = Color(0xFFDDE1FF);

// ─── Brand / Accent ───────────────────────────────────────────────────────────
const Color kAccent = Color(0xFF6C63FF);
const Color kAccentDark = Color(0xFF4B44CC);
const Color kAccentLight = Color(0xFF9D96FF);

// ─── BMI Category Colors ──────────────────────────────────────────────────────
const Color kSeverelyUnderweightColor = Color(0xFF1565C0);
const Color kUnderweightColor = Color(0xFF29B6F6);
const Color kNormalColor = Color(0xFF43A047);
const Color kOverweightColor = Color(0xFFFB8C00);
const Color kObeseIColor = Color(0xFFE53935);
const Color kObeseIIColor = Color(0xFFC62828);
const Color kObeseIIIColor = Color(0xFF7B1FA2);

// ─── Semantic Colors ──────────────────────────────────────────────────────────
const Color kSuccessColor = Color(0xFF43A047);
const Color kErrorColor = Color(0xFFE53935);
const Color kWarningColor = Color(0xFFFB8C00);
const Color kInfoColor = Color(0xFF29B6F6);

// ─── Legacy aliases (used by existing widgets) ────────────────────────────────
const kBottomContainerHeight = 52.0;
const kDarkPrimaryColor = kDarkBg;
const kLightPrimaryColor = kLightBg;
const kDarkActiveCardColor = kDarkCard;
const kDarkInactiveCardColor = kDarkCardAlt;
const kDarkBottomContainerColor = kAccent;
const kDarkLabelColor = Color(0xFF8892B0);
const kLightActiveCardColor = kLightCardAlt;
const kLightInactiveCardColor = kLightCard;
const kLightBottomContainerColor = kAccent;
const kLightLabelColor = Color(0xFF6B7280);

// ─── Text Styles ──────────────────────────────────────────────────────────────
const kLargeButtonTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.white,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.5,
);

const kNumberTextStyle = TextStyle(
  fontSize: 52,
  fontWeight: FontWeight.w900,
  height: 1.0,
);

const kTitleTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 28.0,
);

const kResultTextStyle = TextStyle(
  color: kNormalColor,
  fontSize: 18.0,
  fontWeight: FontWeight.w800,
  letterSpacing: 1.5,
);

const kBMITextStyle = TextStyle(
  fontSize: 64.0,
  fontWeight: FontWeight.w900,
  height: 1.0,
);

const kBodyTextStyle = TextStyle(
  fontSize: 15.0,
  height: 1.6,
);

// ─── Dynamic Colors ───────────────────────────────────────────────────────────
class DynamicColors {
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color bg(BuildContext context) =>
      isDark(context) ? kDarkBg : kLightBg;

  static Color surface(BuildContext context) =>
      isDark(context) ? kDarkSurface : kLightSurface;

  static Color card(BuildContext context) =>
      isDark(context) ? kDarkCard : kLightCard;

  static Color cardAlt(BuildContext context) =>
      isDark(context) ? kDarkCardAlt : kLightCardAlt;

  static Color border(BuildContext context) =>
      isDark(context) ? kDarkBorder : kLightBorder;

  static Color activeCardColor(BuildContext context) =>
      isDark(context) ? kDarkCard : kLightCardAlt;

  static Color inactiveCardColor(BuildContext context) =>
      isDark(context) ? kDarkCardAlt : kLightCard;

  static Color bottomContainerColor(BuildContext context) => kAccent;

  static Color labelColor(BuildContext context) =>
      isDark(context) ? kDarkLabelColor : kLightLabelColor;

  static Color primaryCardColor(BuildContext context) =>
      isDark(context) ? kDarkSurface : kLightSurface;

  static Color activesliderCardColor(BuildContext context) =>
      isDark(context) ? Colors.white : kAccent;

  static Color textPrimary(BuildContext context) =>
      isDark(context) ? const Color(0xFFE6EDF3) : const Color(0xFF0D1117);

  static Color textSecondary(BuildContext context) =>
      isDark(context) ? const Color(0xFF8892B0) : const Color(0xFF6B7280);

  static Color iconColor(BuildContext context) =>
      isDark(context) ? const Color(0xFF8892B0) : const Color(0xFF6B7280);
}

// ─── BMI Color Helper ─────────────────────────────────────────────────────────
Color getBMIColor(double bmi) {
  if (bmi < 16.0) return kSeverelyUnderweightColor;
  if (bmi < 18.5) return kUnderweightColor;
  if (bmi < 25.0) return kNormalColor;
  if (bmi < 30.0) return kOverweightColor;
  if (bmi < 35.0) return kObeseIColor;
  if (bmi < 40.0) return kObeseIIColor;
  return kObeseIIIColor;
}

// ─── Shared Text Style Helper ─────────────────────────────────────────────────
TextStyle labelStyle(BuildContext context) => TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w700,
      color: DynamicColors.labelColor(context),
      letterSpacing: 1.2,
    );
