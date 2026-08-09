import 'package:flutter/material.dart';

import '../../models/bid_history.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';

class BidHistoryCard extends StatelessWidget {
  final BidHistory bid;
  final VoidCallback? onViewDetails;

  const BidHistoryCard({super.key, required this.bid, this.onViewDetails});

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
          Text(bid.company, style: AppTypography.h2()),

          const SizedBox(height: AppSpacing.sm),

          Text("BID HISTORY", style: AppTypography.microBadge()),

          const SizedBox(height: AppSpacing.lg),

          _info("Tender", bid.tenderId),
          _info("Route", bid.route),
          _info("Bid", "₹${bid.bidAmount.toStringAsFixed(0)}"),
          _info("Date", bid.bidDate),
          _info("Status", bid.status),

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
