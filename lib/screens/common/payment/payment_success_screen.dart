import 'package:flutter/material.dart';

import '../../../models/subscription_plan.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final SubscriptionPlan plan;

  const PaymentSuccessScreen({super.key, required this.plan});

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.successGreen,
                    size: 100,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    "Payment Successful",
                    style: AppTypography.h1(),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Text(
                    "${plan.name} Plan Activated",
                    style: AppTypography.bodyPrimary(),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    "Amount Paid: ₹${plan.monthlyPrice.toStringAsFixed(0)}",
                    style: AppTypography.bodySecondary(),
                  ),

                  const Spacer(),

                  PrimaryButton(
                    title: "Back to Dashboard",
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
