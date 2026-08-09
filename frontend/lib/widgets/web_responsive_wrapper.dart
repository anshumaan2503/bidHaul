import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// WebResponsiveWrapper
/// Centers and scales the Flutter app UI cleanly on Desktop Web Browsers
/// while retaining 100% native edge-to-edge layout on Mobile devices.
class WebResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const WebResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If on Desktop Web or screen width > 650px
        final bool isDesktopWeb = kIsWeb && constraints.maxWidth > 650;

        if (!isDesktopWeb) {
          return child;
        }

        return Container(
          color: const Color(0xFF070A11), // Dark Executive Slate Background
          child: Stack(
            children: [
              // Subtle background ambient glows
              Positioned(
                top: -100,
                left: -100,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryBlue.withValues(alpha: 0.12),
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                right: -100,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryCyan.withValues(alpha: 0.10),
                  ),
                ),
              ),
              // Centered Phone Frame Layout
              Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 480,
                    maxHeight: 960,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.darkMidnight,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AppColors.glassBorderDark.withValues(alpha: 0.8),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 32,
                        spreadRadius: 4,
                        offset: const Offset(0, 12),
                      ),
                      BoxShadow(
                        color: AppColors.primaryCyan.withValues(alpha: 0.08),
                        blurRadius: 20,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
