import 'package:flutter/material.dart';

import '../../models/contract.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/secondary_button.dart';
import '../common/app_status_badge.dart';
import '../common/base_glass_card.dart';
import '../common/info_row.dart';

class AcceptedContractCard extends StatelessWidget {
  final ContractModel contract;
  final VoidCallback? onViewDetails;
  final VoidCallback? onAccept;
  final bool isAccepting;

  const AcceptedContractCard({
    super.key,
    required this.contract,
    this.onViewDetails,
    this.onAccept,
    this.isAccepting = false,
  });

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      onTap: onViewDetails,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withValues(alpha: 0.2),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: AppColors.successGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.handshake_rounded,
                  color: AppColors.successGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contract.contractNumber,
                      style: AppTypography.cardTitle(),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Tender Ref: #${contract.tenderId.substring(0, 8)}",
                      style: AppTypography.bodySecondary(),
                    ),
                  ],
                ),
              ),
              AppStatusBadge(status: contract.status),
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
                  title: "Final Amount",
                  value: "₹${contract.finalAmount.toStringAsFixed(0)}",
                  icon: Icons.payments_rounded,
                  valueStyle: AppTypography.priceText(color: AppColors.successGreen),
                ),
                InfoRow(
                  title: "Terms",
                  value: contract.terms,
                  icon: Icons.gavel_rounded,
                ),
                if (contract.acceptedAt != null)
                  InfoRow(
                    title: "Accepted On",
                    value: contract.acceptedAt.toString().substring(0, 10),
                    icon: Icons.event_available_rounded,
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              if (onViewDetails != null)
                Expanded(
                  child: SecondaryButton(
                    title: "View Details",
                    icon: Icons.description_rounded,
                    onPressed: onViewDetails!,
                  ),
                ),
              if (onViewDetails != null && contract.isPendingAcceptance && onAccept != null)
                const SizedBox(width: 8),
              if (contract.isPendingAcceptance && onAccept != null)
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.successGreen),
                    onPressed: isAccepting ? null : onAccept,
                    child: isAccepting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text("Accept Contract", style: TextStyle(color: Colors.black)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
