import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/base_glass_card.dart';

class AdminDashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AdminDashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.h2()),

          const SizedBox(height: AppSpacing.sm),

          Text(subtitle, style: AppTypography.bodySecondary()),
        ],
      ),
    );
  }
}
