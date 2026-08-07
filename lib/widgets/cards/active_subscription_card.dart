import 'package:flutter/material.dart';

import '../../models/active_subscription.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class ActiveSubscriptionCard extends StatelessWidget {
  final ActiveSubscription subscription;

  const ActiveSubscriptionCard({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.glassSurfaceDark,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.primaryCyan),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subscription.planName, style: AppTypography.h1()),

          const SizedBox(height: AppSpacing.md),

          Text(
            "₹${subscription.monthlyPrice.toStringAsFixed(0)}/month",
            style: AppTypography.h2(color: AppColors.primaryCyan),
          ),

          const SizedBox(height: AppSpacing.lg),

          _row("Start", subscription.startDate),
          _row("Expiry", subscription.expiryDate),
          _row("Remaining", "${subscription.remainingDays} Days"),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(title, style: AppTypography.bodySecondary()),
          ),
          Expanded(child: Text(value, style: AppTypography.bodyPrimary())),
        ],
      ),
    );
  }
}
