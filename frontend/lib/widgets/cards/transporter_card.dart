import 'package:flutter/material.dart';

import '../../models/transporter.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/secondary_button.dart';
import '../common/app_status_badge.dart';
import '../common/base_glass_card.dart';
import '../common/info_row.dart';

class TransporterCard extends StatelessWidget {
  final Transporter transporter;
  final VoidCallback? onViewProfile;

  const TransporterCard({
    super.key,
    required this.transporter,
    this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      onTap: onViewProfile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.25),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: AppColors.glassBorderDark,
                  ),
                ),
                child: const Icon(
                  Icons.business_center_rounded,
                  color: AppColors.primaryCyan,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transporter.companyName,
                      style: AppTypography.cardTitle(),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${transporter.rating} Rating",
                          style: AppTypography.labelBold(color: Colors.amber),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppStatusBadge(status: transporter.status),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
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
                  title: "Owner",
                  value: transporter.ownerName ?? 'N/A',
                  icon: Icons.person_rounded,
                ),
                InfoRow(
                  title: "Phone",
                  value: transporter.phone ?? 'N/A',
                  icon: Icons.phone_rounded,
                ),
                InfoRow(
                  title: "Deliveries",
                  value: "${transporter.completedDeliveries} Completed",
                  icon: Icons.local_shipping_rounded,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            title: "View Full Profile",
            icon: Icons.visibility_rounded,
            onPressed: onViewProfile ?? () {},
          ),
        ],
      ),
    );
  }
}

