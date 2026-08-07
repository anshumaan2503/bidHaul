import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final double labelWidth;
  final EdgeInsetsGeometry padding;

  const InfoRow({
    super.key,
    required this.title,
    required this.value,
    this.labelWidth = 120,
    this.padding = const EdgeInsets.only(bottom: AppSpacing.md),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
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
              style: AppTypography.bodyPrimary(),
            ),
          ),
        ],
      ),
    );
  }
}
