import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/base_glass_card.dart';

class AdminDashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final VoidCallback onTap;

  const AdminDashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.25),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: AppColors.glassBorderDark,
              ),
            ),
            child: Icon(
              icon ?? Icons.admin_panel_settings_rounded,
              color: AppColors.primaryCyan,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.cardTitle()),
                const SizedBox(height: 3),
                Text(subtitle, style: AppTypography.bodySecondary()),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.iceCyan,
            size: 16,
          ),
        ],
      ),
    );
  }
}

