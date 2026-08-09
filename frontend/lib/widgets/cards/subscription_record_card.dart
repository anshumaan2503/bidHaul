import 'package:flutter/material.dart';

import '../../models/subscription_record.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/base_glass_card.dart';

class SubscriptionRecordCard extends StatelessWidget {
  final SubscriptionRecord record;

  const SubscriptionRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(record.userName, style: AppTypography.h2()),

          const SizedBox(height: AppSpacing.sm),

          Text(
            record.userType,
            style: AppTypography.bodySecondary(color: AppColors.primaryCyan),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            "${record.planName} • ₹${record.amount.toStringAsFixed(0)}",
            style: AppTypography.bodyPrimary(),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            "Expires: ${record.expiryDate}",
            style: AppTypography.bodySecondary(),
          ),
        ],
      ),
    );
  }
}
