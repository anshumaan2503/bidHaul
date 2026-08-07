import 'package:flutter/material.dart';

import '../../../models/tender.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/inputs/app_text_field.dart';

class PlaceBidScreen extends StatefulWidget {
  const PlaceBidScreen({super.key, required this.tender});

  final Tender tender;

  @override
  State<PlaceBidScreen> createState() => _PlaceBidScreenState();
}

class _PlaceBidScreenState extends State<PlaceBidScreen> {
  final _bidAmountController = TextEditingController();
  final _deliveryTimeController = TextEditingController();
  final _remarksController = TextEditingController();

  @override
  void dispose() {
    _bidAmountController.dispose();
    _deliveryTimeController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _submitBid() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Bid Submitted Successfully")));

    Navigator.pop(context);
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
            child: SingleChildScrollView(
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

                      Text("Place Bid", style: AppTypography.displayHero()),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Text(widget.tender.title, style: AppTypography.h2()),

                  const SizedBox(height: 10),

                  Text(
                    "${widget.tender.pickupLocation} → ${widget.tender.deliveryLocation}",
                    style: AppTypography.bodySecondary(),
                  ),

                  const SizedBox(height: 30),

                  AppTextField(
                    controller: _bidAmountController,
                    hint: "Bid Amount (₹)",
                    prefixIcon: Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _deliveryTimeController,
                    hint: "Estimated Delivery Time",
                    prefixIcon: Icons.schedule_outlined,
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _remarksController,
                    hint: "Remarks",
                    prefixIcon: Icons.notes_outlined,
                    maxLines: 4,
                  ),

                  const SizedBox(height: 35),

                  PrimaryButton(title: "Submit Bid", onPressed: _submitBid),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
