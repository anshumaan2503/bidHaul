import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/tender.dart';
import '../../../providers/tender_provider.dart';
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

  Future<void> _createTender() async {
    FocusScope.of(context).unfocus();

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final pickup = _pickupController.text.trim();
    final delivery = _deliveryController.text.trim();
    final material = _materialController.text.trim();
    final vehicle = _vehicleController.text.trim();
    final weight = double.tryParse(_weightController.text.trim()) ?? 0.0;
    final budget = double.tryParse(_budgetController.text.trim()) ?? 0.0;

    if (title.isEmpty ||
        description.isEmpty ||
        pickup.isEmpty ||
        delivery.isEmpty ||
        material.isEmpty ||
        vehicle.isEmpty ||
        weight <= 0 ||
        budget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields with valid positive values."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final req = CreateTenderRequest(
      title: title,
      description: description,
      pickupLocation: pickup,
      deliveryLocation: delivery,
      materialType: material,
      vehicleType: vehicle,
      weightTons: weight,
      ceilingBudget: budget,
    );

    final provider = Provider.of<TenderProvider>(context, listen: false);
    final created = await provider.createTender(req);

    if (!mounted) return;

    if (created != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tender Created Successfully"),
          backgroundColor: AppColors.successGreen,
        ),
      );
      await provider.fetchMyTenders();
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? "Failed to create tender"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TenderProvider>(context);

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
                    hint: "Material Type (e.g. Steel Coils)",
                    prefixIcon: Icons.inventory_2_outlined,
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _vehicleController,
                    hint: "Vehicle Type (e.g. 32ft Container)",
                    prefixIcon: Icons.local_shipping_outlined,
                  ),

                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _weightController,
                    hint: "Weight in Tons (e.g. 15.5)",
                    prefixIcon: Icons.scale_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),

                  const SizedBox(height: 30),

                  Text("Auction Budget", style: AppTypography.h2()),
                  const SizedBox(height: 18),

                  AppTextField(
                    controller: _budgetController,
                    hint: "Ceiling Budget (₹)",
                    prefixIcon: Icons.currency_rupee,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),

                  const SizedBox(height: 40),

                  PrimaryButton(
                    title: "Create Tender",
                    isLoading: provider.isLoading,
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
