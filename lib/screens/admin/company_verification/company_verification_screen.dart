import 'package:flutter/material.dart';

import '../../../dummy/dummy_company_verifications.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/cards/company_verification_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';
import 'company_details_screen.dart';

class CompanyVerificationScreen extends StatelessWidget {
  const CompanyVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "Company Verifications"),

          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: ListView.builder(
              itemCount: dummyCompanyVerifications.length,
              itemBuilder: (_, index) {
                final company = dummyCompanyVerifications[index];

                return CompanyVerificationCard(
                  company: company,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompanyDetailsScreen(company: company),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
