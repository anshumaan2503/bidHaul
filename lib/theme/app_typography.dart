import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// BidHaul Design System - Typography Scale Tokens
abstract class AppTypography {
  // Display & Title Styles (Outfit Font)
  static TextStyle displayHero({Color color = Colors.white}) => GoogleFonts.outfit(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: color,
        height: 1.1,
        shadows: [
          Shadow(
            color: AppColors.primaryCyan.withValues(alpha: 0.35),
            blurRadius: 12,
          ),
        ],
      );

  static TextStyle h1({Color color = Colors.white}) => GoogleFonts.outfit(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: color,
        height: 1.2,
      );

  static TextStyle h2({Color color = Colors.white}) => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: color,
        height: 1.25,
      );

  static TextStyle h3({Color color = Colors.white}) => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.25,
        color: color,
        height: 1.3,
      );

  // Subtitle, Body & Label Styles (Inter Font)
  static TextStyle subtitle({Color? color}) => GoogleFonts.inter(
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.8,
        color: color ?? AppColors.iceCyan.withValues(alpha: 0.90),
      );

  static TextStyle microBadge({Color? color}) => GoogleFonts.inter(
        fontSize: 9.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.4,
        color: color ?? Colors.white.withValues(alpha: 0.60),
      );

  static TextStyle bodyPrimary({Color color = Colors.white}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color,
      );

  static TextStyle bodySecondary({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color ?? Colors.white.withValues(alpha: 0.70),
      );

  static TextStyle buttonText({Color color = AppColors.darkMidnight}) => GoogleFonts.inter(
        fontSize: 15.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: color,
      );
}
