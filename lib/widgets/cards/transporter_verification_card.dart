import 'package:flutter/material.dart';

import '../../models/transporter_verification.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/base_glass_card.dart';

class TransporterVerificationCard extends StatelessWidget {
  final TransporterVerification transporter;
  final VoidCallback onTap;

  const TransporterVerificationCard({
    super.key,
    required this.transporter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(transporter.transporterName, style: AppTypography.h2()),

          const SizedBox(height: AppSpacing.sm),

          Text(transporter.ownerName, style: AppTypography.bodyPrimary()),

          const SizedBox(height: AppSpacing.sm),

          Text(
            transporter.status,
            style: AppTypography.bodySecondary(color: AppColors.warningAmber),
          ),
        ],
      ),
    );
  }
}
