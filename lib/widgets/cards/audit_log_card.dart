import 'package:flutter/material.dart';

import '../../models/audit_log.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/base_glass_card.dart';

class AuditLogCard extends StatelessWidget {
  final AuditLog log;

  const AuditLogCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(log.action, style: AppTypography.h2()),
          const SizedBox(height: AppSpacing.sm),
          Text(log.performedBy, style: AppTypography.bodyPrimary()),
          const SizedBox(height: AppSpacing.sm),
          Text(log.dateTime, style: AppTypography.bodySecondary()),
        ],
      ),
    );
  }
}
