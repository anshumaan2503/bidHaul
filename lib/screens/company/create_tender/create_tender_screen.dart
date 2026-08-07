import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/inputs/app_text_field.dart';

class CreateTenderScreen extends StatefulWidget {
  const CreateTenderScreen({super.key});

  @override
  State<CreateTenderScreen> createState() => _CreateTenderScreenState();
}

class _CreateTenderScreenState extends State<CreateTenderScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pickupController = TextEditingController();
  final _deliveryController = TextEditingController();
  final _materialController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _weightController = TextEditingController();
  final _budgetController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _pickupController.dispose();
    _deliveryController.dispose();
    _materialController.dispose();
    _vehicleController.dispose();
    _weightController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _createTender() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tender Created Successfully")),
    );

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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Text("Create Tender", style: AppTypography.displayHero()),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Text("Tender Information", style: AppTypography.h2()),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _titleController,
                    hint: "Tender Title",
                    prefixIcon: Icons.gavel_rounded,
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _descriptionController,
                    hint: "Tender Description",
                    prefixIcon: Icons.description_outlined,
                    maxLines: 4,
                  ),

                  const SizedBox(height: 30),

                  Text("Route Information", style: AppTypography.h2()),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _pickupController,
                    hint: "Pickup Location",
                    prefixIcon: Icons.location_on_outlined,
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _deliveryController,
                    hint: "Delivery Location",
                    prefixIcon: Icons.flag_outlined,
                  ),

                  const SizedBox(height: 30),

                  Text("Load Information", style: AppTypography.h2()),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _materialController,
                    hint: "Material Type",
                    prefixIcon: Icons.inventory_2_outlined,
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _vehicleController,
                    hint: "Vehicle Type",
                    prefixIcon: Icons.local_shipping_outlined,
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _weightController,
                    hint: "Estimated Weight (KG)",
                    prefixIcon: Icons.scale_outlined,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 30),

                  Text("Auction Information", style: AppTypography.h2()),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _budgetController,
                    hint: "Budget (₹)",
                    prefixIcon: Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 18),
                  AppTextField(
                    controller: TextEditingController(),
                    hint: "Bid Closing Date",
                    prefixIcon: Icons.calendar_today_outlined,
                    readOnly: true,
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: TextEditingController(),
                    hint: "Expected Delivery Date",
                    prefixIcon: Icons.event_available_outlined,
                    readOnly: true,
                  ),

                  const SizedBox(height: 40),

                  PrimaryButton(
                    title: "Create Tender",
                    onPressed: _createTender,
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: Text(
                      "All created tenders will appear in My Tenders.",
                      style: AppTypography.bodySecondary(),
                      textAlign: TextAlign.center,
                    ),
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
