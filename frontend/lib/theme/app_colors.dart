import 'package:flutter/material.dart';

/// BidHaul Design System - Color Palette Tokens
/// Ultra-Luxury Dark Espresso & Warm Gold / Bronze Aesthetic
abstract class AppColors {
  // Brand Primary & Accent Colors (Warm Butter Gold & Luxury Bronze)
  static const Color primaryCyan = Color(0xFFFDE68A); // Soft Butter Gold / Primary CTA
  static const Color primaryBlue = Color(0xFF9E7B56); // Warm Caramel Bronze Accent
  static const Color glowCyan = Color(0xFFFCE996); // Vibrant Gold Glow
  static const Color iceCyan = Color(0xFFD4C4B5); // Muted Cream / Secondary Text Token
  static const Color darkMidnight = Color(0xFF14100D); // Deep Espresso Dark Background

  // Dark Theme Gradient Background Tokens (Espresso to Warm Chocolate)
  static const Color bgStop1 = Color(0xFF18120E);
  static const Color bgStop2 = Color(0xFF221A13);
  static const Color bgStop3 = Color(0xFF2A1F17);
  static const Color bgStop4 = Color(0xFF1E1711);
  static const Color bgStop5 = Color(0xFF33251B);
  static const Color bgStop6 = Color(0xFF3D2C20);
  static const Color bgStop7 = Color(0xFF14100D);
  static const Color bgStop8 = Color(0xFF1C1510);

  // Surface & Container Colors
  static Color glassSurfaceDark = const Color(0xFF241A13); // Warm Espresso Container
  static Color glassSurfaceElevated = const Color(0xFF2C1F17); // Elevated Glass Card Fill
  static Color glassBorderDark = const Color(0xFF4A382A); // Soft Bronze Border
  static Color glassBorderLight = const Color(0xFF9E7B56).withValues(alpha: 0.20);
  static Color glassSurfaceLight = Colors.black.withValues(alpha: 0.04);
  
  // Bronze Highlight Card Colors (For featured cards like 'Financial Goals' / 'Savings')
  static const Color bronzeContainer = Color(0xFF3D2E22);
  static const Color bronzeContainerLight = Color(0xFF594330);

  // Functional / Status Colors
  static const Color successGreen = Color(0xFF34D399); // Soft Emerald Green
  static const Color warningAmber = Color(0xFFFBBF24); // Warm Gold Amber
  static const Color dangerRed = Color(0xFFFF6B6B); // Soft Coral Red
  static const Color infoCyan = Color(0xFF60A5FA); // Soft Blue Info

  // Light Theme Tokens
  static const Color lightBackground = Color(0xFFFDFBF7);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF271C15);
  static const Color lightTextSecondary = Color(0xFF786252);
  static const Color lightBorder = Color(0xFFE8DFD5);

  // Gradient Constants
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFDE68A), Color(0xFFF7D070), Color(0xFFE5B54E)],
  );

  static const LinearGradient bronzeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF594330), Color(0xFF3D2E22)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF281E16), Color(0xFF1C150E)],
  );

  static const LinearGradient darkFluidGradient = LinearGradient(
    begin: Alignment(-1.2, -1.0),
    end: Alignment(1.2, 1.0),
    colors: [bgStop1, bgStop2, bgStop5, bgStop7],
  );

  static Color? statusAmber;

  /// Helper getter for status badge colors
  static Color getStatusColor(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('live') ||
        lower.contains('accepted') ||
        lower.contains('completed') ||
        lower.contains('active') ||
        lower.contains('approved') ||
        lower.contains('success')) {
      return successGreen;
    }
    if (lower.contains('pending') ||
        lower.contains('draft') ||
        lower.contains('negotiat') ||
        lower.contains('in review')) {
      return warningAmber;
    }
    if (lower.contains('reject') ||
        lower.contains('cancel') ||
        lower.contains('expired') ||
        lower.contains('fail')) {
      return dangerRed;
    }
    return primaryCyan;
  }

  /// Helper getter for status badge background tints
  static Color getStatusBg(String status) {
    return getStatusColor(status).withValues(alpha: 0.15);
  }
}


