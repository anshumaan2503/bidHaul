import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// AnimatedBidHaulLogo
///
/// Ultra-premium logo mark widget for BidHaul.
/// Keeps the emblem mark 100% crisp, sharp, vibrant, and untouched inside,
/// while animating dynamic expanding energy ripple waves and an orbiting halo
/// OUTSIDE around the logo perimeter.
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
  late final AnimationController _rotationController;
  late final AnimationController _rippleController;

  @override
  void initState() {
    super.initState();

    // 1. Slow outer halo orbit rotation (6 seconds loop)
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat();

    // 2. Expanding outer ripple pulse wave loop (2.4 seconds continuous)
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 1.5,
      height: widget.size * 1.5,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // LAYER 1: Expanding Outer Energy Ripple Rings (Outside Logo)
          AnimatedBuilder(
            animation: _rippleController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size * 1.5, widget.size * 1.5),
                painter: _OuterRipplePainter(
                  progress: _rippleController.value,
                  baseSize: widget.size,
                ),
              );
            },
          ),

          // LAYER 2: Orbiting Glowing Light Ring (Outside Perimeter)
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * math.pi,
                child: Container(
                  width: widget.size * 1.18,
                  height: widget.size * 1.18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        const Color(0xFF00F0FF).withValues(alpha: 0.85),
                        const Color(0xFF1D6FFF).withValues(alpha: 0.40),
                        Colors.transparent,
                        const Color(0xFF00F0FF).withValues(alpha: 0.15),
                        const Color(0xFF00F0FF).withValues(alpha: 0.85),
                      ],
                      stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          // LAYER 3: Soft Ambient Backing Diffusion Glow
          Container(
            width: widget.size * 0.95,
            height: widget.size * 0.95,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF00F0FF).withValues(alpha: 0.25),
                  const Color(0xFF1D6FFF).withValues(alpha: 0.15),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),

          // LAYER 4: 100% Crisp, Sharp, Original SVG Emblem Mark
          SvgPicture.asset(
            widget.svgPath,
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

/// CustomPainter to draw 3 expanding, fading energy pulse rings outside the logo mark.
class _OuterRipplePainter extends CustomPainter {
  final double progress;
  final double baseSize;

  _OuterRipplePainter({
    required this.progress,
    required this.baseSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final minRadius = baseSize * 0.52;
    final maxRadius = baseSize * 0.76;

    // Draw 3 staggered expanding ripple rings
    for (int i = 0; i < 3; i++) {
      final ringProgress = (progress + (i * 0.33)) % 1.0;
      final currentRadius = minRadius + (ringProgress * (maxRadius - minRadius));
      final opacity = (1.0 - ringProgress).clamp(0.0, 1.0) * 0.45;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 * (1.0 - (ringProgress * 0.5))
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF00F0FF).withValues(alpha: opacity),
            const Color(0xFF1D6FFF).withValues(alpha: opacity * 0.5),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: currentRadius),
        );

      canvas.drawCircle(center, currentRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OuterRipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
