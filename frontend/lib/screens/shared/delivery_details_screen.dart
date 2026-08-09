import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/delivery_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons/primary_button.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final String deliveryId;

  const DeliveryDetailsScreen({
    super.key,
    required this.deliveryId,
  });

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final provider = context.read<DeliveryProvider>();
    await provider.fetchDelivery(widget.deliveryId);
    await provider.fetchTrackingHistory(widget.deliveryId);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PENDING_PICKUP':
        return Colors.orange;
      case 'IN_TRANSIT':
        return Colors.blue;
      case 'DELIVERED':
        return Colors.purple;
      case 'COMPLETED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'PENDING_PICKUP':
        return 'Pending Pickup';
      case 'IN_TRANSIT':
        return 'In Transit';
      case 'DELIVERED':
        return 'Delivered';
      case 'COMPLETED':
        return 'Completed';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isCompany = auth.user?.isCompany == true;
    final isTransporter = auth.user?.isTransporter == true;

    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      appBar: AppBar(
        title: const Text("Delivery Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<DeliveryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.currentDelivery == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final delivery = provider.currentDelivery;
          if (delivery == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage ?? "Delivery details not found",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.glassBorderDark),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery ID",
                              style: AppTypography.bodySecondary(),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _statusColor(delivery.status).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: _statusColor(delivery.status)),
                              ),
                              child: Text(
                                _statusLabel(delivery.status),
                                style: TextStyle(
                                  color: _statusColor(delivery.status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          delivery.id,
                          style: AppTypography.h2(color: AppColors.primaryCyan),
                        ),
                        const Divider(color: Colors.white12, height: 24),
                        _infoRow("Route", "${delivery.pickupLocation}  ➔  ${delivery.deliveryLocation}"),
                        _infoRow("Contract ID", delivery.contractId),
                        _infoRow("Tender ID", delivery.tenderId),
                        if (delivery.pickedUpAt != null)
                          _infoRow("Picked Up At", delivery.pickedUpAt!),
                        if (delivery.deliveredAt != null)
                          _infoRow("Delivered At", delivery.deliveredAt!),
                        if (delivery.confirmedAt != null)
                          _infoRow("Confirmed At", delivery.confirmedAt!),
                        if (delivery.rating != null)
                          _infoRow("Transporter Rating", "⭐ ${delivery.rating!.toStringAsFixed(1)} / 5.0"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons based on Role & Status
                  if (isTransporter && delivery.isPendingPickup)
                    PrimaryButton(
                      title: "Mark Picked Up",
                      onPressed: () => _showUpdateDialog(
                        context,
                        title: "Mark Picked Up",
                        defaultLocation: delivery.pickupLocation,
                        onSubmit: (location, remarks) async {
                          final messenger = ScaffoldMessenger.of(context);
                          final ok = await provider.markPickedUp(
                            delivery.id,
                            location,
                            remarks: remarks,
                          );
                          if (ok) {
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Shipment marked as picked up!')),
                            );
                          }
                        },
                      ),
                    ),

                  if (isTransporter && delivery.isInTransit) ...[
                    PrimaryButton(
                      title: "Add Tracking Update",
                      onPressed: () => _showUpdateDialog(
                        context,
                        title: "Add Tracking Location",
                        defaultLocation: delivery.pickupLocation,
                        onSubmit: (location, remarks) async {
                          final messenger = ScaffoldMessenger.of(context);
                          final ok = await provider.addTrackingUpdate(
                            delivery.id,
                            location,
                            remarks: remarks,
                          );
                          if (ok) {
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Tracking update recorded!')),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _showUpdateDialog(
                        context,
                        title: "Mark Shipment Delivered",
                        defaultLocation: delivery.deliveryLocation,
                        onSubmit: (location, remarks) async {
                          final messenger = ScaffoldMessenger.of(context);
                          final ok = await provider.markDelivered(
                            delivery.id,
                            location,
                            remarks: remarks,
                          );
                          if (ok) {
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Shipment marked as delivered!')),
                            );
                          }
                        },
                      ),
                      child: const Text(
                        "Mark Delivered",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],

                  if (isCompany && delivery.isDelivered)
                    PrimaryButton(
                      title: "Confirm Delivery & Rate Transporter",
                      onPressed: () => _showRatingDialog(context, delivery.id),
                    ),

                  const SizedBox(height: 24),

                  // Tracking Timeline
                  Text(
                    "Tracking History",
                    style: AppTypography.h3(color: Colors.white),
                  ),
                  const SizedBox(height: 12),

                  if (provider.trackingHistory.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          "No tracking events recorded yet",
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.trackingHistory.length,
                      itemBuilder: (context, index) {
                        final event = provider.trackingHistory[index];
                        final isLast = index == provider.trackingHistory.length - 1;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: _statusColor(event.status),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: _statusColor(event.status).withValues(alpha: 0.5),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                                if (!isLast)
                                  Container(
                                    width: 2,
                                    height: 50,
                                    color: Colors.white24,
                                  ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _statusLabel(event.status),
                                          style: TextStyle(
                                            color: _statusColor(event.status),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        if (event.createdAt != null)
                                          Text(
                                            event.createdAt!.substring(0, 10),
                                            style: const TextStyle(color: Colors.white38, fontSize: 11),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "📍 ${event.location}",
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                    if (event.remarks != null && event.remarks!.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        event.remarks!,
                                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(
    BuildContext context, {
    required String title,
    required String defaultLocation,
    required Function(String location, String? remarks) onSubmit,
  }) {
    final locationController = TextEditingController(text: defaultLocation);
    final remarksController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.glassSurfaceDark,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: "Location",
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: remarksController,
              decoration: const InputDecoration(
                labelText: "Remarks (Optional)",
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text("Cancel", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              final loc = locationController.text.trim();
              if (loc.isNotEmpty) {
                Navigator.pop(dialogCtx);
                onSubmit(loc, remarksController.text.trim());
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context, String deliveryId) {
    double rating = 5.0;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.glassSurfaceDark,
          title: const Text("Rate Transporter & Confirm", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Please rate the delivery performance (0.0 to 5.0):",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Text(
                "⭐ ${rating.toStringAsFixed(1)}",
                style: AppTypography.h1(color: AppColors.primaryCyan),
              ),
              Slider(
                value: rating,
                min: 0.0,
                max: 5.0,
                divisions: 10,
                activeColor: AppColors.primaryCyan,
                onChanged: (val) {
                  setDialogState(() {
                    rating = val;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text("Cancel", style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogCtx);
                final messenger = ScaffoldMessenger.of(context);
                final provider = context.read<DeliveryProvider>();
                final ok = await provider.confirmDelivery(deliveryId, rating);
                if (ok) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Delivery confirmed successfully!')),
                  );
                }
              },
              child: const Text("Confirm Delivery"),
            ),
          ],
        ),
      ),
    );
  }
}
