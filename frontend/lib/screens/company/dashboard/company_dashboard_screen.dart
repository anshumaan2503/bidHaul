import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_page_transitions.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/dashboard/activity_card.dart';
import '../../../widgets/dashboard/dashboard_card.dart';
import '../../../widgets/dashboard/dashboard_greeting.dart';
import '../../../widgets/dashboard/dashboard_header.dart';
import '../../../widgets/dashboard/dashboard_overview_grid.dart';
import '../../../widgets/dashboard/dashboard_section_header.dart';
import '../../../widgets/dashboard/quick_action_card.dart';
import '../../common/notifications/notifications_screen.dart';
import '../../splash/splash_screen.dart';
import '../accepted_contracts/accepted_contracts_screen.dart';
import '../analytics/company_analytics_screen.dart';
import '../auction_history/auction_history_screen.dart';
import '../create_tender/create_tender_screen.dart';
import '../my_tenders/my_tenders_screen.dart';
import '../reports/reports_screen.dart';
import '../subscription/subscription_management_screen.dart';
import '../transporter_management/transporter_management_screen.dart';

/// CompanyDashboardScreen
///
/// Ultra-modern, executive B2B SaaS dashboard for Freight Companies / Shippers.
/// Features ambient gold lighting, staggered entrance animations, and high-impact metrics.
class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bgAnimationController;

  @override
  void initState() {
    super.initState();
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkMidnight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.glassBorderDark),
        ),
        title: const Text(
          "Confirm Logout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to log out of your BidHaul session?",
          style: TextStyle(color: Colors.white70),
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
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                AppPageRoute.create(const SplashScreen()),
                (route) => false,
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    String companyTitle = 'ABC Logistics';
    if (user != null && user.email.isNotEmpty) {
      if (user.email.toLowerCase() == 'test@company.com' ||
          user.email.toLowerCase() == 'company@test.com') {
        companyTitle = 'ABC Logistics';
      } else if (user.fullName.trim().isNotEmpty) {
        companyTitle = user.fullName.trim();
      }
    }

    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Fluid Dark Espresso Background Gradient
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              final t = _bgAnimationController.value;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1.2 + (t * 0.4), -1.0),
                    end: Alignment(1.2 - (t * 0.4), 1.0),
                    colors: [
                      Color.lerp(AppColors.bgStop1, AppColors.bgStop3, t)!,
                      Color.lerp(AppColors.bgStop2, AppColors.bgStop5, t)!,
                      Color.lerp(AppColors.bgStop4, AppColors.bgStop6, t)!,
                      Color.lerp(AppColors.bgStop7, AppColors.bgStop8, t)!,
                    ],
                    stops: const [0.0, 0.35, 0.70, 1.0],
                  ),
                ),
              );
            },
          ),

          // 2. Ambient Top-Right Gold Light Orb
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              final t = _bgAnimationController.value;
              final offsetY = math.sin(t * math.pi) * 15.0;

              return Positioned(
                top: -60 + offsetY,
                right: -70,
                child: Container(
                  width: screenSize.width * 0.85,
                  height: screenSize.width * 0.85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryCyan.withValues(alpha: 0.20),
                        AppColors.primaryBlue.withValues(alpha: 0.10),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.50, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          // 3. Main Dashboard Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardHeader(
                    onLogoutTap: () => _showLogoutDialog(context),
                  ),

                  const SizedBox(height: 24),

                  DashboardGreeting(title: companyTitle),

                  const SizedBox(height: 28),

                  const DashboardSectionHeader(title: 'Overview Metrics'),

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
                    subtitle: 'Post new freight tender to reverse auction',
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

                  QuickActionCard(
                    title: 'My Tenders',
                    subtitle: 'Manage active and upcoming tenders',
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

                  QuickActionCard(
                    title: 'Accepted Contracts',
                    subtitle: 'View finalized agreements & awarded bids',
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

                  QuickActionCard(
                    title: 'Auction History',
                    subtitle: 'Review historical bid logs and analytics',
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

                  QuickActionCard(
                    title: 'Analytics',
                    subtitle: 'Market trends and spending insights',
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

                  QuickActionCard(
                    title: 'Reports',
                    subtitle: 'Download contract and audit statements',
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

                  QuickActionCard(
                    title: 'Transporters',
                    subtitle: 'Directory of verified carrier partners',
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

                  QuickActionCard(
                    title: 'Subscription',
                    subtitle: 'Manage Plans & Tier Access',
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

                  QuickActionCard(
                    title: 'Notifications',
                    subtitle: 'Alerts, updates, and system messages',
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

                  QuickActionCard(
                    title: 'Logout',
                    subtitle: 'Sign out of your company account',
                    icon: Icons.logout_rounded,
                    iconColor: AppColors.dangerRed,
                    onTap: () => _showLogoutDialog(context),
                  ),

                  const SizedBox(height: 32),

                  const DashboardSectionHeader(title: 'Recent Activity'),

                  const ActivityCard(
                    title: 'Tender #245 Created',
                    subtitle: '2 minutes ago',
                    icon: Icons.add_task_rounded,
                  ),

                  const ActivityCard(
                    title: 'Auction Started',
                    subtitle: 'Tender #238',
                    icon: Icons.gavel_rounded,
                  ),

                  const ActivityCard(
                    title: '6 New Bids Received',
                    subtitle: 'Tender #233',
                    icon: Icons.local_shipping_rounded,
                  ),

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
