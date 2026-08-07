import 'package:flutter/material.dart';

import '../../models/transporter.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';

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
          Text(transporter.companyName, style: AppTypography.h2()),

          const SizedBox(height: AppSpacing.sm),

          Text("REGISTERED TRANSPORTER", style: AppTypography.microBadge()),

          const SizedBox(height: AppSpacing.lg),

          _info("Owner", transporter.ownerName),
          _info("Phone", transporter.phone),
          _info("Rating", transporter.rating.toString()),
          _info("Deliveries", transporter.completedDeliveries.toString()),
          _info("Status", transporter.status),

          const SizedBox(height: AppSpacing.lg),

          PrimaryButton(
            title: "View Profile",
            onPressed: onViewProfile ?? () {},
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
            width: 95,
            child: Text(title, style: AppTypography.bodySecondary()),
          ),
          Expanded(child: Text(value, style: AppTypography.bodyPrimary())),
        ],
      ),
    );
  }
}
