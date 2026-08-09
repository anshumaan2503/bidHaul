import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class AppStatusBadge extends StatelessWidget {
  final String status;
  final Color? color;
  final Color? backgroundColor;
  final IconData? icon;

  const AppStatusBadge({
    super.key,
    required this.status,
    this.color,
    this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.getStatusColor(status);
    final effectiveBg = backgroundColor ?? AppColors.getStatusBg(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: effectiveColor.withValues(alpha: 0.35),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: effectiveColor),
            const SizedBox(width: 4),
          ] else ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: effectiveColor,
                boxShadow: [
                  BoxShadow(
                    color: effectiveColor.withValues(alpha: 0.6),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            status.toUpperCase(),
            style: AppTypography.microBadge(color: effectiveColor),
          ),
        ],
      ),
    );
  }
}
