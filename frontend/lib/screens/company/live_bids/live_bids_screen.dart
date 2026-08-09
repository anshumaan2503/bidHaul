import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/tender.dart';
import '../../../providers/bid_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/cards/bid_card.dart';
import '../top5_qualified/top5_qualified_screen.dart';

class LiveBidsScreen extends StatefulWidget {
  final TenderModel tender;

  const LiveBidsScreen({super.key, required this.tender});

  @override
  State<LiveBidsScreen> createState() => _LiveBidsScreenState();
}

class _LiveBidsScreenState extends State<LiveBidsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BidProvider>(context, listen: false).fetchTenderBids(widget.tender.id);
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
                  Text(widget.tender.title, style: AppTypography.bodySecondary()),
                  const SizedBox(height: 30),
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
                                      onPressed: () => provider.fetchTenderBids(widget.tender.id),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : provider.tenderBids.isEmpty
                                ? Center(
                                    child: Text(
                                      "No bids submitted for this tender yet.",
                                      style: AppTypography.bodySecondary(),
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () => provider.fetchTenderBids(widget.tender.id),
                                    color: AppColors.primaryCyan,
                                    child: ListView.builder(
                                      itemCount: provider.tenderBids.length,
                                      itemBuilder: (context, index) {
                                        final bid = provider.tenderBids[index];
                                        return BidCard(bid: bid);
                                      },
                                    ),
                                  ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    title: "View Competitive Statement",
                    icon: Icons.leaderboard_rounded,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Top5QualifiedScreen(tender: widget.tender),
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
