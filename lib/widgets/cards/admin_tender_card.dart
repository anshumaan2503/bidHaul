import 'package:flutter/material.dart';

import '../../models/admin_tender.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class AdminTenderCard extends StatelessWidget {
  final AdminTender tender;
  final VoidCallback onTap;

  const AdminTenderCard({super.key, required this.tender, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.lg,
      child: Container(
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
            Text(tender.title, style: AppTypography.h2()),

            const SizedBox(height: AppSpacing.sm),

            Text(tender.company, style: AppTypography.bodyPrimary()),

            const SizedBox(height: AppSpacing.sm),

            Text(
              "${tender.route} • ${tender.bids} Bids",
              style: AppTypography.bodySecondary(),
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              tender.status,
              style: AppTypography.bodySecondary(
                color: tender.status == "Live"
                    ? AppColors.successGreen
                    : tender.status == "Completed"
                    ? AppColors.primaryCyan
                    : AppColors.dangerRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
