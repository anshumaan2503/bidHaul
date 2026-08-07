import 'package:flutter/material.dart';

import '../../../dummy/dummy_audit_logs.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/cards/audit_log_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';

class AuditLogsScreen extends StatelessWidget {
  const AuditLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "Audit Logs"),

          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: ListView.builder(
              itemCount: dummyAuditLogs.length,
              itemBuilder: (_, index) {
                return AuditLogCard(log: dummyAuditLogs[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
