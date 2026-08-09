import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/admin_kyc_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/transporter_verification_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';
import 'transporter_details_screen.dart';

class TransporterVerificationScreen extends StatefulWidget {
  const TransporterVerificationScreen({super.key});

  @override
  State<TransporterVerificationScreen> createState() => _TransporterVerificationScreenState();
}

class _TransporterVerificationScreenState extends State<TransporterVerificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminKycProvider>(context, listen: false).fetchTransporterApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminKycProvider>(context);

    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "Transporter Verifications"),
          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryCyan),
                  )
                : provider.transporterApplications.isEmpty
                    ? Center(
                        child: Text(
                          "No transporter verification applications found",
                          style: AppTypography.bodySecondary(),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => provider.fetchTransporterApplications(),
                        color: AppColors.primaryCyan,
                        child: ListView.builder(
                          itemCount: provider.transporterApplications.length,
                          itemBuilder: (_, index) {
                            final transporter = provider.transporterApplications[index];

                            return TransporterVerificationCard(
                              transporter: transporter,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TransporterDetailsScreen(
                                      transporter: transporter,
                                    ),
                                  ),
                                );
                                if (context.mounted) {
                                  provider.fetchTransporterApplications();
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