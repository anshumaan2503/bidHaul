import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dummy/dummy_admin_dashboard.dart';
import '../../../providers/admin_governance_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/payment_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/admin_dashboard_card.dart';
import '../../../widgets/common/base_glass_card.dart';
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

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminGovernanceProvider>(context, listen: false).fetchDashboard();
    });
  }

  Widget _buildMetricTile(String label, String value, IconData icon) {
    return Expanded(
      child: BaseGlassCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: AppColors.primaryCyan, size: 20),
                Flexible(
                  child: Text(
                    value,
                    style: AppTypography.h2().copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.bodySecondary().copyWith(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final isSuperAdmin = user?.isSuperAdmin ?? false;

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
            child: Consumer<AdminGovernanceProvider>(
              builder: (context, govProvider, child) {
                final dash = govProvider.dashboard;

                return RefreshIndicator(
                  onRefresh: () => govProvider.fetchDashboard(),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Admin Dashboard",
                                    style: AppTypography.displayHero(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    isSuperAdmin ? "Super Admin Governance" : "System Administration",
                                    style: AppTypography.bodySecondary(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (isSuperAdmin)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.amber),
                                ),
                                child: const Text(
                                  "SUPER ADMIN",
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // ALWAYS VISIBLE PAYMENT GATEWAY CONTROL BANNER
                        Consumer<PaymentProvider>(
                          builder: (context, paymentProvider, _) {
                            final isShutdown = paymentProvider.isGatewayShutdown;
                            return Container(
                              margin: const EdgeInsets.only(bottom: AppSpacing.md),
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: isShutdown
                                    ? Colors.red.withValues(alpha: 0.15)
                                    : Colors.green.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isShutdown ? Colors.redAccent : Colors.greenAccent,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            isShutdown ? Icons.power_settings_new : Icons.payment,
                                            color: isShutdown ? Colors.redAccent : Colors.greenAccent,
                                            size: 22,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Payment Gateway",
                                            style: AppTypography.h3().copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: isShutdown
                                              ? Colors.red.withValues(alpha: 0.3)
                                              : Colors.green.withValues(alpha: 0.3),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: isShutdown ? Colors.redAccent : Colors.greenAccent,
                                          ),
                                        ),
                                        child: Text(
                                          isShutdown ? "SHUTDOWN" : "ONLINE",
                                          style: TextStyle(
                                            color: isShutdown ? Colors.redAccent : Colors.greenAccent,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    isShutdown
                                        ? "Transactions are paused for maintenance."
                                        : "Razorpay payment gateway is active.",
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isShutdown ? Colors.green : Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      icon: Icon(
                                        isShutdown ? Icons.play_arrow : Icons.power_settings_new,
                                        size: 16,
                                      ),
                                      label: Text(
                                        isShutdown ? "TURN ON GATEWAY" : "SHUTDOWN GATEWAY",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                      ),
                                      onPressed: () => _confirmPaymentGatewayToggle(context, paymentProvider),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        if (govProvider.isLoadingDashboard && dash == null)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(AppSpacing.lg),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (govProvider.dashboardError != null && dash == null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                            child: Text(
                              "Error: ${govProvider.dashboardError}",
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          )
                        else if (dash != null) ...[
                          Row(
                            children: [
                              _buildMetricTile("Total Users", "${dash.totalUsers}", Icons.people),
                              const SizedBox(width: AppSpacing.sm),
                              _buildMetricTile("Companies", "${dash.activeCompanies}", Icons.business),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              _buildMetricTile("Transporters", "${dash.activeTransporters}", Icons.local_shipping),
                              const SizedBox(width: AppSpacing.sm),
                              _buildMetricTile("Live Tenders", "${dash.liveTenders}", Icons.gavel),
                              const SizedBox(width: AppSpacing.sm),
                              _buildMetricTile("Negotiations", "${dash.openNegotiations}", Icons.handshake),
                            ],
                          ),
                        ],

                        const SizedBox(height: AppSpacing.lg),

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
                                          builder: (_) => const CompanyVerificationScreen(),
                                        ),
                                      );
                                      break;
                                    case "transporter_verification":
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const TransporterVerificationScreen(),
                                        ),
                                      );
                                      break;
                                    case "tender_monitoring":
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const TenderMonitoringScreen(),
                                        ),
                                      );
                                      break;
                                    case "user_management":
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const UserManagementScreen(),
                                        ),
                                      );
                                      break;
                                    case "subscriptions":
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const SubscriptionMonitoringScreen(),
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
                                          builder: (_) => const RevenueAnalyticsScreen(),
                                        ),
                                      );
                                      break;
                                    case "platform_settings":
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const PlatformSettingsScreen(),
                                        ),
                                      );
                                      break;
                                    case "admin_management":
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const AdminManagementScreen(),
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
                                          content: Text("${item.title} module coming next"),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmPaymentGatewayToggle(BuildContext context, PaymentProvider paymentProvider) {
    final isShutdown = paymentProvider.isGatewayShutdown;
    final actionText = isShutdown ? "TURN ON" : "SHUTDOWN";

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.glassSurfaceDark,
        title: Row(
          children: [
            Icon(
              isShutdown ? Icons.play_circle_fill : Icons.warning_amber_rounded,
              color: isShutdown ? Colors.greenAccent : Colors.redAccent,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "$actionText Gateway?",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          isShutdown
              ? "Are you sure you want to RE-ACTIVATE the platform payment gateway? Users will be able to make subscription and invoice checkout payments."
              : "Are you sure you want to SHUT DOWN the platform payment gateway? All checkout and payment operations across the app will be temporarily suspended for maintenance.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isShutdown ? Colors.green : Colors.red,
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              paymentProvider.toggleGatewayShutdown();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: isShutdown ? Colors.green : Colors.red,
                  content: Text(
                    isShutdown
                        ? "✅ Payment Gateway is now ACTIVE globally."
                        : "🚨 Payment Gateway has been SHUT DOWN by Super Admin.",
                  ),
                ),
              );
            },
            child: Text(actionText, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
