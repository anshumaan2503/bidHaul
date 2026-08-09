import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/tender.dart';
import '../../../providers/tender_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/tender_card.dart';
import '../../../widgets/common/app_search_bar.dart';
import '../tender_details/tender_details_screen.dart';

class MyTendersScreen extends StatefulWidget {
  const MyTendersScreen({super.key});

  @override
  State<MyTendersScreen> createState() => _MyTendersScreenState();
}

class _MyTendersScreenState extends State<MyTendersScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TenderProvider>(context, listen: false).fetchMyTenders();
    });
  }

  void _confirmDeleteTender(BuildContext context, TenderModel tender) {
    final tenderRef = tender.tenderNumber.isNotEmpty
        ? "Tender #${tender.tenderNumber}"
        : tender.title;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkMidnight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.glassBorderDark),
        ),
        title: const Text(
          "Delete Tender",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to delete '$tenderRef'? This action cannot be undone.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dangerRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = Provider.of<TenderProvider>(context, listen: false);
              final success = await provider.deleteTender(tender.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? "Tender deleted successfully"
                          : provider.errorMessage ?? "Failed to delete tender",
                    ),
                    backgroundColor: success ? AppColors.successGreen : Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TenderProvider>(context);

    final tenders = provider.myTenders.where((t) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return t.title.toLowerCase().contains(q) ||
          t.tenderNumber.toLowerCase().contains(q) ||
          t.pickupLocation.toLowerCase().contains(q) ||
          t.deliveryLocation.toLowerCase().contains(q);
    }).toList();

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
                      Text("My Tenders", style: AppTypography.displayHero()),
                    ],
                  ),

                  const SizedBox(height: 25),

                  AppSearchBar(
                    hint: "Search Tender...",
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
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
                                      onPressed: () => provider.fetchMyTenders(),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : tenders.isEmpty
                                ? Center(
                                    child: Text(
                                      "No tenders created yet.",
                                      style: AppTypography.bodySecondary(),
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () => provider.fetchMyTenders(),
                                    color: AppColors.primaryCyan,
                                    child: ListView.builder(
                                      itemCount: tenders.length,
                                      itemBuilder: (context, index) {
                                        final tender = tenders[index];

                                        return TenderCard(
                                          tender: tender,
                                          onDelete: () => _confirmDeleteTender(context, tender),
                                          onTap: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => TenderDetailsScreen(tender: tender),
                                              ),
                                            );
                                            if (context.mounted) {
                                              provider.fetchMyTenders();
                                            }
                                          },
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
