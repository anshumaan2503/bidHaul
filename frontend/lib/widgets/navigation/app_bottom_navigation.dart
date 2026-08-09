import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/notification_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkMidnight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.glassSurfaceDark,
            borderRadius: AppRadius.pill,
            border: Border.all(
              color: AppColors.glassBorderDark,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppRadius.pill,
            child: Consumer<NotificationProvider>(
              builder: (context, notifProvider, _) {
                final unreadCount = notifProvider.unreadCount;

                return NavigationBar(
                  selectedIndex: currentIndex,
                  onDestinationSelected: onTap,
                  backgroundColor: Colors.transparent,
                  indicatorColor: AppColors.primaryCyan.withValues(alpha: .22),
                  elevation: 0,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  destinations: [
                    const NavigationDestination(
                      icon: Icon(Icons.home_outlined, color: AppColors.iceCyan),
                      selectedIcon: Icon(Icons.home_rounded, color: AppColors.primaryCyan),
                      label: "Home",
                    ),
                    const NavigationDestination(
                      icon: Icon(Icons.description_outlined, color: AppColors.iceCyan),
                      selectedIcon: Icon(Icons.description_rounded, color: AppColors.primaryCyan),
                      label: "Tenders",
                    ),
                    const NavigationDestination(
                      icon: Icon(Icons.add_circle_outline, color: AppColors.iceCyan),
                      selectedIcon: Icon(Icons.add_circle_rounded, color: AppColors.primaryCyan),
                      label: "Create",
                    ),
                    NavigationDestination(
                      icon: unreadCount > 0
                          ? Badge(
                              label: Text('$unreadCount'),
                              backgroundColor: AppColors.primaryCyan,
                              child: const Icon(Icons.notifications_outlined, color: AppColors.iceCyan),
                            )
                          : const Icon(Icons.notifications_outlined, color: AppColors.iceCyan),
                      selectedIcon: unreadCount > 0
                          ? Badge(
                              label: Text('$unreadCount'),
                              backgroundColor: AppColors.primaryCyan,
                              child: const Icon(Icons.notifications_rounded, color: AppColors.primaryCyan),
                            )
                          : const Icon(Icons.notifications_rounded, color: AppColors.primaryCyan),
                      label: "Alerts",
                    ),
                    const NavigationDestination(
                      icon: Icon(Icons.person_outline, color: AppColors.iceCyan),
                      selectedIcon: Icon(Icons.person_rounded, color: AppColors.primaryCyan),
                      label: "Profile",
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
