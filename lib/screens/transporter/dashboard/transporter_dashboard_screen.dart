import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/common/app_search_bar.dart';
import '../../../widgets/dashboard/dashboard_card.dart';
import '../../../widgets/dashboard/dashboard_greeting.dart';
import '../../../widgets/dashboard/dashboard_header.dart';
import '../../../widgets/dashboard/dashboard_overview_grid.dart';
import '../../../widgets/dashboard/dashboard_section_header.dart';
import '../../../widgets/dashboard/quick_action_card.dart';
import '../../common/notifications/notifications_screen.dart';
import '../bid_history/bid_history_screen.dart';
import '../browse_tenders/browse_tenders_screen.dart';
import '../my_bids/my_bids_screen.dart';
import '../won_auctions/won_auctions_screen.dart';

class TransporterDashboardScreen extends StatelessWidget {
  const TransporterDashboardScreen({super.key});

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardHeader(),
                  const SizedBox(height: 28),
                  const DashboardGreeting(title: "ABC Transport"),
                  const SizedBox(height: 28),
                  const AppSearchBar(hint: "Search Tenders..."),
                  const SizedBox(height: 30),
                  const DashboardSectionHeader(title: "Overview"),
                  const DashboardOverviewGrid(
                    children: [
                      DashboardCard(
                        title: "Available",
                        value: "35",
                        icon: Icons.inventory_2_outlined,
                      ),
                      DashboardCard(
                        title: "Active Bids",
                        value: "12",
                        icon: Icons.gavel_rounded,
                      ),
                      DashboardCard(
                        title: "Won",
                        value: "6",
                        icon: Icons.emoji_events_outlined,
                      ),
                      DashboardCard(
                        title: "Completed",
                        value: "41",
                        icon: Icons.check_circle_outline,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const DashboardSectionHeader(title: "Quick Actions"),
                  QuickActionCard(
                    title: "Browse Tenders",
                    icon: Icons.search_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BrowseTendersScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  QuickActionCard(
                    title: "My Bids",
                    icon: Icons.local_shipping_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyBidsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  QuickActionCard(
                    title: "Won Auctions",
                    icon: Icons.emoji_events_rounded,
                    iconColor: AppColors.statusAmber,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WonAuctionsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  QuickActionCard(
                    title: "Bid History",
                    icon: Icons.history_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BidHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  QuickActionCard(
                    title: "Notifications",
                    icon: Icons.notifications_none_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
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
