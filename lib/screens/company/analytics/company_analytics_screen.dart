import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/dashboard/dashboard_card.dart';

class CompanyAnalyticsScreen extends StatelessWidget {
  const CompanyAnalyticsScreen({super.key});

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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text("Analytics", style: AppTypography.displayHero()),
                    ],
                  ),

                  const SizedBox(height: 30),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.15,
                    children: const [
                      DashboardCard(
                        title: "Total Tenders",
                        value: "58",
                        icon: Icons.description,
                      ),

                      DashboardCard(
                        title: "Live Auctions",
                        value: "12",
                        icon: Icons.gavel,
                      ),

                      DashboardCard(
                        title: "Bids Received",
                        value: "247",
                        icon: Icons.local_shipping,
                      ),

                      DashboardCard(
                        title: "Completed",
                        value: "46",
                        icon: Icons.check_circle,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Text("Performance", style: AppTypography.h2()),

                  const SizedBox(height: 16),

                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .06),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.bar_chart,
                        size: 80,
                        color: AppColors.primaryCyan,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text("Insights", style: AppTypography.h2()),

                  const SizedBox(height: 16),

                  const ListTile(
                    leading: Icon(Icons.trending_up, color: Colors.green),
                    title: Text(
                      "Tender Success Rate : 92%",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const ListTile(
                    leading: Icon(Icons.attach_money, color: Colors.orange),
                    title: Text(
                      "Average Winning Bid : ₹38,500",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const ListTile(
                    leading: Icon(Icons.people, color: Colors.cyan),
                    title: Text(
                      "124 Registered Transporters",
                      style: TextStyle(color: Colors.white),
                    ),
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
