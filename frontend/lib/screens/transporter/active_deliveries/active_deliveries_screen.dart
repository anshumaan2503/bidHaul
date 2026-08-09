import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/delivery.dart';
import '../../../providers/delivery_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/common/app_search_bar.dart';
import '../../shared/delivery_details_screen.dart';

class ActiveDeliveriesScreen extends StatefulWidget {
  const ActiveDeliveriesScreen({super.key});

  @override
  State<ActiveDeliveriesScreen> createState() => _ActiveDeliveriesScreenState();
}

class _ActiveDeliveriesScreenState extends State<ActiveDeliveriesScreen> {
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
      appBar: AppBar(
        title: const Text("Active Deliveries"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<DeliveryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.activeDeliveries.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.activeDeliveries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          final filteredDeliveries = provider.activeDeliveries.where((e) {
            final q = search.toLowerCase();
            return e.pickupLocation.toLowerCase().contains(q) ||
                e.deliveryLocation.toLowerCase().contains(q) ||
                e.status.toLowerCase().contains(q) ||
                e.id.toLowerCase().contains(q);
          }).toList();

          return RefreshIndicator(
            onRefresh: _loadData,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppSearchBar(
                    hintText: "Search active deliveries...",
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: filteredDeliveries.isEmpty
                        ? const Center(
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Text(
                                "No Active Deliveries",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: filteredDeliveries.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 16),
                            itemBuilder: (_, index) {
                              return _DeliveryCard(delivery: filteredDeliveries[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final DeliveryModel delivery;

  const _DeliveryCard({
    required this.delivery,
  });

  Color get statusColor {
    switch (delivery.status) {
      case "IN_TRANSIT":
        return Colors.blue;
      case "PENDING_PICKUP":
        return Colors.orange;
      case "DELIVERED":
        return Colors.purple;
      case "COMPLETED":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String get statusLabel {
    switch (delivery.status) {
      case "PENDING_PICKUP":
        return "Pending Pickup";
      case "IN_TRANSIT":
        return "In Transit";
      case "DELIVERED":
        return "Delivered";
      case "COMPLETED":
        return "Completed";
      default:
        return delivery.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
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
                  "Delivery #${delivery.id.substring(0, 8)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Chip(
                label: Text(
                  statusLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _row("Route", "${delivery.pickupLocation} ➔ ${delivery.deliveryLocation}"),
          _row("Contract", delivery.contractId),
          _row("Tender", delivery.tenderId),
          if (delivery.pickedUpAt != null)
            _row("Picked Up", delivery.pickedUpAt!.substring(0, 10)),
          const SizedBox(height: 16),
          PrimaryButton(
            title: "View Details & Track",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeliveryDetailsScreen(deliveryId: delivery.id),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 95,
            child: Text(
              title,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}