import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/admin_kyc_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/company_verification_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';
import 'company_details_screen.dart';

class CompanyVerificationScreen extends StatefulWidget {
  const CompanyVerificationScreen({super.key});

  @override
  State<CompanyVerificationScreen> createState() => _CompanyVerificationScreenState();
}

class _CompanyVerificationScreenState extends State<CompanyVerificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminKycProvider>(context, listen: false).fetchCompanyApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminKycProvider>(context);

    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "Company Verifications"),
          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryCyan),
                  )
                : provider.companyApplications.isEmpty
                    ? Center(
                        child: Text(
                          "No company verification applications found",
                          style: AppTypography.bodySecondary(),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => provider.fetchCompanyApplications(),
                        color: AppColors.primaryCyan,
                        child: ListView.builder(
                          itemCount: provider.companyApplications.length,
                          itemBuilder: (_, index) {
                            final company = provider.companyApplications[index];

                            return CompanyVerificationCard(
                              company: company,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CompanyDetailsScreen(company: company),
                                  ),
                                );
                                if (context.mounted) {
                                  provider.fetchCompanyApplications();
                                }
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
