import 'package:flutter/material.dart';

import '../../models/tender.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/app_status_badge.dart';
import '../common/base_glass_card.dart';

class TenderCard extends StatelessWidget {
  const TenderCard({
    super.key,
    required this.tender,
    this.onTap,
    this.onDelete,
  });

  final TenderModel tender;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final refText = tender.tenderNumber.isNotEmpty
        ? "TENDER #${tender.tenderNumber}"
        : "TENDER #${tender.id.length > 8 ? tender.id.substring(0, 8) : tender.id}";

    return BaseGlassCard(
      onTap: onTap,
      hasGlow: tender.isLive,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.25),
                          borderRadius: AppRadius.md,
                        ),
                        child: Text(
                          refText,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.microBadge(color: AppColors.primaryCyan),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppStatusBadge(status: tender.status),
                  ],
                ),
              ),
              if (onDelete != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.dangerRed.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.dangerRed.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.dangerRed,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            tender.title,
            style: AppTypography.h3(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.alt_route_rounded,
                color: AppColors.primaryCyan,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${tender.pickupLocation}  ➔  ${tender.deliveryLocation}",
                  style: AppTypography.cardTitle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: AppColors.iceCyan,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Budget: ",
                        style: AppTypography.bodySecondary(),
                      ),
                      Flexible(
                        child: Text(
                          tender.budget,
                          style: AppTypography.priceText(color: AppColors.primaryCyan),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.iceCyan,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}