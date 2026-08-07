import 'package:flutter/material.dart';

import '../../models/competitive_bid.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class CompetitiveStatementCard extends StatelessWidget {
  final CompetitiveBid bid;

  const CompetitiveStatementCard({super.key, required this.bid});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.glassSurfaceDark,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: bid.winner
              ? AppColors.successGreen
              : AppColors.glassBorderDark,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("L${bid.rank} • ${bid.transporter}", style: AppTypography.h2()),

          const SizedBox(height: AppSpacing.md),

          _row("Initial Bid", "₹${bid.initialBid.toStringAsFixed(0)}"),

          _row("Negotiated", "₹${bid.negotiatedBid.toStringAsFixed(0)}"),

          _row(
            "Savings",
            "₹${(bid.initialBid - bid.negotiatedBid).toStringAsFixed(0)}",
          ),

          if (bid.winner)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Text(
                "🏆 WINNER",
                style: AppTypography.h3(color: AppColors.successGreen),
              ),
            ),
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
            width: 110,
            child: Text(title, style: AppTypography.bodySecondary()),
          ),
          Expanded(child: Text(value, style: AppTypography.bodyPrimary())),
        ],
      ),
    );
  }
}
