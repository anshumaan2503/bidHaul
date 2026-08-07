import 'package:flutter/material.dart';

import '../../../dummy/dummy_report_summary.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/cards/report_summary_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "Reports"),

          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: GridView.builder(
              itemCount: dummyReportSummary.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (_, index) {
                return ReportSummaryCard(
                  report: dummyReportSummary[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
