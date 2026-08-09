import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const CommonAppBar({
    super.key,
    required this.title,
    this.titleStyle,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (showBackButton) ...[
            Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppColors.glassSurfaceDark,
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: AppColors.glassBorderDark,
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: onBackPressed ?? () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primaryCyan,
                  size: 18,
                ),
              ),
            ),
          ],
          Expanded(
            child: Text(
              title,
              style: titleStyle ?? AppTypography.h1(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ...?actions,
        ],
      ),
    );
  }
}

