import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// BidHaul Design System - Typography Scale Tokens
/// High-End Executive SaaS Typography System
abstract class AppTypography {
  // Display & Title Styles (Outfit Font)
  static TextStyle displayHero({Color color = Colors.white}) => GoogleFonts.outfit(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: color,
        height: 1.15,
        shadows: [
          Shadow(
            color: AppColors.primaryCyan.withValues(alpha: 0.30),
            blurRadius: 16,
          ),
        ],
      );

  static TextStyle h1({Color color = Colors.white}) => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: color,
        height: 1.2,
      );

  static TextStyle h2({Color color = Colors.white}) => GoogleFonts.outfit(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: color,
        height: 1.25,
      );

  static TextStyle h3({Color color = Colors.white}) => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: color,
        height: 1.3,
      );

  static TextStyle cardTitle({Color color = Colors.white}) => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: color,
      );

  static TextStyle priceText({Color color = AppColors.primaryCyan}) => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: color,
      );

  static TextStyle statValue({Color color = Colors.white}) => GoogleFonts.outfit(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
        color: color,
      );

  static TextStyle statLabel({Color? color}) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
        color: color ?? AppColors.iceCyan.withValues(alpha: 0.8),
      );

  // Subtitle, Body & Label Styles (Inter Font)
  static TextStyle subtitle({Color? color}) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.8,
        color: color ?? AppColors.iceCyan.withValues(alpha: 0.90),
      );

  static TextStyle microBadge({Color? color}) => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: color ?? Colors.white.withValues(alpha: 0.90),
      );

  static TextStyle bodyPrimary({Color color = Colors.white}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: color,
      );

  static TextStyle bodySecondary({Color? color}) => GoogleFonts.inter(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color ?? AppColors.iceCyan.withValues(alpha: 0.75),
      );

  static TextStyle labelBold({Color color = Colors.white}) => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle buttonText({Color color = AppColors.darkMidnight}) => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: color,
      );
}

