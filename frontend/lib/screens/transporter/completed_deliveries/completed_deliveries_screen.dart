import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/delivery_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/completed_delivery_card.dart';
import '../../../widgets/common/app_search_bar.dart';
import '../../shared/delivery_details_screen.dart';

class CompletedDeliveriesScreen extends StatefulWidget {
  const CompletedDeliveriesScreen({super.key});

  @override
  State<CompletedDeliveriesScreen> createState() => _CompletedDeliveriesScreenState();
}

class _CompletedDeliveriesScreenState extends State<CompletedDeliveriesScreen> {
  String search = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    await context.read<DeliveryProvider>().fetchMyDeliveries();
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
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Completed Deliveries",
                          style: AppTypography.displayHero(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  AppSearchBar(
                    hint: "Search Completed Deliveries...",
                    onChanged: (val) {
                      setState(() {
                        search = val;
                      });
                    },
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: Consumer<DeliveryProvider>(
                      builder: (context, provider, _) {
                        if (provider.isLoading && provider.completedDeliveries.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final list = provider.completedDeliveries.where((d) {
                          final q = search.toLowerCase();
                          return d.pickupLocation.toLowerCase().contains(q) ||
                              d.deliveryLocation.toLowerCase().contains(q) ||
                              d.id.toLowerCase().contains(q);
                        }).toList();

                        if (list.isEmpty) {
                          return const Center(
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Text(
                                "No Completed Deliveries Found",
                                style: TextStyle(color: Colors.white54),
                              ),
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: _loadData,
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: list.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final item = list[index];
                              return CompletedDeliveryCard(
                                delivery: item,
                                onViewDetails: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DeliveryDetailsScreen(deliveryId: item.id),
                                    ),
                                  );
                                },
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
