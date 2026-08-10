import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/competitive_bid.dart';
import '../../../models/tender.dart';
import '../../../providers/tender_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../post_bid_negotiation/post_bid_negotiation_screen.dart';

class Top5QualifiedScreen extends StatefulWidget {
  final TenderModel? tender;

  const Top5QualifiedScreen({super.key, this.tender});

  @override
  State<Top5QualifiedScreen> createState() => _Top5QualifiedScreenState();
}

class _Top5QualifiedScreenState extends State<Top5QualifiedScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.tender != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<TenderProvider>(context, listen: false)
            .fetchCompetitiveStatement(widget.tender!.id);
      });
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
                          "Competitive Statement",
                          style: AppTypography.displayHero(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Competitive ranking and bid status determined directly by the backend.",
                    style: AppTypography.bodySecondary(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: provider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: AppColors.primaryCyan),
                          )
                        : provider.errorMessage != null
                            ? Center(
                                child: Text(
                                  provider.errorMessage!,
                                  style: AppTypography.bodySecondary(color: Colors.redAccent),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : provider.competitiveStatement.isEmpty
                                ? Center(
                                    child: Text(
                                      "No competitive statement available for this tender.",
                                      style: AppTypography.bodySecondary(),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: provider.competitiveStatement.length,
                                    itemBuilder: (context, index) {
                                      final item = provider.competitiveStatement[index];
                                      return _CompetitiveBidCard(
                                        item: item,
                                        tenderId: widget.tender?.id,
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

class _CompetitiveBidCard extends StatelessWidget {
  final CompetitiveBidModel item;
  final String? tenderId;

  const _CompetitiveBidCard({required this.item, this.tenderId});

  @override
  Widget build(BuildContext context) {
    final isWinner = item.rank == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.glassSurfaceDark,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: isWinner ? AppColors.successGreen : AppColors.glassBorderDark,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "L${item.rank}",
                style: AppTypography.h1(
                  color: isWinner ? AppColors.successGreen : Colors.white,
                ),
              ),
              Text(
                item.negotiationStatus,
                style: AppTypography.microBadge(
                  color: isWinner ? AppColors.successGreen : AppColors.glowCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(item.transporterName, style: AppTypography.h2()),
          if (item.bidNumber.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text("Ref #${item.bidNumber}", style: AppTypography.bodySecondary()),
          ],
          const SizedBox(height: AppSpacing.md),
          _row("Initial Bid", "₹${item.initialBidAmount.toStringAsFixed(0)}"),
          _row(
            "Negotiated",
            "₹${(item.finalNegotiatedAmount > 0 ? item.finalNegotiatedAmount : item.currentNegotiationAmount).toStringAsFixed(0)}",
          ),
          if (item.savingsAmount > 0)
            _row("Savings", "₹${item.savingsAmount.toStringAsFixed(0)}"),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryCyan,
                foregroundColor: AppColors.darkMidnight,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.md,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostBidNegotiationScreen(
                      tenderId: tenderId,
                      bidId: item.bidId,
                      transporterName: item.transporterName,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.handshake_rounded, size: 20),
              label: Text(
                "Negotiate / Counter Offer",
                style: AppTypography.h3(color: AppColors.darkMidnight),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(title, style: AppTypography.bodySecondary()),
          ),
          Expanded(child: Text(value, style: AppTypography.bodyPrimary())),
        ],
      ),
    );
  }
}