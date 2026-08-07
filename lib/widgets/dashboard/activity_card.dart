import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppRadius.lg,
        color: Colors.white.withValues(alpha: .05),
        border: Border.all(
          color: AppColors.glassBorderDark,
        ),
      ),
      child: Row(
        children: [

          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              gradient: AppColors.buttonGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: AppTypography.h3(),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: AppTypography.bodySecondary(),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}