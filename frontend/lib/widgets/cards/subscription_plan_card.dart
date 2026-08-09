import 'package:flutter/material.dart';

import '../../models/subscription_plan.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';
import '../common/base_glass_card.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlanModel plan;
  final VoidCallback? onSelect;

  const SubscriptionPlanCard({super.key, required this.plan, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      hasGlow: plan.recommended,
      borderColor: plan.recommended ? AppColors.primaryCyan : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (plan.recommended) ...[
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  borderRadius: AppRadius.pill,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryCyan.withValues(alpha: 0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Text(
                  "MOST POPULAR",
                  style: AppTypography.microBadge(color: AppColors.darkMidnight),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          Text(plan.name, style: AppTypography.h1()),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "₹${plan.monthlyPrice.toStringAsFixed(0)}",
                style: AppTypography.priceText(color: AppColors.primaryCyan).copyWith(fontSize: 32),
              ),
              const SizedBox(width: 6),
              Text(
                "/ month",
                style: AppTypography.bodySecondary(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(plan.description, style: AppTypography.bodySecondary()),
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: Colors.white10),
          const SizedBox(height: AppSpacing.md),
          ...plan.features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColors.successGreen,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(feature, style: AppTypography.bodyPrimary()),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            title: plan.recommended ? "Get Started Now" : "Choose Plan",
            onPressed: onSelect,
          ),
        ],
      ),
    );
  }
}

