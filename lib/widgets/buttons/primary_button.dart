import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.enabled = true,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled
              ? AppColors.buttonGradient
              : LinearGradient(
                  colors: [
                    Colors.grey.shade600,
                    Colors.grey.shade700,
                  ],
                ),
          borderRadius: AppRadius.pill,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primaryCyan.withValues(alpha: .35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.pill,
            ),
          ),
          child: Text(
            title,
            style: AppTypography.buttonText(),
          ),
        ),
      ),
    );
  }
}