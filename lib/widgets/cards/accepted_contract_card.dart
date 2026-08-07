import 'package:flutter/material.dart';

import '../../models/accepted_contract.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';

class AcceptedContractCard extends StatelessWidget {
  final AcceptedContract contract;
  final VoidCallback? onViewDetails;

  const AcceptedContractCard({
    super.key,
    required this.contract,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.glassSurfaceDark,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(contract.company, style: AppTypography.h2()),
              ),
              const Icon(
                Icons.handshake_rounded,
                color: AppColors.successGreen,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          Text("ACCEPTED CONTRACT", style: AppTypography.microBadge()),

          const SizedBox(height: AppSpacing.lg),

          _info("Tender", contract.id),
          _info("Route", "${contract.origin} → ${contract.destination}"),
          _info("Vehicle", contract.vehicleType),
          _info("Amount", "₹${contract.contractAmount.toStringAsFixed(0)}"),
          _info("Pickup", contract.pickupDate),
          _info("Accepted", contract.acceptedOn),
          _info("Status", contract.status),

          const SizedBox(height: AppSpacing.lg),

          PrimaryButton(
            title: "View Details",
            onPressed: onViewDetails ?? () {},
          ),
        ],
      ),
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          SizedBox(
            width: 95,
            child: Text(title, style: AppTypography.bodySecondary()),
          ),
          Expanded(child: Text(value, style: AppTypography.bodyPrimary())),
        ],
      ),
    );
  }
}
