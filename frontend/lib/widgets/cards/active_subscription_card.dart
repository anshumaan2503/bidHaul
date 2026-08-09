import 'package:flutter/material.dart';

import '../../models/user_subscription.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/app_status_badge.dart';
import '../common/base_glass_card.dart';
import '../common/info_row.dart';

class ActiveSubscriptionCard extends StatelessWidget {
  final UserSubscriptionModel subscription;

  const ActiveSubscriptionCard({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      hasGlow: subscription.isActive,
      borderColor: subscription.isActive ? AppColors.primaryCyan : Colors.white24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.25),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: AppColors.primaryCyan.withValues(alpha: 0.5),
                  ),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.primaryCyan,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.planName,
                      style: AppTypography.cardTitle(),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "₹${subscription.monthlyPrice.toStringAsFixed(0)} / month",
                      style: AppTypography.priceText(color: AppColors.primaryCyan),
                    ),
                  ],
                ),
              ),
              AppStatusBadge(status: subscription.status),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: [
                InfoRow(
                  title: "Start Date",
                  value: subscription.startDate != null
                      ? (subscription.startDate!.length >= 10 ? subscription.startDate!.substring(0, 10) : subscription.startDate!)
                      : "Pending",
                  icon: Icons.calendar_month_rounded,
                ),
                InfoRow(
                  title: "Expiry Date",
                  value: subscription.expiryDate != null
                      ? (subscription.expiryDate!.length >= 10 ? subscription.expiryDate!.substring(0, 10) : subscription.expiryDate!)
                      : "Pending",
                  icon: Icons.event_busy_rounded,
                ),
                InfoRow(
                  title: "Remaining",
                  value: "${subscription.remainingDays} Days",
                  icon: Icons.hourglass_top_rounded,
                  valueColor: AppColors.primaryCyan,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
