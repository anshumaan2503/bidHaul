import 'package:flutter/material.dart';

import '../../models/settings_item.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class SettingsCard extends StatelessWidget {
  final SettingsItem item;
  final VoidCallback? onTap;

  const SettingsCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.glassSurfaceDark,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(item.icon, color: AppColors.primaryCyan),
        title: Text(item.title, style: AppTypography.h3()),
        subtitle: Text(item.subtitle, style: AppTypography.bodySecondary()),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white),
      ),
    );
  }
}
