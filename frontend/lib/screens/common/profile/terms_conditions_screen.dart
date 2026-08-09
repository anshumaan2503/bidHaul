import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Terms & Conditions", style: AppTypography.h2()),
      ),
      body: const Center(
        child: Text(
          "Terms & Conditions",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
