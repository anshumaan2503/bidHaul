import 'package:flutter/material.dart';

/// BidHaul Design System - Color Palette Tokens
abstract class AppColors {
  // Brand Primary & Accent Colors
  static const Color primaryCyan = Color(0xFF00F0FF);
  static const Color primaryBlue = Color(0xFF1D6FFF);
  static const Color glowCyan = Color(0xFF00D2FF);
  static const Color iceCyan = Color(0xFF8AD2EA);
  static const Color darkMidnight = Color(0xFF040E21);

  // Dark Theme Gradient Background Tokens
  static const Color bgStop1 = Color(0xFF0C244A);
  static const Color bgStop2 = Color(0xFF143B70);
  static const Color bgStop3 = Color(0xFF164882);
  static const Color bgStop4 = Color(0xFF0F315E);
  static const Color bgStop5 = Color(0xFF0E548A);
  static const Color bgStop6 = Color(0xFF1B62A3);
  static const Color bgStop7 = Color(0xFF0A1D3B);
  static const Color bgStop8 = Color(0xFF0E2D57);

  // Surface & Glassmorphism Colors
  static Color glassSurfaceDark = Colors.white.withValues(alpha: 0.08);
  static Color glassBorderDark = Colors.white.withValues(alpha: 0.15);
  static Color glassSurfaceLight = Colors.black.withValues(alpha: 0.04);
  static Color glassBorderLight = const Color(0xFF1D6FFF).withValues(alpha: 0.20);

  // Functional / Status Colors
  static const Color successGreen = Color(0xFF00E676);
  static const Color warningAmber = Color(0xFFFFB800);
  static const Color dangerRed = Color(0xFFFF3B30);
  static const Color infoCyan = Color(0xFF00F0FF);

  // Light Theme Tokens
  static const Color lightBackground = Color(0xFFF4F7FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Gradient Constants
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryCyan, primaryBlue],
  );

  static const LinearGradient darkFluidGradient = LinearGradient(
    begin: Alignment(-1.2, -1.0),
    end: Alignment(1.2, 1.0),
    colors: [bgStop1, bgStop2, bgStop5, bgStop7],
  );

  static Color? statusAmber;
}
