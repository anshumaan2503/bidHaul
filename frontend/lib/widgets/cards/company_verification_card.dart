import 'package:flutter/material.dart';

import '../../models/company_verification.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/app_status_badge.dart';
import '../common/base_glass_card.dart';
import '../common/info_row.dart';

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
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.25),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: AppColors.glassBorderDark,
                  ),
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.primaryCyan,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.companyName,
                      style: AppTypography.cardTitle(),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Owner: ${company.ownerName}",
                      style: AppTypography.bodySecondary(),
                    ),
                  ],
                ),
              ),
              AppStatusBadge(status: company.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: AppRadius.md,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              children: [
                InfoRow(
                  title: "Company ID",
                  value: "#${company.id}",
                  icon: Icons.numbers_rounded,
                ),
                InfoRow(
                  title: "Verification",
                  value: company.status.toUpperCase(),
                  icon: Icons.shield_rounded,
                  valueColor: AppColors.getStatusColor(company.status),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

