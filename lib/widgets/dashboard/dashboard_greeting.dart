import 'package:flutter/material.dart';

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
      return 'Good Morning 👋';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon 👋';
    } else if (hour >= 17 && hour < 22) {
      return 'Good Evening 👋';
    } else {
      return 'Good Night 👋';
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayGreeting = greeting ?? _autoGreeting;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayGreeting, style: AppTypography.bodySecondary()),
        const SizedBox(height: 4),
        Text(title, style: AppTypography.displayHero()),
      ],
    );
  }
}
