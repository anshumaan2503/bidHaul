import 'package:flutter/material.dart';

import '../../../dummy/dummy_negotiation_offers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/cards/negotiation_offer_card.dart';
import '../competitive_statement/competitive_statement_screen.dart';

class PostBidNegotiationScreen extends StatelessWidget {
  const PostBidNegotiationScreen({super.key});

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
                          "Post Bid Negotiation",
                          style: AppTypography.displayHero(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Only Top 5 bidders can negotiate.",
                    style: AppTypography.bodySecondary(),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dummyNegotiationOffers.length,
                      itemBuilder: (context, index) {
                        return NegotiationOfferCard(
                          offer: dummyNegotiationOffers[index],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    title: "Finish Negotiation",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CompetitiveStatementScreen(),
                        ),
                      );
                    },
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
