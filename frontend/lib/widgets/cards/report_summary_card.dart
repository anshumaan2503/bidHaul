import 'package:flutter/material.dart';

import '../../models/report_summary.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/base_glass_card.dart';

class ReportSummaryCard extends StatelessWidget {
  final ReportSummary report;

  const ReportSummaryCard({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(report.title, style: AppTypography.bodySecondary()),
          const SizedBox(height: AppSpacing.sm),
          Text(report.value, style: AppTypography.h1()),
          const SizedBox(height: AppSpacing.sm),
          Text(report.subtitle, style: AppTypography.bodySecondary()),
        ],
      ),
    );
  }
}