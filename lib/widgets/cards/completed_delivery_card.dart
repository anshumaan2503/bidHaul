import 'package:flutter/material.dart';

import '../../models/completed_delivery.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';

class CompletedDeliveryCard extends StatelessWidget {
  final CompletedDelivery delivery;
  final VoidCallback? onViewReceipt;

  const CompletedDeliveryCard({
    super.key,
    required this.delivery,
    this.onViewReceipt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.glassSurfaceDark,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: AppColors.glassBorderDark,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  delivery.company,
                  style: AppTypography.h2(),
                ),
              ),
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.successGreen,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            "COMPLETED DELIVERY",
            style: AppTypography.microBadge(),
          ),

          const SizedBox(height: AppSpacing.lg),

          _buildInfo("Tender ID", delivery.id),
          _buildInfo(
            "Route",
            "${delivery.origin} → ${delivery.destination}",
          ),
          _buildInfo("Vehicle", delivery.vehicleType),
          _buildInfo(
            "Amount",
            "₹${delivery.amount.toStringAsFixed(0)}",
          ),
          _buildInfo("Delivered", delivery.deliveredOn),
          _buildInfo("Completed", delivery.completedOn),
          _buildInfo("Rating", delivery.rating),

          const SizedBox(height: AppSpacing.lg),

          PrimaryButton(
            title: "View Receipt",
            onPressed: onViewReceipt ?? () {},
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              label,
              style: AppTypography.bodySecondary(),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyPrimary(),
            ),
          ),
        ],
      ),
    );
  }
}