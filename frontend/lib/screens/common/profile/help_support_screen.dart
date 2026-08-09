import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Help & Support", style: AppTypography.h2()),
      ),
      body: const Center(
        child: Text(
          "Support content goes here.",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
