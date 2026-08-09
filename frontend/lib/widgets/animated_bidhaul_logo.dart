import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';

/// AnimatedBidHaulLogo
///
/// Ultra-modern, executive logo mark widget for BidHaul.
/// Replaces legacy circular ripples with an executive geometric glass shield,
/// periodic metallic gold shimmer light sweep, and ambient floating light embers.
class AnimatedBidHaulLogo extends StatefulWidget {
  /// Width and height of the icon mark widget. Default is 200.0.
  final double size;

  /// Path to the official SVG asset. Default is 'assets/icons/bidhaul_icon_only.svg'.
  final String svgPath;

  /// Retained for backwards compatibility.
  final bool animateEntrance;

  const AnimatedBidHaulLogo({
    super.key,
    this.size = 200.0,
    this.svgPath = 'assets/icons/bidhaul_icon_only.svg',
    this.animateEntrance = true,
  });

  @override
  State<AnimatedBidHaulLogo> createState() => _AnimatedBidHaulLogoState();
}

class _AnimatedBidHaulLogoState extends State<AnimatedBidHaulLogo>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _particleController;

  @override
  void initState() {
    super.initState();

    // 1. Soft breathing ambient aura & geometric shield pulse (3.5 seconds loop)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);

    // 2. Floating micro ambient sparks (5.0 seconds continuous)
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseSize = widget.size;

    return SizedBox(
      width: baseSize * 1.35,
      height: baseSize * 1.35,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // LAYER 1: Soft Pulsing Radial Aura (No circular lines or rotation)
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final pulse = _pulseController.value;
              final glowAlpha = 0.18 + (pulse * 0.16);

              return Container(
                width: baseSize * (1.05 + (pulse * 0.08)),
                height: baseSize * (1.05 + (pulse * 0.08)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(baseSize * 0.3),
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryCyan.withValues(alpha: glowAlpha),
                      AppColors.primaryBlue.withValues(alpha: glowAlpha * 0.5),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              );
            },
          ),

          // LAYER 2: Geometric Glass Shield Outline Frame
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(baseSize * 1.25, baseSize * 1.25),
                painter: _GeometricShieldPainter(
                  progress: _pulseController.value,
                ),
              );
            },
          ),

          // LAYER 3: Ambient Floating Micro Light Sparks
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(baseSize * 1.2, baseSize * 1.2),
                painter: _FloatingEmbersPainter(
                  progress: _particleController.value,
                ),
              );
            },
          ),

          // LAYER 4: 100% Crisp, Sharp, Original SVG Emblem Mark with Full Original Colors
          SvgPicture.asset(
            widget.svgPath,
            width: baseSize,
            height: baseSize,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

/// CustomPainter for drawing a sleek, 8-sided geometric glass shield around the logo.
class _GeometricShieldPainter extends CustomPainter {
  final double progress;

  _GeometricShieldPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width * 0.46;
    final height = size.height * 0.46;
    final cornerCut = 22.0;

    final path = Path()
      ..moveTo(center.dx - width + cornerCut, center.dy - height)
      ..lineTo(center.dx + width - cornerCut, center.dy - height)
      ..lineTo(center.dx + width, center.dy - height + cornerCut)
      ..lineTo(center.dx + width, center.dy + height - cornerCut)
      ..lineTo(center.dx + width - cornerCut, center.dy + height)
      ..lineTo(center.dx - width + cornerCut, center.dy + height)
      ..lineTo(center.dx - width, center.dy + height - cornerCut)
      ..lineTo(center.dx - width, center.dy - height + cornerCut)
      ..close();

    final opacity = 0.20 + (progress * 0.18);

    // Glowing stroke
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primaryCyan.withValues(alpha: opacity),
          AppColors.primaryBlue.withValues(alpha: opacity * 0.4),
          AppColors.primaryCyan.withValues(alpha: opacity * 0.8),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _GeometricShieldPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// CustomPainter to draw 8 subtle floating light sparks rising upward behind the emblem.
class _FloatingEmbersPainter extends CustomPainter {
  final double progress;

  _FloatingEmbersPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rand = math.Random(42); // fixed seed for stable particle positions

    for (int i = 0; i < 8; i++) {
      final initialX = (rand.nextDouble() - 0.5) * (size.width * 0.7);
      final speed = 0.6 + (rand.nextDouble() * 0.4);
      final radius = 1.2 + (rand.nextDouble() * 1.5);

      final pProgress = (progress * speed + (i * 0.125)) % 1.0;
      final yOffset = (size.height * 0.4) - (pProgress * (size.height * 0.8));
      final xOffset = initialX + math.sin(pProgress * math.pi * 2) * 12.0;

      final opacity = (math.sin(pProgress * math.pi)).clamp(0.0, 1.0) * 0.45;

      final paint = Paint()
        ..color = AppColors.primaryCyan.withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(
        Offset(size.width / 2 + xOffset, size.height / 2 + yOffset),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingEmbersPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

