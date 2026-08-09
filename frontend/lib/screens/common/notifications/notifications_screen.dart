import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/notification_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.darkFluidGradient,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text("Notifications", style: AppTypography.displayHero()),
                        ],
                      ),
                      Consumer<NotificationProvider>(
                        builder: (context, provider, _) {
                          if (provider.unreadCount == 0) return const SizedBox.shrink();
                          return TextButton.icon(
                            onPressed: provider.isMarkingRead
                                ? null
                                : () => provider.markAllAsRead(),
                            icon: const Icon(
                              Icons.done_all_rounded,
                              color: AppColors.primaryCyan,
                              size: 18,
                            ),
                            label: Text(
                              "Mark all read",
                              style: AppTypography.bodySecondary(color: AppColors.primaryCyan),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Consumer<NotificationProvider>(
                      builder: (context, provider, _) {
                        if (provider.isLoading && provider.notifications.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryCyan,
                            ),
                          );
                        }

                        if (provider.errorMessage != null && provider.notifications.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  color: Colors.redAccent,
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  provider.errorMessage!,
                                  style: AppTypography.bodySecondary(),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => provider.fetchNotifications(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryCyan,
                                  ),
                                  child: const Text("Retry"),
                                ),
                              ],
                            ),
                          );
                        }

                        if (provider.notifications.isEmpty) {
                          return RefreshIndicator(
                            color: AppColors.primaryCyan,
                            backgroundColor: AppColors.darkMidnight,
                            onRefresh: () => provider.fetchNotifications(),
                            child: ListView(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.notifications_none_rounded,
                                          color: AppColors.iceCyan.withValues(alpha: 0.4),
                                          size: 64,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "No notifications yet",
                                          style: AppTypography.cardTitle(color: AppColors.iceCyan),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Events and system updates will appear here.",
                                          style: AppTypography.bodySecondary(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          color: AppColors.primaryCyan,
                          backgroundColor: AppColors.darkMidnight,
                          onRefresh: () => provider.fetchNotifications(),
                          child: ListView.separated(
                            itemCount: provider.notifications.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final notification = provider.notifications[index];
                              return NotificationCard(
                                notification: notification,
                                onTap: () {
                                  if (!notification.read) {
                                    provider.markAsRead(notification.id);
                                  }
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
