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
  final String? currentUserRole; // 'COMPANY' or 'TRANSPORTER'
  final VoidCallback? onCounterOffer;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const NegotiationOfferCard({
    super.key,
    required this.negotiation,
    this.currentUserRole,
    this.onCounterOffer,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final statusStr = negotiation.status;
    final currentPrice = negotiation.finalAmount ?? negotiation.currentAmount ?? 0.0;
    final latestOffer = negotiation.offers.isNotEmpty ? negotiation.offers.last : null;
    final lastOfferedBy = (latestOffer?.offeredBy ?? negotiation.lastOfferedBy ?? 'COMPANY').toUpperCase();

    final isMyTurn = (currentUserRole == null) ||
        (currentUserRole!.toUpperCase() == 'COMPANY' && lastOfferedBy == 'TRANSPORTER') ||
        (currentUserRole!.toUpperCase() == 'TRANSPORTER' && lastOfferedBy == 'COMPANY');

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
                      latestOffer != null ? latestOffer.offeredByName : "Negotiation ${negotiation.id.length > 8 ? negotiation.id.substring(0, 8) : negotiation.id}",
                      style: AppTypography.cardTitle(),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Bid ID: #${negotiation.bidId.length > 8 ? negotiation.bidId.substring(0, 8) : negotiation.bidId}",
                      style: AppTypography.bodySecondary(),
                    ),
                  ],
                ),
              ),
              AppStatusBadge(status: statusStr),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Last Offered By Pill & Current Amount
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Current Offer Amount",
                      style: AppTypography.bodySecondary(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: lastOfferedBy == 'COMPANY'
                            ? AppColors.primaryCyan.withValues(alpha: 0.15)
                            : AppColors.warningAmber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: lastOfferedBy == 'COMPANY'
                              ? AppColors.primaryCyan.withValues(alpha: 0.4)
                              : AppColors.warningAmber.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        "Offered by: $lastOfferedBy",
                        style: AppTypography.bodySecondary(
                          color: lastOfferedBy == 'COMPANY'
                              ? AppColors.primaryCyan
                              : AppColors.warningAmber,
                        ).copyWith(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "₹${currentPrice.toStringAsFixed(0)}",
                  style: AppTypography.priceText(color: AppColors.primaryCyan),
                ),
                if (latestOffer != null && latestOffer.remarks.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  InfoRow(
                    title: "Remarks",
                    value: latestOffer.remarks,
                    icon: Icons.chat_bubble_outline_rounded,
                    valueStyle: AppTypography.bodySecondary(color: Colors.white),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ],
            ),
          ),

          // Offer History List (if more than 1 offer)
          if (negotiation.offers.length > 1) ...[
            const SizedBox(height: AppSpacing.sm),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              collapsedIconColor: AppColors.primaryCyan,
              iconColor: AppColors.primaryCyan,
              title: Text(
                "View Offer History (${negotiation.offers.length} offers)",
                style: AppTypography.bodySecondary(color: AppColors.primaryCyan),
              ),
              children: negotiation.offers.map((offer) {
                final isCo = offer.offeredBy.toUpperCase() == 'COMPANY';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isCo ? Icons.business_rounded : Icons.local_shipping_rounded,
                            size: 14,
                            color: isCo ? AppColors.primaryCyan : AppColors.warningAmber,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${offer.offeredByName}:",
                            style: AppTypography.bodySecondary(color: Colors.white70),
                          ),
                        ],
                      ),
                      Text(
                        "₹${offer.amount.toStringAsFixed(0)}",
                        style: AppTypography.h3(color: isCo ? AppColors.primaryCyan : AppColors.warningAmber),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],

          if (negotiation.isOpen) ...[
            const SizedBox(height: AppSpacing.md),
            if (!isMyTurn) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: AppRadius.md,
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.hourglass_top_rounded, color: Colors.amber, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Offer submitted. Awaiting response from ${lastOfferedBy == 'COMPANY' ? 'Transporter' : 'Company'}.",
                        style: AppTypography.bodySecondary(color: Colors.amber),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Row(
              children: [
                if (onCounterOffer != null)
                  Expanded(
                    child: SecondaryButton(
                      title: isMyTurn ? "Counter Offer" : "Update Offer",
                      icon: Icons.swap_horiz_rounded,
                      onPressed: onCounterOffer!,
                    ),
                  ),
                if (onCounterOffer != null && isMyTurn && (onAccept != null || onReject != null))
                  const SizedBox(width: 8),
                if (isMyTurn && onAccept != null)
                  IconButton(
                    onPressed: onAccept,
                    icon: const Icon(Icons.check_circle_outline, color: AppColors.successGreen),
                    tooltip: "Accept Counter Offer",
                  ),
                if (isMyTurn && onReject != null)
                  IconButton(
                    onPressed: onReject,
                    icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
                    tooltip: "Reject Counter Offer",
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
