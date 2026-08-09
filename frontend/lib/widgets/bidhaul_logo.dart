import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'animated_bidhaul_logo.dart';

/// BidHaulLogo
///
/// Modular layout wrapper widget combining the official [AnimatedBidHaulLogo] icon mark,
/// clean enterprise typography, and an optional glowing "Get Started" action button.
class BidHaulLogo extends StatelessWidget {
  /// Layout orientation: vertical (logo mark above text) or horizontal (side-by-side).
  final bool isVertical;

  /// Width and height of the SVG icon mark. Default is 190.0.
  final double logoSize;

  /// Whether to display the tagline subtitle ("SMART REVERSE AUCTIONS"). Default is true.
  final bool showSubtitle;

  /// Custom typography color for "BidHaul". Default is Colors.white.
  final Color? textColor;

  /// Custom typography color for subtitle text. Default is Color(0xFF8AD2EA).
  final Color? subtitleColor;

  /// Whether to display the "Get Started" call-to-action button. Default is true.
  final bool showGetStarted;

  /// Callback when the "Get Started" button is tapped.
  final VoidCallback? onGetStartedPressed;

  /// Optional callback when the logo mark icon itself is tapped.
  final VoidCallback? onLogoTap;

  /// Retained for backwards compatibility.
  final bool animateEntrance;

  const BidHaulLogo({
    super.key,
    this.isVertical = true,
    this.logoSize = 190.0,
    this.showSubtitle = true,
    this.textColor,
    this.subtitleColor,
    this.showGetStarted = true,
    this.onGetStartedPressed,
    this.onLogoTap,
    this.animateEntrance = false,
  });

  @override
  Widget build(BuildContext context) {
    final Widget iconMark = GestureDetector(
      onTap: onLogoTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBidHaulLogo(
        size: logoSize,
        animateEntrance: animateEntrance,
      ),
    );

    final Widget textSection = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'BidHaul',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: isVertical ? 34 : 26,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: textColor ?? Colors.white,
            height: 1.1,
            shadows: [
              Shadow(
                color: AppColors.primaryCyan.withValues(alpha: 0.35),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 6),
          Text(
            'SMART REVERSE AUCTIONS',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.8,
              color: subtitleColor ?? AppColors.iceCyan.withValues(alpha: 0.90),
            ),
          ),
        ],
        if (showGetStarted) ...[
          const SizedBox(height: 28),
          _GetStartedButton(onPressed: onGetStartedPressed),
        ],
      ],
    );

    if (isVertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: iconMark),
          const SizedBox(height: 18),
          Center(child: textSection),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        iconMark,
        const SizedBox(width: 18),
        textSection,
      ],
    );
  }
}

/// Enterprise glowing "Get Started" action button widget.
class _GetStartedButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const _GetStartedButton({this.onPressed});

  @override
  State<_GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<_GetStartedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _hoverController.forward(),
      onTapUp: (_) {
        _hoverController.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _hoverController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 210,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: AppColors.buttonGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryCyan.withValues(alpha: 0.35),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: widget.onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started',
                      style: GoogleFonts.inter(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.darkMidnight,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.darkMidnight,
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 15,
                        color: AppColors.primaryCyan,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}