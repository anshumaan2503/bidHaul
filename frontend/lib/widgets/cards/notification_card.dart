import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/notification.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/base_glass_card.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  IconData _getTypeIcon(NotificationTypeEnum type) {
    switch (type) {
      case NotificationTypeEnum.TENDER:
        return Icons.description_rounded;
      case NotificationTypeEnum.BID:
        return Icons.gavel_rounded;
      case NotificationTypeEnum.NEGOTIATION:
        return Icons.handshake_rounded;
      case NotificationTypeEnum.CONTRACT:
        return Icons.assignment_turned_in_rounded;
      case NotificationTypeEnum.DELIVERY:
        return Icons.local_shipping_rounded;
      case NotificationTypeEnum.SUBSCRIPTION:
        return Icons.card_membership_rounded;
      case NotificationTypeEnum.INVOICE:
        return Icons.receipt_long_rounded;
      case NotificationTypeEnum.PAYMENT:
        return Icons.account_balance_wallet_rounded;
      case NotificationTypeEnum.SYSTEM:
      case NotificationTypeEnum.UNKNOWN:
        return Icons.notifications_active_rounded;
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.read;

    return BaseGlassCard(
      onTap: onTap,
      hasGlow: isUnread,
      borderColor: isUnread ? AppColors.primaryCyan.withValues(alpha: 0.4) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isUnread
                  ? AppColors.primaryCyan.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isUnread
                    ? AppColors.primaryCyan.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Icon(
              _getTypeIcon(notification.type),
              color: isUnread ? AppColors.primaryCyan : AppColors.iceCyan,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: AppTypography.cardTitle(
                          color: isUnread ? Colors.white : AppColors.iceCyan,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryCyan,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryCyan,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: AppTypography.bodySecondary(),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatTime(notification.createdAt),
                  style: AppTypography.microBadge(color: AppColors.iceCyan.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
