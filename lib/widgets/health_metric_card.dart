import 'package:flutter/material.dart';
import '../constants.dart';

/// Reusable display card for an advanced health metric (WHtR, body fat,
/// metabolic age, VO2max…).
class HealthMetricCard extends StatelessWidget {
  const HealthMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.categoryLabel,
    required this.categoryColor,
    required this.recommendation,
    this.icon = Icons.favorite_outline,
  });

  final String title;
  final String value;
  final String unit;
  final String categoryLabel;
  final Color categoryColor;
  final String recommendation;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kSpaceMD),
      decoration: BoxDecoration(
        color: DynamicColors.card(context),
        borderRadius: BorderRadius.circular(kRadiusMD),
        border: Border.all(color: DynamicColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(kRadiusSM),
                ),
                child: Icon(icon, color: categoryColor, size: 16),
              ),
              const SizedBox(width: kSpaceSM),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: DynamicColors.textPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpaceMD),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: categoryColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 13,
                  color: DynamicColors.textSecondary(context),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: kSpaceSM, vertical: 4),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(kRadiusSM),
                  border: Border.all(color: categoryColor.withOpacity(0.3)),
                ),
                child: Text(
                  categoryLabel,
                  style: TextStyle(
                    color: categoryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpaceSM),
          Text(
            recommendation,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: DynamicColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}

/// Maps the metric risk-level enums to the app's consistent palette.
abstract final class MetricColors {
  static Color fromRisk(
    BuildContext context,
    String category,
  ) {
    final lower = category.toLowerCase();

    // Cardio / fitness favourable categories.
    if (lower.contains('lean') ||
        lower.contains('healthy') ||
        lower.contains('matches') ||
        lower.contains('fit') ||
        lower.contains('athlete') ||
        lower.contains('excellent') ||
        lower.contains('good') ||
        lower.contains('faster')) {
      return kSuccessColor;
    }

    // Moderate / intermediate categories.
    if (lower.contains('increased') ||
        lower.contains('increasedrisk') ||
        lower.contains('fair') ||
        lower.contains('acceptable') ||
        lower.contains('normal')) {
      return kWarningColor;
    }

    // Unfavourable / high-risk categories.
    if (lower.contains('high') ||
        lower.contains('obese') ||
        lower.contains('essential') ||
        lower.contains('poor') ||
        lower.contains('verypoor') ||
        lower.contains('slower')) {
      return kErrorColor;
    }

    return kInfoColor;
  }
}
