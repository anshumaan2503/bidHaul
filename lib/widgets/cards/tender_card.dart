import 'package:flutter/material.dart';

import '../../models/tender.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class TenderCard extends StatelessWidget {
  const TenderCard({
    super.key,
    required this.tender,
    this.onTap,
  });

  final Tender tender;
  final VoidCallback? onTap;

  Color get statusColor {
    switch (tender.status) {
      case TenderStatus.live:
        return Colors.green;
      case TenderStatus.completed:
        return Colors.blue;
      case TenderStatus.cancelled:
        return Colors.red;
      case TenderStatus.draft:
        return Colors.orange;
    }
  }

  String get statusText {
    switch (tender.status) {
      case TenderStatus.live:
        return "LIVE";
      case TenderStatus.completed:
        return "COMPLETED";
      case TenderStatus.cancelled:
        return "CANCELLED";
      case TenderStatus.draft:
        return "DRAFT";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.lg,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .06),
          borderRadius: AppRadius.lg,
          border: Border.all(
            color: AppColors.glassBorderDark,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Expanded(
                  child: Text(
                    "Tender #${tender.id}",
                    style: AppTypography.h3(),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: AppTypography.microBadge(
                      color: statusColor,
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [

                const Icon(
                  Icons.route_rounded,
                  color: AppColors.primaryCyan,
                  size: 20,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    "${tender.pickupLocation} → ${tender.deliveryLocation}",
                    style: AppTypography.bodyPrimary(),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                const Icon(
                  Icons.currency_rupee,
                  color: AppColors.primaryCyan,
                  size: 20,
                ),

                const SizedBox(width: 8),

                Text(
                  tender.budget,
                  style: AppTypography.bodyPrimary(),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}