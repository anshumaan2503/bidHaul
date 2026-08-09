import 'package:flutter/material.dart';

import '../../theme/app_typography.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final double bottomSpacing;

  const SectionHeader({
    super.key,
    required this.title,
    this.bottomSpacing = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Text(title, style: AppTypography.h2()),
    );
  }
}
