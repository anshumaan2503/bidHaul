import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final double labelWidth;
  final EdgeInsetsGeometry padding;
  final IconData? icon;
  final TextStyle? valueStyle;
  final Color? valueColor;

  const InfoRow({
    super.key,
    required this.title,
    required this.value,
    this.labelWidth = 100,
    this.padding = const EdgeInsets.only(bottom: AppSpacing.sm + 2),
    this.icon,
    this.valueStyle,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: AppColors.primaryCyan,
            ),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: labelWidth,
            child: Text(
              title,
              style: AppTypography.bodySecondary(),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle ??
                  AppTypography.bodyPrimary(
                    color: valueColor ?? Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

