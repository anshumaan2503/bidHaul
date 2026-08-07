import 'package:flutter/material.dart';

import '../../models/app_notification.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/base_glass_card.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      onTap: onTap,
      backgroundColor: notification.isRead
          ? AppColors.glassSurfaceDark
          : AppColors.primaryBlue.withValues(alpha: .15),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active_rounded,
            color: AppColors.primaryCyan,
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title, style: AppTypography.h3()),

                const SizedBox(height: AppSpacing.xs),

                Text(
                  notification.message,
                  style: AppTypography.bodySecondary(),
                ),

                const SizedBox(height: AppSpacing.sm),

                Text(notification.time, style: AppTypography.microBadge()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
