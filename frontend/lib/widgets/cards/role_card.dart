import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class RoleCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String tag;
  final IconData icon;
  final List<String> features;
  final bool selected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.icon,
    required this.features,
    required this.selected,
    required this.onTap,
  });

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selected;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: AppRadius.xl,
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.glassSurfaceElevated,
                    AppColors.glassSurfaceDark,
                    AppColors.primaryBlue.withValues(alpha: 0.25),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.glassSurfaceDark.withValues(alpha: 0.8),
                    AppColors.darkMidnight.withValues(alpha: 0.9),
                  ],
                ),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryCyan
                : Colors.white.withValues(alpha: 0.08),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryCyan.withValues(alpha: 0.22),
                    blurRadius: 20,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.40),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.xl,
            onTapDown: (_) => _scaleController.forward(),
            onTapUp: (_) {
              _scaleController.reverse();
              widget.onTap();
            },
            onTapCancel: () => _scaleController.reverse(),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header Row: Icon + Title + Selection Indicator
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Animated Icon Box
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.md,
                          gradient: isSelected
                              ? AppColors.buttonGradient
                              : LinearGradient(
                                  colors: [
                                    AppColors.primaryBlue.withValues(alpha: 0.3),
                                    Colors.black.withValues(alpha: 0.3),
                                  ],
                                ),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryCyan
                                : AppColors.glassBorderDark,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryCyan.withValues(alpha: 0.35),
                                    blurRadius: 12,
                                  ),
                                ]
                              : [],
                        ),
                        child: Icon(
                          widget.icon,
                          color: isSelected ? AppColors.darkMidnight : AppColors.primaryCyan,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tag Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryCyan.withValues(alpha: 0.18)
                                    : Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryCyan.withValues(alpha: 0.4)
                                      : Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: Text(
                                widget.tag.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                  color: isSelected ? AppColors.primaryCyan : AppColors.iceCyan,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.title,
                              style: AppTypography.h2(
                                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.90),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Custom Animated Radio Check Indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.primaryCyan : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryCyan
                                : Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primaryCyan.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                  ),
                                ]
                              : [],
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_rounded,
                                color: AppColors.darkMidnight,
                                size: 16,
                              )
                            : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Subtitle / Description
                  Text(
                    widget.subtitle,
                    style: AppTypography.bodySecondary(
                      color: Colors.white.withValues(alpha: 0.70),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Divider line
                  Container(
                    height: 1,
                    color: isSelected
                        ? AppColors.primaryCyan.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.05),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Feature Bullet Points
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: widget.features.map((feature) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryBlue.withValues(alpha: 0.25)
                              : Colors.black.withValues(alpha: 0.2),
                          borderRadius: AppRadius.sm,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryCyan.withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.04),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bolt_rounded,
                              size: 13,
                              color: isSelected ? AppColors.primaryCyan : AppColors.iceCyan,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              feature,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.95)
                                    : AppColors.iceCyan.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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