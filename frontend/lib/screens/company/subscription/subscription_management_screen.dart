import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/invoice_provider.dart';
import '../../../providers/subscription_provider.dart';
import '../../../screens/common/subscription/subscription_plans_screen.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/cards/active_subscription_card.dart';
import '../../../widgets/cards/invoice_card.dart';

class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  State<SubscriptionManagementScreen> createState() => _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState extends State<SubscriptionManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final subProvider = context.read<SubscriptionProvider>();
    final invProvider = context.read<InvoiceProvider>();

    await Future.wait([
      subProvider.fetchSubscriptionStatus(),
      invProvider.fetchMyInvoices(),
    ]);
  }

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

                  // Subscription Card
                  Consumer<SubscriptionProvider>(
                    builder: (context, subProvider, _) {
                      if (subProvider.isLoading && subProvider.subscriptionStatus == null) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final subscription = subProvider.subscriptionStatus;
                      if (subscription == null) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.glassBorderDark),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "No Subscription Found",
                                style: AppTypography.h2(color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Choose a plan to get full access to reverse auction tools and freight management.",
                                style: TextStyle(color: Colors.white54, fontSize: 13),
                              ),
                              const SizedBox(height: 16),
                              PrimaryButton(
                                title: "Explore Plans",
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SubscriptionPlansScreen(),
                                    ),
                                  ).then((_) => _loadData());
                                },
                              ),
                            ],
                          ),
                        );
                      }

                      return ActiveSubscriptionCard(subscription: subscription);
                    },
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          title: "Upgrade Plan",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SubscriptionPlansScreen(),
                              ),
                            ).then((_) => _loadData());
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: PrimaryButton(
                          title: "View Plans",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SubscriptionPlansScreen(),
                              ),
                            ).then((_) => _loadData());
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
                    child: Consumer<InvoiceProvider>(
                      builder: (context, invProvider, _) {
                        if (invProvider.isLoading && invProvider.myInvoices.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (invProvider.myInvoices.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                "No invoice records found.",
                                style: TextStyle(color: Colors.white54),
                              ),
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: _loadData,
                          child: ListView.builder(
                            itemCount: invProvider.myInvoices.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                child: InvoiceCard(
                                  invoice: invProvider.myInvoices[index],
                                ),
                              );
                            },
                          ),
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