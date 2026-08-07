import 'package:flutter/material.dart';

import '../../../models/tender.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../live_bids/live_bids_screen.dart';

class TenderDetailsScreen extends StatelessWidget {
  const TenderDetailsScreen({super.key, required this.tender});

  final Tender tender;

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

                      const SizedBox(width: 10),

                      Text(
                        "Tender Details",
                        style: AppTypography.displayHero(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  _Section(title: "Tender Title", value: tender.title),

                  _Section(title: "Description", value: tender.description),

                  _Section(
                    title: "Pickup Location",
                    value: tender.pickupLocation,
                  ),

                  _Section(
                    title: "Delivery Location",
                    value: tender.deliveryLocation,
                  ),

                  _Section(title: "Material", value: tender.materialType),

                  _Section(title: "Vehicle", value: tender.vehicleType),

                  _Section(title: "Weight", value: tender.weight),

                  _Section(title: "Budget", value: tender.budget),

                  const SizedBox(height: 35),

                  PrimaryButton(
                    title: "View Live Bids",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LiveBidsScreen(tender: tender),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  PrimaryButton(title: "Close Auction", onPressed: () {}),

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

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.bodySecondary()),

          const SizedBox(height: 6),

          Text(value, style: AppTypography.h3()),
        ],
      ),
    );
  }
}
