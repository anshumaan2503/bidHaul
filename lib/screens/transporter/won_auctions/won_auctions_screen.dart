import 'package:flutter/material.dart';

import '../../../dummy/dummy_won_auctions.dart';
import '../../../models/won_auction.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/common/app_search_bar.dart';

class WonAuctionsScreen extends StatefulWidget {
  const WonAuctionsScreen({super.key});

  @override
  State<WonAuctionsScreen> createState() => _WonAuctionsScreenState();
}

class _WonAuctionsScreenState extends State<WonAuctionsScreen> {
  String _search = "";

  @override
  Widget build(BuildContext context) {
    final auctions = dummyWonAuctions.where((auction) {
      final query = _search.toLowerCase();

      return auction.company.toLowerCase().contains(query) ||
          auction.origin.toLowerCase().contains(query) ||
          auction.destination.toLowerCase().contains(query) ||
          auction.vehicleType.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      appBar: AppBar(
        title: const Text("Won Auctions"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppSearchBar(
              hintText: "Search won auctions...",
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: auctions.isEmpty
                  ? const Center(
                      child: Text(
                        "No Won Auctions Yet",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.separated(
                      itemCount: auctions.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _AuctionCard(auction: auctions[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuctionCard extends StatelessWidget {
  final WonAuction auction;

  const _AuctionCard({required this.auction});

  Color _statusColor() {
    switch (auction.status) {
      case "Accepted":
        return Colors.green;

      case "Expired":
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.glassBorderDark,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  auction.company,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Chip(
                backgroundColor: _statusColor(),
                label: Text(auction.status),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _info("Tender ID", auction.id),
          _info("Route", "${auction.origin} → ${auction.destination}"),
          _info("Vehicle", auction.vehicleType),
          _info("Winning Bid", "₹${auction.winningPrice.toStringAsFixed(0)}"),
          _info("Pickup", auction.pickupDate),
          _info("Awarded", auction.awardedDate),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("View Details"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  title: "Accept",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Contract Accepted")),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(title, style: const TextStyle(color: Colors.white54)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
