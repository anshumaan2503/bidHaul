import 'package:flutter/material.dart';

import '../../models/negotiation.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/secondary_button.dart';
import '../common/app_status_badge.dart';
import '../common/base_glass_card.dart';
import '../common/info_row.dart';

class NegotiationOfferCard extends StatelessWidget {
  final NegotiationModel negotiation;
  final VoidCallback? onCounterOffer;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const NegotiationOfferCard({
    super.key,
    required this.negotiation,
    this.onCounterOffer,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final statusStr = negotiation.status;
    final currentPrice = negotiation.finalAmount ?? negotiation.currentAmount ?? 0.0;
    final latestOffer = negotiation.offers.isNotEmpty ? negotiation.offers.last : null;

    return BaseGlassCard(
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
                    color: AppColors.glassBorderDark,
                  ),
                ),
                child: const Icon(
                  Icons.handshake_outlined,
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
                      latestOffer != null ? latestOffer.offeredByName : "Negotiation ${negotiation.id.substring(0, 8)}",
                      style: AppTypography.cardTitle(),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Bid ID: #${negotiation.bidId.substring(0, 8)}",
                      style: AppTypography.bodySecondary(),
                    ),
                  ],
                ),
              ),
              AppStatusBadge(status: statusStr),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
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
                  title: "Current Amount",
                  value: "₹${currentPrice.toStringAsFixed(0)}",
                  icon: Icons.price_change_rounded,
                  valueStyle: AppTypography.priceText(color: AppColors.primaryCyan),
                  padding: EdgeInsets.zero,
                ),
                if (latestOffer != null && latestOffer.remarks.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  InfoRow(
                    title: "Latest Remarks",
                    value: latestOffer.remarks,
                    icon: Icons.chat_bubble_outline_rounded,
                    valueStyle: AppTypography.bodySecondary(color: Colors.white),
                  ),
                ],
              ],
            ),
          ),
          if (negotiation.isOpen) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                if (onCounterOffer != null)
                  Expanded(
                    child: SecondaryButton(
                      title: "Counter Offer",
                      icon: Icons.swap_horiz_rounded,
                      onPressed: onCounterOffer!,
                    ),
                  ),
                if (onCounterOffer != null && (onAccept != null || onReject != null))
                  const SizedBox(width: 8),
                if (onAccept != null)
                  IconButton(
                    onPressed: onAccept,
                    icon: const Icon(Icons.check_circle_outline, color: AppColors.successGreen),
                    tooltip: "Accept Offer",
                  ),
                if (onReject != null)
                  IconButton(
                    onPressed: onReject,
                    icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
                    tooltip: "Reject Offer",
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
