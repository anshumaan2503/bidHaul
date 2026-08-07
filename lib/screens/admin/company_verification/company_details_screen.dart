import 'package:flutter/material.dart';

import '../../../models/company_verification.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';
import '../../../widgets/common/info_row.dart';

class CompanyDetailsScreen extends StatelessWidget {
  final CompanyVerification company;

  const CompanyDetailsScreen({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          CommonAppBar(
            title: company.companyName,
            titleStyle: AppTypography.h2(),
          ),

          const SizedBox(height: AppSpacing.xl),

          InfoRow(title: "Owner", value: company.ownerName),
          InfoRow(title: "Email", value: company.email),
          InfoRow(title: "Phone", value: company.phone),
          InfoRow(title: "GST", value: company.gstNumber),
          InfoRow(title: "License", value: company.licenseNumber),
          InfoRow(title: "Address", value: company.address),
          InfoRow(title: "Registered", value: company.registrationDate),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  title: "Approve",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Company Approved"),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: PrimaryButton(
                  title: "Reject",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Company Rejected"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}