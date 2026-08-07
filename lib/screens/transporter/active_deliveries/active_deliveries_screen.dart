import 'package:flutter/material.dart';

import '../../../dummy/dummy_active_deliveries.dart';
import '../../../models/active_delivery.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/common/app_search_bar.dart';

class ActiveDeliveriesScreen extends StatefulWidget {
  const ActiveDeliveriesScreen({super.key});

  @override
  State<ActiveDeliveriesScreen> createState() =>
      _ActiveDeliveriesScreenState();
}

class _ActiveDeliveriesScreenState extends State<ActiveDeliveriesScreen> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    final deliveries = dummyActiveDeliveries.where((e) {
      final q = search.toLowerCase();
      return e.company.toLowerCase().contains(q) ||
          e.origin.toLowerCase().contains(q) ||
          e.destination.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      appBar: AppBar(
        title: const Text("Active Deliveries"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppSearchBar(
              hintText: "Search deliveries...",
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: deliveries.isEmpty
                  ? const Center(
                      child: Text(
                        "No Active Deliveries",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.separated(
                      itemCount: deliveries.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (_, index) {
                        return _DeliveryCard(delivery: deliveries[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final ActiveDelivery delivery;

  const _DeliveryCard({
    required this.delivery,
  });

  Color get statusColor {
    switch (delivery.status) {
      case "In Transit":
        return Colors.blue;
      case "Ready for Pickup":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .06),
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
                  delivery.company,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Chip(
                label: Text(delivery.status),
                backgroundColor: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _row("Tender", delivery.id),
          _row("Route", "${delivery.origin} → ${delivery.destination}"),
          _row("Vehicle", delivery.vehicleType),
          _row("Amount", "₹${delivery.amount.toStringAsFixed(0)}"),
          _row("Pickup", delivery.pickupDate),
          _row("Delivery", delivery.expectedDelivery),
          const SizedBox(height: 16),
          PrimaryButton(
            title: "View Delivery",
            onPressed: () {},
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
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}