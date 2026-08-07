import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("About BidHaul", style: AppTypography.h2()),
      ),
      body: const Center(
        child: Text(
          "BidHaul Reverse Auction Platform",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
