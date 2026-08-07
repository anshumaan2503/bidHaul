import 'package:flutter/material.dart';

import '../../models/platform_user.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class PlatformUserCard extends StatelessWidget {
  final PlatformUser user;
  final VoidCallback onTap;

  const PlatformUserCard({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.lg,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.glassSurfaceDark,
          borderRadius: AppRadius.lg,
          border: Border.all(color: AppColors.glassBorderDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name, style: AppTypography.h2()),

            const SizedBox(height: AppSpacing.sm),

            Text(
              user.type.name.toUpperCase(),
              style: AppTypography.bodySecondary(color: AppColors.primaryCyan),
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              user.status.name.toUpperCase(),
              style: AppTypography.bodySecondary(
                color: user.status == UserStatus.active
                    ? AppColors.successGreen
                    : AppColors.dangerRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
