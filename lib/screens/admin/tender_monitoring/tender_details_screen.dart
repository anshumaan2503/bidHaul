import 'package:flutter/material.dart';

import '../../../models/admin_tender.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';
import '../../../widgets/common/info_row.dart';

class TenderDetailsScreen extends StatelessWidget {
  final AdminTender tender;

  const TenderDetailsScreen({super.key, required this.tender});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          CommonAppBar(
            title: tender.title,
            titleStyle: AppTypography.h2(),
          ),

          const SizedBox(height: AppSpacing.xl),

          InfoRow(title: "Company", value: tender.company),
          InfoRow(title: "Route", value: tender.route),
          InfoRow(title: "Status", value: tender.status),
          InfoRow(title: "Total Bids", value: tender.bids.toString()),
        ],
      ),
    );
  }
}
