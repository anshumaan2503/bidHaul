import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.enabled = true,
    this.isLoading = false,
    this.icon,
    this.height = 54,
    this.gradient,
    this.textColor,
    this.iconColor,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool isLoading;
  final IconData? icon;
  final double height;
  final Gradient? gradient;
  final Color? textColor;
  final Color? iconColor;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isInteractive = widget.enabled && !widget.isLoading;
    final defaultGradient = widget.gradient ?? AppColors.buttonGradient;
    final activeTextColor = widget.textColor ?? AppColors.darkMidnight;
    final activeIconColor = widget.iconColor ?? activeTextColor;

    return AnimatedScale(
      scale: _isPressed && isInteractive ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: isInteractive
                ? defaultGradient
                : LinearGradient(
                    colors: [
                      Colors.grey.shade800,
                      Colors.grey.shade900,
                    ],
                  ),
            borderRadius: AppRadius.pill,
            boxShadow: isInteractive
                ? [
                    BoxShadow(
                      color: (widget.gradient != null ? Colors.redAccent : AppColors.primaryCyan).withValues(alpha: .30),
                      blurRadius: 18,
                      spreadRadius: 0,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: ElevatedButton(
            onPressed: isInteractive ? widget.onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.pill,
              ),
            ),
            child: Listener(
              onPointerDown: (_) => setState(() => _isPressed = true),
              onPointerUp: (_) => setState(() => _isPressed = false),
              onPointerCancel: (_) => setState(() => _isPressed = false),
              child: widget.isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          activeTextColor,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            size: 20,
                            color: activeIconColor,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.title,
                          style: AppTypography.buttonText(
                            color: isInteractive
                                ? activeTextColor
                                : Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}