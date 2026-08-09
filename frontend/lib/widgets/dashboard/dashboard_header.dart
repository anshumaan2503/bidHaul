import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../providers/notification_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../screens/common/notifications/notifications_screen.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onLogoutTap;

  const DashboardHeader({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Brand Micro Badge Left Indicator with New Emblem Mark
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryCyan.withValues(alpha: 0.10),
            borderRadius: AppRadius.full,
            border: Border.all(
              color: AppColors.primaryCyan.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/bidhaul_icon_only.svg',
                width: 18,
                height: 18,
              ),
              const SizedBox(width: 8),
              const Text(
                'BIDHAUL ENTERPRISE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.primaryCyan,
                ),
              ),
            ],
          ),
        ),

        Row(
          children: [
            // Notification Glass Button with Dynamic Unread Pulse Indicator
            Consumer<NotificationProvider>(
              builder: (context, notifProvider, _) {
                final hasUnread = notifProvider.unreadCount > 0;

                return GestureDetector(
                  onTap: onNotificationTap ??
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        );
                      },
                  child: Stack(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.glassSurfaceDark,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.glassBorderDark,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.primaryCyan,
                          size: 20,
                        ),
                      ),
                      // Unread Glow Dot
                      if (hasUnread)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: AppColors.primaryCyan,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.darkMidnight,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryCyan.withValues(alpha: 0.6),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),

            if (onLogoutTap != null) ...[
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onLogoutTap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.glassSurfaceDark,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.dangerRed.withValues(alpha: 0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.dangerRed,
                    size: 20,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
