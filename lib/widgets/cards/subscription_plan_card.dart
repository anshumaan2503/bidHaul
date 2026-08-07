import 'package:flutter/material.dart';

import '../../models/subscription_plan.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final VoidCallback? onSelect;

  const SubscriptionPlanCard({super.key, required this.plan, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.glassSurfaceDark,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: plan.recommended
              ? AppColors.primaryCyan
              : AppColors.glassBorderDark,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (plan.recommended)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                borderRadius: AppRadius.pill,
              ),
              child: Text(
                "RECOMMENDED",
                style: AppTypography.microBadge(color: AppColors.darkMidnight),
              ),
            ),

          if (plan.recommended) const SizedBox(height: AppSpacing.md),

          Text(plan.name, style: AppTypography.h1()),

          const SizedBox(height: AppSpacing.sm),

          Text(
            "₹${plan.monthlyPrice.toStringAsFixed(0)} / month",
            style: AppTypography.h2(color: AppColors.primaryCyan),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(plan.description, style: AppTypography.bodySecondary()),

          const SizedBox(height: AppSpacing.lg),

          ...plan.features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.successGreen,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(feature, style: AppTypography.bodyPrimary()),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          PrimaryButton(title: "Choose Plan", onPressed: onSelect),
        ],
      ),
    );
  }
}
