import 'package:flutter/material.dart';

import '../../models/transporter_report.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class ReportCard extends StatelessWidget {
  final TransporterReport report;

  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.glassSurfaceDark,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(report.value, style: AppTypography.h1()),
          const SizedBox(height: AppSpacing.sm),
          Text(
            report.title,
            textAlign: TextAlign.center,
            style: AppTypography.bodySecondary(),
          ),
        ],
      ),
    );
  }
}
