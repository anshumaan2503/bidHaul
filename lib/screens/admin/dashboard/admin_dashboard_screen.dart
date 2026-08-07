import 'package:flutter/material.dart';

import '../../../dummy/dummy_admin_dashboard.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/admin_dashboard_card.dart';
import '../company_verification/company_verification_screen.dart';
import '../platform_management/admin_management_screen.dart';
import '../platform_management/audit_logs_screen.dart';
import '../platform_management/platform_settings_screen.dart';
import '../platform_management/reports_screen.dart';
import '../platform_management/revenue_analytics_screen.dart';
import '../subscription_monitoring/subscription_monitoring_screen.dart';
import '../tender_monitoring/tender_monitoring_screen.dart';
import '../transporter_verification/transporter_verification_screen.dart';
import '../user_management/user_management_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

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
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Admin Dashboard", style: AppTypography.displayHero()),

                  const SizedBox(height: AppSpacing.xl),

                  Expanded(
                    child: ListView.builder(
                      itemCount: dummyAdminDashboard.length,
                      itemBuilder: (context, index) {
                        final item = dummyAdminDashboard[index];

                        return AdminDashboardCard(
                          title: item.title,
                          subtitle: item.subtitle,
                          onTap: () {
                            switch (item.routeName) {
                              case "company_verification":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const CompanyVerificationScreen(),
                                  ),
                                );
                                break;
                              case "transporter_verification":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const TransporterVerificationScreen(),
                                  ),
                                );
                                break;
                              case "tender_monitoring":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const TenderMonitoringScreen(),
                                  ),
                                );
                                break;
                              case "user_management":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const UserManagementScreen(),
                                  ),
                                );
                                break;
                              case "subscriptions":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const SubscriptionMonitoringScreen(),
                                  ),
                                );
                                break;
                              case "reports":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ReportsScreen(),
                                  ),
                                );
                                break;

                              case "revenue_analytics":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const RevenueAnalyticsScreen(),
                                  ),
                                );
                                break;

                              case "platform_settings":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const PlatformSettingsScreen(),
                                  ),
                                );
                                break;

                              case "admin_management":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const AdminManagementScreen(),
                                  ),
                                );
                                break;

                              case "audit_logs":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AuditLogsScreen(),
                                  ),
                                );
                                break;
                              default:
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${item.title} module coming next",
                                    ),
                                  ),
                                );
                            }
                          },
                        );
                      },
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
