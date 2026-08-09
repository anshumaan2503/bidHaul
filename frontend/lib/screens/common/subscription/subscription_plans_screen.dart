import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/invoice_provider.dart';
import '../../../providers/subscription_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/subscription_plan_card.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPlans();
    });
  }

  Future<void> _loadPlans() async {
    await context.read<SubscriptionProvider>().fetchPlans();
  }

  Future<void> _handleSubscribe(String planId, String planName) async {
    final provider = context.read<SubscriptionProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);

    final sub = await provider.subscribe(planId);
    if (sub != null) {
      // Refresh invoices as well since backend auto-provisions an invoice
      if (mounted) {
        context.read<InvoiceProvider>().fetchMyInvoices();
      }

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.glassSurfaceDark,
          title: const Text("Subscription Created", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You have subscribed to $planName.",
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Text(
                "Status: ${sub.status}",
                style: const TextStyle(color: AppColors.primaryCyan, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "An invoice has been generated. Payment integration (Part 7) will finalize your subscription activation.",
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                nav.pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? "Subscription failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                          "Subscription Plans",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.displayHero(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Consumer<SubscriptionProvider>(
                      builder: (context, provider, _) {
                        if (provider.isLoading && provider.plans.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (provider.plans.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  provider.errorMessage ?? "No active subscription plans available",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadPlans,
                                  child: const Text("Retry"),
                                ),
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: _loadPlans,
                          child: ListView.builder(
                            itemCount: provider.plans.length,
                            itemBuilder: (context, index) {
                              final plan = provider.plans[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                child: SubscriptionPlanCard(
                                  plan: plan,
                                  onSelect: () => _handleSubscribe(plan.id, plan.name),
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
