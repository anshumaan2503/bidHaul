import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/bid_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/bid_card.dart';

class MyBidsScreen extends StatefulWidget {
  const MyBidsScreen({super.key});

  @override
  State<MyBidsScreen> createState() => _MyBidsScreenState();
}

class _MyBidsScreenState extends State<MyBidsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BidProvider>(context, listen: false).fetchMyBids();
    });
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
                      const SizedBox(width: 10),
                      Text("My Bids", style: AppTypography.displayHero()),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Expanded(
                    child: provider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: AppColors.primaryCyan),
                          )
                        : provider.errorMessage != null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      provider.errorMessage!,
                                      style: AppTypography.bodySecondary(color: Colors.redAccent),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () => provider.fetchMyBids(),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : provider.myBids.isEmpty
                                ? Center(
                                    child: Text(
                                      "No bids placed yet.",
                                      style: AppTypography.bodySecondary(),
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () => provider.fetchMyBids(),
                                    color: AppColors.primaryCyan,
                                    child: ListView.builder(
                                      itemCount: provider.myBids.length,
                                      itemBuilder: (context, index) {
                                        final bid = provider.myBids[index];

                                        return BidCard(
                                          bid: bid,
                                          showActions: false,
                                        );
                                      },
                                    ),
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
