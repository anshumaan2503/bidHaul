import 'package:flutter/material.dart';

import '../../../dummy/dummy_qualified_bidders.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/cards/qualified_bidder_card.dart';
import '../post_bid_negotiation/post_bid_negotiation_screen.dart';

class Top5QualifiedScreen extends StatelessWidget {
  const Top5QualifiedScreen({super.key});

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
                          "Top 5 Qualified",
                          style: AppTypography.displayHero(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Lowest five bidders are eligible for negotiation.",
                    style: AppTypography.bodySecondary(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dummyQualifiedBidders.length,
                      itemBuilder: (context, index) {
                        return QualifiedBidderCard(
                          bidder: dummyQualifiedBidders[index],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    title: "Start Negotiation",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PostBidNegotiationScreen(),
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