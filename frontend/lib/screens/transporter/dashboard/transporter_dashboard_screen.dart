import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_page_transitions.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/dashboard/dashboard_card.dart';
import '../../../widgets/dashboard/dashboard_greeting.dart';
import '../../../widgets/dashboard/dashboard_header.dart';
import '../../../widgets/dashboard/dashboard_overview_grid.dart';
import '../../../widgets/dashboard/dashboard_section_header.dart';
import '../../../widgets/dashboard/quick_action_card.dart';
import '../../common/notifications/notifications_screen.dart';
import '../../splash/splash_screen.dart';
import '../bid_history/bid_history_screen.dart';
import '../browse_tenders/browse_tenders_screen.dart';
import '../my_bids/my_bids_screen.dart';
import '../won_auctions/won_auctions_screen.dart';
import '../../company/post_bid_negotiation/post_bid_negotiation_screen.dart';

/// TransporterDashboardScreen
///
/// Executive B2B SaaS dashboard for Transporters / Fleet Carriers.
/// Built with luxury dark espresso glassmorphism, animated lighting, and zero alterations to functional routes.
class TransporterDashboardScreen extends StatefulWidget {
  const TransporterDashboardScreen({super.key});

  @override
  State<TransporterDashboardScreen> createState() => _TransporterDashboardScreenState();
}

class _TransporterDashboardScreenState extends State<TransporterDashboardScreen>
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

    String transporterTitle = 'ABC Transport';
    if (user != null && user.email.isNotEmpty) {
      if (user.email.toLowerCase() == 'test@transporter.com' ||
          user.email.toLowerCase() == 'transporter@test.com') {
        transporterTitle = 'ABC Transport';
      } else if (user.fullName.trim().isNotEmpty) {
        transporterTitle = user.fullName.trim();
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

                  DashboardGreeting(title: transporterTitle),

                  const SizedBox(height: 28),

                  const DashboardSectionHeader(title: "Carrier Overview"),

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
                    subtitle: "Explore live reverse auction tenders",
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

                  QuickActionCard(
                    title: "My Bids",
                    subtitle: "Track live submitted auction bids",
                    icon: Icons.local_shipping_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyBidsScreen()),
                      );
                    },
                  ),

                  QuickActionCard(
                    title: "Negotiations & Counter Offers",
                    subtitle: "Review & respond to company rate counter-offers",
                    icon: Icons.handshake_rounded,
                    iconColor: AppColors.primaryCyan,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PostBidNegotiationScreen(),
                        ),
                      );
                    },
                  ),

                  QuickActionCard(
                    title: "Won Auctions",
                    subtitle: "Awarded tenders & active contracts",
                    icon: Icons.emoji_events_rounded,
                    iconColor: AppColors.warningAmber,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WonAuctionsScreen(),
                        ),
                      );
                    },
                  ),

                  QuickActionCard(
                    title: "Bid History",
                    subtitle: "Archived bids and contract log",
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

                  QuickActionCard(
                    title: "Notifications",
                    subtitle: "Auction alerts & contract notifications",
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
                    title: "Logout",
                    subtitle: "Sign out of your carrier account",
                    icon: Icons.logout_rounded,
                    iconColor: AppColors.dangerRed,
                    onTap: () => _showLogoutDialog(context),
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
