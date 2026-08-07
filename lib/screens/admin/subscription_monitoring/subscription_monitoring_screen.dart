import 'package:flutter/material.dart';

import '../../../dummy/dummy_subscription_records.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/cards/subscription_record_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';

class SubscriptionMonitoringScreen extends StatelessWidget {
  const SubscriptionMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "Subscription Monitoring"),

          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: ListView.builder(
              itemCount: dummySubscriptionRecords.length,
              itemBuilder: (_, index) {
                return SubscriptionRecordCard(
                  record: dummySubscriptionRecords[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
