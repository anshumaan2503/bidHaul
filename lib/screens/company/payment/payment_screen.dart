import 'package:bidhaul/screens/common/payment/payment_success_screen.dart';
import 'package:flutter/material.dart';

import '../../../models/subscription_plan.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';


class PaymentScreen extends StatelessWidget {
  final SubscriptionPlan plan;

  const PaymentScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      body: Stack(
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

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          "Payment",
                          style: AppTypography.displayHero(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  Text(plan.name, style: AppTypography.h1()),

                  const SizedBox(height: AppSpacing.md),

                  Text("Amount", style: AppTypography.microBadge()),

                  Text(
                    "₹${plan.monthlyPrice.toStringAsFixed(0)}",
                    style: AppTypography.h2(color: AppColors.primaryCyan),
                  ),

                  const Spacer(),

                  PrimaryButton(
                    title: "Pay Now",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentSuccessScreen(plan: plan),
                        ),
                      );
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
