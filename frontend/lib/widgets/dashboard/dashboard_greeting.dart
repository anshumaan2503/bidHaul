import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class DashboardGreeting extends StatelessWidget {
  final String? greeting;
  final String title;

  const DashboardGreeting({
    super.key,
    this.greeting,
    required this.title,
  });

  String get _autoGreeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning ☀️';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon 🌤️';
    } else if (hour >= 17 && hour < 22) {
      return 'Good Evening 🌙';
    } else {
      return 'Good Night 🌙';
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayGreeting = greeting ?? _autoGreeting;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              displayGreeting.toUpperCase(),
              style: AppTypography.microBadge(color: AppColors.iceCyan),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.successGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppColors.successGreen.withValues(alpha: 0.3),
                ),
              ),
              child: const Text(
                'SYSTEM ONLINE',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.successGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: AppTypography.displayHero(),
        ),
      ],
    );
  }
}
