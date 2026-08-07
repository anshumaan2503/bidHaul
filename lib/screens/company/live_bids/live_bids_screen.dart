import 'package:flutter/material.dart';

import '../../../dummy/dummy_bids.dart';
import '../../../models/tender.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/cards/bid_card.dart';
import '../top5_qualified/top5_qualified_screen.dart';

class LiveBidsScreen extends StatelessWidget {
  const LiveBidsScreen({super.key, required this.tender});

  final Tender tender;

  @override
  Widget build(BuildContext context) {
    final bids = dummyBids.where((bid) => bid.tenderId == tender.id).toList();

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
                          "Live Bids",
                          style: AppTypography.displayHero(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(tender.title, style: AppTypography.bodySecondary()),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.builder(
                      itemCount: bids.length,
                      itemBuilder: (context, index) {
                        final bid = bids[index];
                        return BidCard(bid: bid);
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    title: "Generate Top 5",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Top5QualifiedScreen(),
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
