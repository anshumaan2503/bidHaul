import 'package:flutter/material.dart';

import '../../models/negotiation_offer.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/primary_button.dart';

class NegotiationOfferCard extends StatelessWidget {
  final NegotiationOffer offer;
  final VoidCallback? onCounterOffer;

  const NegotiationOfferCard({
    super.key,
    required this.offer,
    this.onCounterOffer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.glassSurfaceDark,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(offer.transporter, style: AppTypography.h2()),

          const SizedBox(height: AppSpacing.sm),

          Text("POST BID NEGOTIATION", style: AppTypography.microBadge()),

          const SizedBox(height: AppSpacing.lg),

          _info("Initial Bid", "₹${offer.initialBid.toStringAsFixed(0)}"),

          _info("Current Offer", "₹${offer.currentOffer.toStringAsFixed(0)}"),

          _info("Status", offer.isAccepted ? "Accepted" : "Negotiating"),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  title: "Counter Offer",
                  onPressed: onCounterOffer ?? () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(title, style: AppTypography.bodySecondary()),
          ),
          Expanded(child: Text(value, style: AppTypography.bodyPrimary())),
        ],
      ),
    );
  }
}
