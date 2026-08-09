import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/bid.dart';
import '../../../models/tender.dart';
import '../../../providers/bid_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/inputs/app_text_field.dart';

class PlaceBidScreen extends StatefulWidget {
  final TenderModel tender;

  const PlaceBidScreen({super.key, required this.tender});

  @override
  State<PlaceBidScreen> createState() => _PlaceBidScreenState();
}

class _PlaceBidScreenState extends State<PlaceBidScreen> {
  final _bidAmountController = TextEditingController();
  final _estimatedDaysController = TextEditingController();
  final _remarksController = TextEditingController();

  @override
  void dispose() {
    _bidAmountController.dispose();
    _estimatedDaysController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _submitBid() async {
    FocusScope.of(context).unfocus();

    final amount = double.tryParse(_bidAmountController.text.trim()) ?? 0.0;
    final estimatedDays = int.tryParse(_estimatedDaysController.text.trim()) ?? 0;
    final remarks = _remarksController.text.trim();

    if (amount <= 0 || estimatedDays <= 0 || remarks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid bid amount, estimated days (at least 1), and remarks."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final req = CreateBidRequest(
      amount: amount,
      estimatedDays: estimatedDays,
      remarks: remarks,
    );

    final provider = Provider.of<BidProvider>(context, listen: false);
    final success = await provider.placeBid(widget.tender.id, req);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bid Submitted Successfully!"),
          backgroundColor: AppColors.successGreen,
        ),
      );
      Navigator.pop(context);
    } else {
      final err = provider.errorMessage ?? "Failed to submit bid";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BidProvider>(context);

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

                  const SizedBox(height: 10),

                  Text(
                    "Ceiling Budget: ${widget.tender.budget}",
                    style: AppTypography.microBadge(color: AppColors.glowCyan),
                  ),

                  const SizedBox(height: 30),

                  AppTextField(
                    controller: _bidAmountController,
                    hint: "Bid Amount (₹)",
                    prefixIcon: Icons.currency_rupee,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _estimatedDaysController,
                    hint: "Estimated Transit Duration (Days)",
                    prefixIcon: Icons.schedule_outlined,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _remarksController,
                    hint: "Bid Remarks / Inclusions",
                    prefixIcon: Icons.notes_outlined,
                    maxLines: 4,
                  ),

                  const SizedBox(height: 35),

                  PrimaryButton(
                    title: "Submit Bid",
                    isLoading: provider.isLoading,
                    onPressed: _submitBid,
                  ),

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
