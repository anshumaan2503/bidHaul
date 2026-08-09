import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/negotiation_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/negotiation_offer_card.dart';
import '../../../widgets/inputs/app_text_field.dart';

class PostBidNegotiationScreen extends StatefulWidget {
  final String? tenderId;

  const PostBidNegotiationScreen({super.key, this.tenderId});

  @override
  State<PostBidNegotiationScreen> createState() => _PostBidNegotiationScreenState();
}

class _PostBidNegotiationScreenState extends State<PostBidNegotiationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<NegotiationProvider>(context, listen: false);
      if (widget.tenderId != null) {
        provider.fetchTenderNegotiations(widget.tenderId!);
      } else {
        provider.fetchMyNegotiations();
      }
    });
  }

  void _showCounterOfferDialog(BuildContext context, String negotiationId) {
    final amountCtrl = TextEditingController();
    final remarksCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.glassSurfaceDark,
        title: Text("Submit Counter Offer", style: AppTypography.h2()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: amountCtrl,
              hint: "Offer Amount (₹)",
              prefixIcon: Icons.currency_rupee,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: remarksCtrl,
              hint: "Remarks",
              prefixIcon: Icons.notes,
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCyan),
            onPressed: () async {
              final amount = double.tryParse(amountCtrl.text.trim()) ?? 0;
              final remarks = remarksCtrl.text.trim();
              if (amount <= 0 || remarks.isEmpty) return;

              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(ctx);
              final provider = Provider.of<NegotiationProvider>(context, listen: false);
              final ok = await provider.addOffer(negotiationId, amount, remarks);
              if (ok) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text("Counter offer submitted successfully!"),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              } else if (provider.errorMessage != null) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(provider.errorMessage!),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text("Submit", style: TextStyle(color: AppColors.darkMidnight)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NegotiationProvider>(context);

    final list = widget.tenderId != null
        ? provider.tenderNegotiations
        : provider.myNegotiations;

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
                          "Post Bid Negotiation",
                          style: AppTypography.displayHero(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Real-time negotiation records with qualified bidders.",
                    style: AppTypography.bodySecondary(),
                  ),
                  const SizedBox(height: 25),
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
                            : list.isEmpty
                                ? Center(
                                    child: Text(
                                      "No active negotiations found.",
                                      style: AppTypography.bodySecondary(),
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () async {
                                      if (widget.tenderId != null) {
                                        await provider.fetchTenderNegotiations(widget.tenderId!);
                                      } else {
                                        await provider.fetchMyNegotiations();
                                      }
                                    },
                                    color: AppColors.primaryCyan,
                                    child: ListView.builder(
                                      itemCount: list.length,
                                      itemBuilder: (context, index) {
                                        final item = list[index];
                                        return NegotiationOfferCard(
                                          negotiation: item,
                                          onCounterOffer: item.isOpen
                                              ? () => _showCounterOfferDialog(context, item.id)
                                              : null,
                                          onAccept: item.isOpen
                                              ? () async {
                                                  final messenger = ScaffoldMessenger.of(context);
                                                  final ok = await provider.acceptNegotiation(item.id);
                                                  if (ok) {
                                                    messenger.showSnackBar(
                                                      const SnackBar(
                                                        content: Text("Negotiation Accepted!"),
                                                        backgroundColor: AppColors.successGreen,
                                                      ),
                                                    );
                                                  } else if (provider.errorMessage != null) {
                                                    messenger.showSnackBar(
                                                      SnackBar(
                                                        content: Text(provider.errorMessage!),
                                                        backgroundColor: Colors.redAccent,
                                                      ),
                                                    );
                                                  }
                                                }
                                              : null,
                                          onReject: item.isOpen
                                              ? () async {
                                                  final messenger = ScaffoldMessenger.of(context);
                                                  final ok = await provider.rejectNegotiation(item.id);
                                                  if (ok) {
                                                    messenger.showSnackBar(
                                                      const SnackBar(
                                                        content: Text("Negotiation Rejected"),
                                                        backgroundColor: Colors.redAccent,
                                                      ),
                                                    );
                                                  } else if (provider.errorMessage != null) {
                                                    messenger.showSnackBar(
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
