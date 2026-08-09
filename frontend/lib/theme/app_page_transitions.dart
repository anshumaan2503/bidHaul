import 'package:flutter/material.dart';

/// Luxury SaaS Page Transition Builder for Flutter ThemeData
///
/// Implements a 60/120fps Fade + Scale + Curved Slide transition
/// that elevates default screen transitions to Apple/Stripe-level luxury quality.
class LuxuryPageTransitionsBuilder extends PageTransitionsBuilder {
  const LuxuryPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Primary Curved Entrance Animation
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    // Slide Offset (Subtle 5% slide from right to left)
    final slideTween = Tween<Offset>(
      begin: const Offset(0.05, 0.0),
      end: Offset.zero,
    );

    // Micro-Scale (Subtle 0.96 -> 1.0 expansion)
    final scaleTween = Tween<double>(
      begin: 0.96,
      end: 1.0,
    );

    // Opacity Fade (0.0 -> 1.0)
    final fadeTween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    );

    return FadeTransition(
      opacity: fadeTween.animate(curvedAnimation),
      child: ScaleTransition(
        scale: scaleTween.animate(curvedAnimation),
        child: SlideTransition(
          position: slideTween.animate(curvedAnimation),
          child: child,
        ),
      ),
    );
  }
}

/// Utility for custom explicit transitions when desired
class AppPageRoute {
  /// Default Ultra-Smooth Screen Route Transition (Login -> Dashboard, etc.)
  static Route<T> create<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);
        final scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(curvedAnimation);
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.04, 0.0),
          end: Offset.zero,
        ).animate(curvedAnimation);

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Slide Up Bottom Sheet Transition
  static Route<T> slideUp<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        final slideTween = Tween<Offset>(
          begin: const Offset(0.0, 0.12),
          end: Offset.zero,
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: slideTween.animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// Fade + Zoom Scale Transition
  static Route<T> fadeScale<T>(Widget page) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutQuart,
          reverseCurve: Curves.easeInQuart,
        );

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}
