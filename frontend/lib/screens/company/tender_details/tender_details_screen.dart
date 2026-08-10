import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/tender.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/tender_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/common/app_status_badge.dart';
import '../../transporter/place_bid/place_bid_screen.dart';
import '../live_bids/live_bids_screen.dart';
import '../post_bid_negotiation/post_bid_negotiation_screen.dart';
import '../top5_qualified/top5_qualified_screen.dart';

class TenderDetailsScreen extends StatefulWidget {
  final TenderModel tender;

  const TenderDetailsScreen({super.key, required this.tender});

  @override
  State<TenderDetailsScreen> createState() => _TenderDetailsScreenState();
}

class _TenderDetailsScreenState extends State<TenderDetailsScreen> {
  late TenderModel _currentTender;

  @override
  void initState() {
    super.initState();
    _currentTender = widget.tender;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshTender();
    });
  }

  Future<void> _refreshTender() async {
    final provider = Provider.of<TenderProvider>(context, listen: false);
    final updated = await provider.fetchTenderDetails(_currentTender.id);
    if (updated != null && mounted) {
      setState(() {
        _currentTender = updated;
      });
    }
  }

  Future<void> _onCloseAuctionPressed() async {
    final provider = Provider.of<TenderProvider>(context, listen: false);
    final success = await provider.closeTender(_currentTender.id);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tender auction closed successfully"),
          backgroundColor: AppColors.successGreen,
        ),
      );
      if (provider.selectedTender != null) {
        setState(() {
          _currentTender = provider.selectedTender!;
        });
      }
    } else {
      final err = provider.errorMessage ?? "Failed to close tender";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _onDeleteTenderPressed() async {
    final tenderRef = _currentTender.tenderNumber.isNotEmpty
        ? "Tender #${_currentTender.tenderNumber}"
        : _currentTender.title;

    final confirm = await showDialog<bool>(
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
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dangerRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final provider = Provider.of<TenderProvider>(context, listen: false);
    final success = await provider.deleteTender(_currentTender.id);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tender deleted successfully"),
          backgroundColor: AppColors.successGreen,
        ),
      );
      Navigator.pop(context);
    } else {
      final err = provider.errorMessage ?? "Failed to delete tender";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isCompany = authProvider.user?.isCompany ?? true;
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
            child: SingleChildScrollView(
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
                      Expanded(
                        child: Text(
                          "Tender Details",
                          style: AppTypography.displayHero(),
                        ),
                      ),
                      AppStatusBadge(status: _currentTender.status),
                    ],
                  ),

                  const SizedBox(height: 24),

                  if (_currentTender.tenderNumber.isNotEmpty)
                    _Section(title: "Tender Ref #", value: _currentTender.tenderNumber),

                  _Section(title: "Tender Title", value: _currentTender.title),

                  _Section(title: "Description", value: _currentTender.description),

                  _Section(
                    title: "Pickup Location",
                    value: _currentTender.pickupLocation,
                  ),

                  _Section(
                    title: "Delivery Location",
                    value: _currentTender.deliveryLocation,
                  ),

                  _Section(title: "Material Type", value: _currentTender.materialType),

                  _Section(title: "Vehicle Required", value: _currentTender.vehicleType),

                  _Section(title: "Weight (Tons)", value: _currentTender.weight),

                  _Section(title: "Ceiling Budget", value: _currentTender.budget),

                  if (_currentTender.createdAt != null)
                    _Section(title: "Created At", value: _currentTender.createdAt!),

                  const SizedBox(height: 25),

                  if (isCompany) ...[
                    PrimaryButton(
                      title: "View Live Bids",
                      icon: Icons.gavel_rounded,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LiveBidsScreen(tender: _currentTender),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    PrimaryButton(
                      title: "View Competitive Statement",
                      icon: Icons.leaderboard_rounded,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Top5QualifiedScreen(tender: _currentTender),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    PrimaryButton(
                      title: "Post-Bid Negotiation",
                      icon: Icons.handshake_rounded,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PostBidNegotiationScreen(
                              tenderId: _currentTender.id,
                            ),
                          ),
                        );
                      },
                    ),

                    if (_currentTender.isLive) ...[
                      const SizedBox(height: 14),
                      PrimaryButton(
                        title: "Close Auction",
                        icon: Icons.lock_clock_rounded,
                        isLoading: provider.isLoading,
                        onPressed: _onCloseAuctionPressed,
                      ),
                    ],

                    const SizedBox(height: 14),

                    PrimaryButton(
                      title: "Delete Tender",
                      icon: Icons.delete_outline_rounded,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.dangerRed,
                          AppColors.dangerRed.withValues(alpha: 0.8),
                        ],
                      ),
                      textColor: Colors.white,
                      isLoading: provider.isLoading,
                      onPressed: _onDeleteTenderPressed,
                    ),
                  ] else ...[
                    if (_currentTender.isLive)
                      PrimaryButton(
                        title: "Place Bid",
                        icon: Icons.gavel_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlaceBidScreen(tender: _currentTender),
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 14),

                    PrimaryButton(
                      title: "View Tender Bids",
                      icon: Icons.format_list_bulleted_rounded,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LiveBidsScreen(tender: _currentTender),
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.bodySecondary()),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.h3()),
        ],
      ),
    );
  }
}
