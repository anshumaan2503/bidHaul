import 'package:flutter/material.dart';

import '../../models/delivery.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/secondary_button.dart';
import '../common/app_status_badge.dart';
import '../common/base_glass_card.dart';
import '../common/info_row.dart';

class CompletedDeliveryCard extends StatelessWidget {
  final DeliveryModel delivery;
  final VoidCallback? onViewDetails;

  const CompletedDeliveryCard({
    super.key,
    required this.delivery,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      onTap: onViewDetails,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withValues(alpha: 0.2),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: AppColors.successGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.task_alt_rounded,
                  color: AppColors.successGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery Completed",
                      style: AppTypography.cardTitle(),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "ID: #${delivery.id.substring(0, 8)}",
                      style: AppTypography.bodySecondary(),
                    ),
                  ],
                ),
              ),
              const AppStatusBadge(status: "COMPLETED"),
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
                  title: "Route",
                  value: "${delivery.pickupLocation}  ➔  ${delivery.deliveryLocation}",
                  icon: Icons.alt_route_rounded,
                ),
                InfoRow(
                  title: "Contract ID",
                  value: delivery.contractId,
                  icon: Icons.description_rounded,
                ),
                if (delivery.confirmedAt != null)
                  InfoRow(
                    title: "Confirmed On",
                    value: delivery.confirmedAt!.substring(0, 10),
                    icon: Icons.event_available_rounded,
                  ),
                if (delivery.rating != null)
                  InfoRow(
                    title: "Rating",
                    value: "⭐ ${delivery.rating!.toStringAsFixed(1)} / 5.0",
                    icon: Icons.star_rounded,
                    valueColor: Colors.amber,
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            title: "View Delivery Details & Tracking",
            icon: Icons.receipt_rounded,
            onPressed: onViewDetails ?? () {},
          ),
        ],
      ),
    );
  }
}