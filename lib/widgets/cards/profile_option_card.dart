import 'package:flutter/material.dart';

import '../../models/profile_option.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/base_glass_card.dart';

class ProfileOptionCard extends StatelessWidget {
  final ProfileOption option;
  final VoidCallback onTap;

  const ProfileOptionCard({
    super.key,
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Icon(option.icon, color: AppColors.primaryCyan),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Text(option.title, style: AppTypography.bodyPrimary()),
          ),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }
}
