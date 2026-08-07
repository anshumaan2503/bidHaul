import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Privacy Policy", style: AppTypography.h2()),
      ),
      body: const Center(
        child: Text("Privacy Policy", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
