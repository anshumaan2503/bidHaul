import 'package:flutter/material.dart';

import '../../theme/app_typography.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const CommonAppBar({
    super.key,
    required this.title,
    this.titleStyle,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBackButton)
          IconButton(
            onPressed: onBackPressed ?? () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
        Expanded(
          child: Text(
            title,
            style: titleStyle ?? AppTypography.displayHero(),
          ),
        ),
        ...?actions,
      ],
    );
  }
}
