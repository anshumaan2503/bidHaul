import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

class SecondaryButton extends StatefulWidget {
  final String title;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool enabled;
  final double height;

  const SecondaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
    this.enabled = true,
    this.height = 48,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: OutlinedButton(
          onPressed: widget.enabled ? widget.onPressed : null,
          onHover: (hovered) {},
          style: OutlinedButton.styleFrom(
            backgroundColor: widget.enabled
                ? AppColors.glassSurfaceDark
                : Colors.white.withValues(alpha: 0.02),
            side: BorderSide(
              color: widget.enabled
                  ? AppColors.glassBorderDark
                  : Colors.white10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.md,
            ),
          ),
          child: Listener(
            onPointerDown: (_) => setState(() => _isPressed = true),
            onPointerUp: (_) => setState(() => _isPressed = false),
            onPointerCancel: (_) => setState(() => _isPressed = false),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 18,
                    color: widget.enabled ? AppColors.primaryCyan : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.title,
                  style: AppTypography.buttonText(
                    color: widget.enabled ? AppColors.primaryCyan : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
