import 'package:bidhaul/screens/common/subscription/subscription_plans_screen.dart';
import 'package:flutter/material.dart';

import '../../../dummy/dummy_active_subscription.dart';
import '../../../dummy/dummy_invoices.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/cards/active_subscription_card.dart';
import '../../../widgets/cards/invoice_card.dart';


class SubscriptionManagementScreen extends StatelessWidget {
  const SubscriptionManagementScreen({super.key});

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

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          "Subscription",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.displayHero(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  ActiveSubscriptionCard(
                    subscription: dummyActiveSubscription,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          title: "Upgrade",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const SubscriptionPlansScreen(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: AppSpacing.md),

                      Expanded(
                        child: PrimaryButton(
                          title: "Renew",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const SubscriptionPlansScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  Text(
                    "Invoice History",
                    style: AppTypography.h2(),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Expanded(
                    child: ListView.builder(
                      itemCount: dummyInvoices.length,
                      itemBuilder: (context, index) {
                        return InvoiceCard(
                          invoice: dummyInvoices[index],
                        );
                      },
                    ),
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