import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/contract_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/accepted_contract_card.dart';
import '../../../widgets/common/app_search_bar.dart';

class WonAuctionsScreen extends StatefulWidget {
  const WonAuctionsScreen({super.key});

  @override
  State<WonAuctionsScreen> createState() => _WonAuctionsScreenState();
}

class _WonAuctionsScreenState extends State<WonAuctionsScreen> {
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContractProvider>(context, listen: false).fetchMyContracts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContractProvider>(context);

    final contracts = provider.myContracts.where((c) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return c.contractNumber.toLowerCase().contains(q) ||
          c.tenderId.toLowerCase().contains(q) ||
          c.terms.toLowerCase().contains(q);
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
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Awarded Contracts",
                          style: AppTypography.displayHero(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  AppSearchBar(
                    hint: "Search awarded contracts...",
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
                                      onPressed: () => provider.fetchMyContracts(),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              )
                            : contracts.isEmpty
                                ? Center(
                                    child: Text(
                                      "No awarded contracts found.",
                                      style: AppTypography.bodySecondary(),
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () => provider.fetchMyContracts(),
                                    color: AppColors.primaryCyan,
                                    child: ListView.builder(
                                      itemCount: contracts.length,
                                      itemBuilder: (context, index) {
                                        final contract = contracts[index];
                                        return AcceptedContractCard(
                                          contract: contract,
                                          onAccept: contract.isPendingAcceptance
                                              ? () async {
                                                  final ok = await provider.acceptContract(contract.id);
                                                  if (!context.mounted) return;
                                                  if (ok) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text("Contract Accepted Successfully!"),
                                                        backgroundColor: AppColors.successGreen,
                                                      ),
                                                    );
                                                  } else if (provider.errorMessage != null) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(provider.errorMessage!),
                                                        backgroundColor: Colors.redAccent,
                                                      ),
                                                    );
                                                  }
                                                }
                                              : null,
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
