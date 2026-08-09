import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class BaseScreenLayout extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;

  const BaseScreenLayout({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget bodyContent = Padding(
      padding: padding,
      child: child,
    );

    if (isScrollable) {
      bodyContent = SingleChildScrollView(
        child: bodyContent,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.darkFluidGradient,
            ),
          ),
          SafeArea(
            child: bodyContent,
          ),
        ],
      ),
    );
  }
}
