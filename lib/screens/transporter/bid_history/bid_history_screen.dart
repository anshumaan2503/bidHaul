import 'package:flutter/material.dart';

import '../../../dummy/dummy_bid_history.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/bid_history_card.dart';
import '../../../widgets/common/app_search_bar.dart';

class BidHistoryScreen extends StatelessWidget {
  const BidHistoryScreen({super.key});

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
                          "Bid History",
                          style: AppTypography.displayHero(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const AppSearchBar(hint: "Search Bid History..."),
                  const SizedBox(height: 25),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dummyBidHistory.length,
                      itemBuilder: (context, index) {
                        return BidHistoryCard(bid: dummyBidHistory[index]);
                      },
                    ),
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
