import 'package:flutter/material.dart';

import '../../models/qualified_bidder.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class QualifiedBidderCard extends StatelessWidget {
  final QualifiedBidder bidder;

  const QualifiedBidderCard({super.key, required this.bidder});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.glassSurfaceDark,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: bidder.rank == 1
              ? AppColors.successGreen
              : AppColors.glassBorderDark,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "L${bidder.rank}",
            style: AppTypography.h1(
              color: bidder.rank == 1 ? AppColors.successGreen : Colors.white,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(bidder.transporterName, style: AppTypography.h2()),

          const SizedBox(height: AppSpacing.md),

          _row("Vehicle", bidder.vehicleType),
          _row("Bid", "₹${bidder.bidAmount.toStringAsFixed(0)}"),
          _row("Status", bidder.status),
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
