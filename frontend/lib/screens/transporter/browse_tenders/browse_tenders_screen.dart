import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/tender_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/tender_card.dart';
import '../../../widgets/common/app_search_bar.dart';
import '../../company/tender_details/tender_details_screen.dart';

class BrowseTendersScreen extends StatefulWidget {
  const BrowseTendersScreen({super.key});

  @override
  State<BrowseTendersScreen> createState() => _BrowseTendersScreenState();
}

class _BrowseTendersScreenState extends State<BrowseTendersScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TenderProvider>(context, listen: false).fetchLiveTenders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TenderProvider>(context);

    final tenders = provider.liveTenders.where((t) {
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
                      Text(
                        "Browse Tenders",
                        style: AppTypography.displayHero(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  AppSearchBar(
                    hint: "Search Available Tender...",
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
                                      onPressed: () => provider.fetchLiveTenders(),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : tenders.isEmpty
                                ? Center(
                                    child: Text(
                                      "No live tenders available right now.",
                                      style: AppTypography.bodySecondary(),
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () => provider.fetchLiveTenders(),
                                    color: AppColors.primaryCyan,
                                    child: ListView.builder(
                                      itemCount: tenders.length,
                                      itemBuilder: (context, index) {
                                        final tender = tenders[index];

                                        return TenderCard(
                                          tender: tender,
                                          onTap: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => TenderDetailsScreen(tender: tender),
                                              ),
                                            );
                                            if (context.mounted) {
                                              provider.fetchLiveTenders();
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
