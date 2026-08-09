import 'package:flutter/material.dart';

import '../../models/audit_log.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/base_glass_card.dart';

class AuditLogCard extends StatelessWidget {
  final AuditLogModel log;

  const AuditLogCard({super.key, required this.log});

  Color _getActionColor(String action) {
    final act = action.toUpperCase();
    if (act.contains('REJECT') || act.contains('SUSPEND') || act.contains('DELETE') || act.contains('FAIL')) {
      return AppColors.dangerRed;
    } else if (act.contains('APPROVE') || act.contains('ACTIVATE') || act.contains('ACCEPT') || act.contains('PAID') || act.contains('SUCCESS')) {
      return AppColors.successGreen;
    } else if (act.contains('CREATE') || act.contains('SUBMIT') || act.contains('BID')) {
      return AppColors.primaryCyan;
    }
    return AppColors.warningAmber;
  }

  String _formatTimestamp(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final actionColor = _getActionColor(log.action);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: BaseGlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: actionColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: actionColor),
                    ),
                    child: Text(
                      log.action,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: actionColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTimestamp(log.timestamp),
                  style: AppTypography.bodySecondary().copyWith(fontSize: 11),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            Row(
              children: [
                const Icon(Icons.person_outline, size: 14, color: AppColors.iceCyan),
                const SizedBox(width: 4),
                Text(
                  "Actor: ",
                  style: AppTypography.bodySecondary().copyWith(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    log.actorUserId,
                    style: AppTypography.bodyPrimary().copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xs),

            Row(
              children: [
                const Icon(Icons.category_outlined, size: 14, color: AppColors.iceCyan),
                const SizedBox(width: 4),
                Text(
                  "Target: ",
                  style: AppTypography.bodySecondary().copyWith(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    "${log.entityType} [${log.entityId}]",
                    style: AppTypography.bodySecondary().copyWith(fontSize: 12, color: AppColors.primaryCyan),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            if (log.metadata != null && log.metadata!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Metadata: ${log.metadata}",
                style: AppTypography.bodySecondary().copyWith(fontSize: 11, fontStyle: FontStyle.italic),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
