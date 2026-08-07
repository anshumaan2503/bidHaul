import 'package:flutter/material.dart';

import '../../models/bid.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class BidCard extends StatelessWidget {
  const BidCard({super.key, required this.bid, this.showActions = true});

  final Bid bid;

  final bool showActions;

  Color get statusColor {
    switch (bid.status) {
      case BidStatus.accepted:
        return Colors.green;
      case BidStatus.rejected:
        return Colors.red;
      case BidStatus.pending:
        return Colors.orange;
    }
  }

  String get statusText {
    switch (bid.status) {
      case BidStatus.accepted:
        return "ACCEPTED";
      case BidStatus.rejected:
        return "REJECTED";
      case BidStatus.pending:
        return "PENDING";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .06),
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(bid.transporterName, style: AppTypography.h3()),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: AppTypography.microBadge(color: statusColor),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            "Bid Amount : ${bid.amount}",
            style: AppTypography.bodyPrimary(),
          ),

          const SizedBox(height: 8),

          Text(
            "Delivery : ${bid.estimatedDays}",
            style: AppTypography.bodyPrimary(),
          ),

          const SizedBox(height: 8),

          Text(
            "Remarks : ${bid.remarks}",
            style: AppTypography.bodySecondary(),
          ),

          if (showActions) ...[const SizedBox(height: 20)],
        ],
      ),
    );
  }
}
