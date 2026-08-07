import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.hint = 'Search...',
    String? hintText,
    this.onTap,
    this.onChanged,
  }) : hintText = hintText ?? hint;

  final String hint;
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .06),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: AppColors.glassBorderDark,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 18),
          const Icon(
            Icons.search_rounded,
            color: AppColors.primaryCyan,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: onChanged != null
                ? TextField(
                    onChanged: onChanged,
                    onTap: onTap,
                    cursorColor: AppColors.primaryCyan,
                    style: AppTypography.bodyPrimary(),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: AppTypography.bodySecondary(),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  )
                : InkWell(
                    onTap: onTap,
                    borderRadius: AppRadius.lg,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        hintText,
                        style: AppTypography.bodySecondary(),
                      ),
                    ),
                  ),
          ),
          const Icon(
            Icons.tune_rounded,
            color: Colors.white54,
          ),
          const SizedBox(width: 18),
        ],
      ),
    );
  }
}