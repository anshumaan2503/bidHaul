import 'package:flutter/material.dart';

import '../../../dummy/dummy_finalized_contract.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';

class ContractAcceptanceScreen extends StatelessWidget {
  const ContractAcceptanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.darkFluidGradient,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Contract Generated",
                          style: AppTypography.displayHero(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    finalizedContract.transporter,
                    style: AppTypography.h1(color: AppColors.successGreen),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    "Tender : ${finalizedContract.tenderId}",
                    style: AppTypography.bodyPrimary(),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    "Final Price : ₹${finalizedContract.amount.toStringAsFixed(0)}",
                    style: AppTypography.bodyPrimary(),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    title: "Finish",
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
