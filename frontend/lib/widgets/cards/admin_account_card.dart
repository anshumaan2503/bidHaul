import 'package:flutter/material.dart';

import '../../models/admin_account.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class AdminAccountCard extends StatelessWidget {
  final AdminAccount admin;

  const AdminAccountCard({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(admin.name, style: AppTypography.h2(), overflow: TextOverflow.ellipsis, maxLines: 1),
          const SizedBox(height: AppSpacing.sm),
          Text(admin.email, style: AppTypography.bodySecondary(), overflow: TextOverflow.ellipsis, maxLines: 1),
          const SizedBox(height: AppSpacing.sm),
          Text(admin.role, style: AppTypography.bodyPrimary(), overflow: TextOverflow.ellipsis, maxLines: 1),
        ],
      ),
    );
  }
}
