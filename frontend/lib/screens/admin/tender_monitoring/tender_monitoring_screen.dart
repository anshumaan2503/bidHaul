import 'package:flutter/material.dart';

import '../../../dummy/dummy_admin_tenders.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/cards/admin_tender_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';
import 'tender_details_screen.dart';

class TenderMonitoringScreen extends StatelessWidget {
  const TenderMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "Tender Monitoring"),

          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: ListView.builder(
              itemCount: dummyAdminTenders.length,
              itemBuilder: (_, index) {
                final tender = dummyAdminTenders[index];

                return AdminTenderCard(
                  tender: tender,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TenderDetailsScreen(tender: tender),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}