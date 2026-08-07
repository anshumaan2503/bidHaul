import 'package:flutter/material.dart';

import '../../models/company_verification.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/base_glass_card.dart';

class CompanyVerificationCard extends StatelessWidget {
  final CompanyVerification company;
  final VoidCallback onTap;

  const CompanyVerificationCard({
    super.key,
    required this.company,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(company.companyName, style: AppTypography.h2()),

          const SizedBox(height: AppSpacing.sm),

          Text(company.ownerName, style: AppTypography.bodyPrimary()),

          const SizedBox(height: AppSpacing.sm),

          Text(
            company.status,
            style: AppTypography.bodySecondary(color: AppColors.warningAmber),
          ),
        ],
      ),
    );
  }
}
