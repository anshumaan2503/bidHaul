import 'package:flutter/material.dart';

import '../../../dummy/dummy_tenders.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/tender_card.dart';
import '../../../widgets/common/app_search_bar.dart';
import '../place_bid/place_bid_screen.dart';

class BrowseTendersScreen extends StatelessWidget {
  const BrowseTendersScreen({super.key});

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
                        "Browse Tenders",
                        style: AppTypography.displayHero(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const AppSearchBar(hint: "Search Available Tender..."),

                  const SizedBox(height: 25),

                  Expanded(
                    child: ListView.builder(
                      itemCount: dummyTenders.length,
                      itemBuilder: (context, index) {
                        final tender = dummyTenders[index];

                        return TenderCard(
                          tender: tender,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlaceBidScreen(tender: tender),
                              ),
                            );
                          },
                        );
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
