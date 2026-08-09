import 'package:flutter/material.dart';

import '../../models/bid.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/app_status_badge.dart';
import '../common/base_glass_card.dart';
import '../common/info_row.dart';

class BidCard extends StatelessWidget {
  const BidCard({super.key, required this.bid, this.showActions = true, this.onTap});

  final BidModel bid;
  final bool showActions;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final refText = bid.bidNumber.isNotEmpty
        ? "Bid #${bid.bidNumber}"
        : "Bid #${bid.id.length > 8 ? bid.id.substring(0, 8) : bid.id}";

    return BaseGlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.25),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: AppColors.glassBorderDark,
                  ),
                ),
                child: const Icon(
                  Icons.local_shipping_rounded,
                  color: AppColors.primaryCyan,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bid.transporterName,
                      style: AppTypography.cardTitle(),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      refText,
                      style: AppTypography.bodySecondary(),
                    ),
                  ],
                ),
              ),
              AppStatusBadge(status: bid.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md + 4),
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
                  title: "Bid Amount",
                  value: bid.amountFormatted,
                  icon: Icons.payments_rounded,
                  valueStyle: AppTypography.priceText(),
                ),
                InfoRow(
                  title: "Est. Duration",
                  value: "${bid.estimatedDays} Days",
                  icon: Icons.timer_rounded,
                ),
                if (bid.remarks.isNotEmpty)
                  InfoRow(
                    title: "Remarks",
                    value: bid.remarks,
                    icon: Icons.notes_rounded,
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
