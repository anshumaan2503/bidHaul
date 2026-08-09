import 'package:flutter/material.dart';

import '../../models/auction_history.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';

class AuctionHistoryCard extends StatelessWidget {
  final AuctionHistory history;
  final VoidCallback? onViewDetails;

  const AuctionHistoryCard({
    super.key,
    required this.history,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.glassSurfaceDark,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(history.tenderId, style: AppTypography.h2()),

          const SizedBox(height: AppSpacing.sm),

          Text("AUCTION HISTORY", style: AppTypography.microBadge()),

          const SizedBox(height: AppSpacing.lg),

          _info("Route", history.route),
          _info("Vehicle", history.vehicleType),
          _info("Winner", history.winner),
          _info("Final Bid", "₹${history.finalAmount.toStringAsFixed(0)}"),
          _info("Closed", history.closedDate),
          _info("Status", history.status),

          const SizedBox(height: AppSpacing.lg),

          PrimaryButton(
            title: "View Details",
            onPressed: onViewDetails ?? () {},
          ),
        ],
      ),
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
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
