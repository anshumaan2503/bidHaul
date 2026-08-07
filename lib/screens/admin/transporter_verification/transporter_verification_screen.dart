import 'package:flutter/material.dart';

import '../../../dummy/dummy_transporter_verifications.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/cards/transporter_verification_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';
import 'transporter_details_screen.dart';

class TransporterVerificationScreen extends StatelessWidget {
  const TransporterVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "Transporter Verifications"),

          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: ListView.builder(
              itemCount: dummyTransporterVerifications.length,
              itemBuilder: (_, index) {
                final transporter = dummyTransporterVerifications[index];

                return TransporterVerificationCard(
                  transporter: transporter,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TransporterDetailsScreen(
                          transporter: transporter,
                        ),
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