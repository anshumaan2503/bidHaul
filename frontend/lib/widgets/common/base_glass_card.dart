import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class BaseGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final Gradient? gradient;
  final bool hasGlow;

  const BaseGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.gradient,
    this.hasGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppRadius.lg;
    final effectiveBorderColor = borderColor ?? AppColors.glassBorderDark;

    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: backgroundColor ?? (gradient == null ? AppColors.glassSurfaceDark : null),
        gradient: gradient ??
            (backgroundColor == null
                ? AppColors.cardGradient
                : null),
        borderRadius: effectiveRadius,
        border: Border.all(
          color: effectiveBorderColor,
          width: hasGlow ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: hasGlow
                ? AppColors.primaryCyan.withValues(alpha: 0.20)
                : Colors.black.withValues(alpha: 0.35),
            blurRadius: hasGlow ? 20 : 16,
            spreadRadius: hasGlow ? 1 : 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Container(
        margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.lg),
        child: Material(
          color: Colors.transparent,
          borderRadius: effectiveRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: effectiveRadius,
            splashColor: AppColors.primaryCyan.withValues(alpha: 0.08),
            highlightColor: AppColors.primaryBlue.withValues(alpha: 0.12),
            child: cardContent,
          ),
        ),
      );
    }

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.lg),
      child: cardContent,
    );
  }
}

