import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.label,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final String? label;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelBold(color: AppColors.iceCyan),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: obscureText ? 1 : maxLines,
          readOnly: readOnly,
          enabled: enabled,
          onTap: onTap,
          cursorColor: AppColors.primaryCyan,
          style: AppTypography.bodyPrimary(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodySecondary(),
            prefixIcon: Icon(
              prefixIcon,
              color: AppColors.iceCyan,
              size: 20,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.glassSurfaceDark,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: BorderSide(
                color: AppColors.glassBorderDark,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: BorderSide(
                color: AppColors.glassBorderDark,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.md,
              borderSide: const BorderSide(
                color: AppColors.primaryCyan,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}