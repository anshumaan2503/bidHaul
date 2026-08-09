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
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.glassSurfaceDark.withValues(alpha: 0.85),
        borderRadius: AppRadius.xl,
        border: Border.all(
          color: AppColors.glassBorderDark,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(
            Icons.search_rounded,
            color: AppColors.primaryCyan,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: onChanged != null
                ? TextField(
                    onChanged: onChanged,
                    onTap: onTap,
                    cursorColor: AppColors.primaryCyan,
                    style: AppTypography.bodyPrimary(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: AppTypography.bodySecondary(
                        color: Colors.white.withValues(alpha: 0.50),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                : InkWell(
                    onTap: onTap,
                    borderRadius: AppRadius.xl,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        hintText,
                        style: AppTypography.bodySecondary(
                          color: Colors.white.withValues(alpha: 0.50),
                        ),
                      ),
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.primaryCyan.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primaryCyan.withValues(alpha: 0.25),
              ),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: AppColors.primaryCyan,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}