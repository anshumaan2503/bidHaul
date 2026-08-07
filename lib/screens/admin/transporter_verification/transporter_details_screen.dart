import 'package:flutter/material.dart';

import '../../../models/transporter_verification.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';
import '../../../widgets/common/info_row.dart';

class TransporterDetailsScreen extends StatelessWidget {
  final TransporterVerification transporter;

  const TransporterDetailsScreen({super.key, required this.transporter});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          CommonAppBar(
            title: transporter.transporterName,
            titleStyle: AppTypography.h2(),
          ),

          const SizedBox(height: AppSpacing.xl),

          InfoRow(title: "Owner", value: transporter.ownerName),
          InfoRow(title: "Email", value: transporter.email),
          InfoRow(title: "Phone", value: transporter.phone),
          InfoRow(title: "Vehicle", value: transporter.vehicleType),
          InfoRow(title: "Fleet", value: transporter.fleetSize),
          InfoRow(title: "License", value: transporter.licenseNumber),
          InfoRow(title: "Registered", value: transporter.registrationDate),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  title: "Approve",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Transporter Approved"),
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
                        content: Text("Transporter Rejected"),
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
