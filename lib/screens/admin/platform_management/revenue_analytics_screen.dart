import 'package:flutter/material.dart';

import '../../../dummy/dummy_report_summary.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/cards/report_summary_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';

class RevenueAnalyticsScreen extends StatelessWidget {
  const RevenueAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "Revenue Analytics"),

          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: ListView.builder(
              itemCount: dummyReportSummary.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: ReportSummaryCard(
                    report: dummyReportSummary[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
