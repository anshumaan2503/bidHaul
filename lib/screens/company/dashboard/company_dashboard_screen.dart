import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/common/app_search_bar.dart';
import '../../../widgets/dashboard/activity_card.dart';
import '../../../widgets/dashboard/dashboard_card.dart';
import '../../../widgets/dashboard/dashboard_greeting.dart';
import '../../../widgets/dashboard/dashboard_header.dart';
import '../../../widgets/dashboard/dashboard_overview_grid.dart';
import '../../../widgets/dashboard/dashboard_section_header.dart';
import '../../../widgets/dashboard/quick_action_card.dart';
import '../../common/notifications/notifications_screen.dart';
import '../accepted_contracts/accepted_contracts_screen.dart';
import '../analytics/company_analytics_screen.dart';
import '../auction_history/auction_history_screen.dart';
import '../create_tender/create_tender_screen.dart';
import '../my_tenders/my_tenders_screen.dart';
import '../reports/reports_screen.dart';
import '../subscription/subscription_management_screen.dart';
import '../transporter_management/transporter_management_screen.dart';

class CompanyDashboardScreen extends StatelessWidget {
  const CompanyDashboardScreen({super.key});

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
                  const DashboardGreeting(title: 'ABC Logistics'),
                  const SizedBox(height: 32),
                  const AppSearchBar(hint: 'Search Tenders...'),
                  const SizedBox(height: 30),
                  const DashboardSectionHeader(title: 'Overview'),
                  const DashboardOverviewGrid(
                    children: [
                      DashboardCard(
                        title: 'Active Tenders',
                        value: '12',
                        icon: Icons.gavel_rounded,
                      ),
                      DashboardCard(
                        title: 'Live Auctions',
                        value: '4',
                        icon: Icons.flash_on_rounded,
                      ),
                      DashboardCard(
                        title: 'Completed',
                        value: '58',
                        icon: Icons.check_circle_outline_rounded,
                      ),
                      DashboardCard(
                        title: 'Transporters',
                        value: '124',
                        icon: Icons.local_shipping_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const DashboardSectionHeader(title: 'Quick Actions'),
                  QuickActionCard(
                    title: 'Create Tender',
                    icon: Icons.add_circle_outline_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateTenderScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  QuickActionCard(
                    title: 'My Tenders',
                    icon: Icons.description_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyTendersScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  QuickActionCard(
                    title: "Accepted Contracts",
                    icon: Icons.handshake_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AcceptedContractsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  QuickActionCard(
                    title: "Auction History",
                    icon: Icons.history_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AuctionHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  QuickActionCard(
                    title: 'Analytics',
                    icon: Icons.bar_chart_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CompanyAnalyticsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  QuickActionCard(
                    title: "Reports",
                    icon: Icons.assessment_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReportsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  QuickActionCard(
                    title: "Transporters",
                    icon: Icons.local_shipping_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TransporterManagementScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  QuickActionCard(
                    title: "Subscription",
                    subtitle: "Manage Plans",
                    icon: Icons.workspace_premium_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SubscriptionManagementScreen(),
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
                  const SizedBox(height: 32),
                  const DashboardSectionHeader(title: 'Recent Activity'),
                  const ActivityCard(
                    title: 'Tender #245 Created',
                    subtitle: '2 minutes ago',
                    icon: Icons.add_task_rounded,
                  ),
                  const SizedBox(height: 14),
                  const ActivityCard(
                    title: 'Auction Started',
                    subtitle: 'Tender #238',
                    icon: Icons.gavel_rounded,
                  ),
                  const SizedBox(height: 14),
                  const ActivityCard(
                    title: '6 New Bids Received',
                    subtitle: 'Tender #233',
                    icon: Icons.local_shipping_rounded,
                  ),
                  const SizedBox(height: 14),
                  const ActivityCard(
                    title: 'Tender Closed Successfully',
                    subtitle: 'Tender #220',
                    icon: Icons.check_circle_rounded,
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
