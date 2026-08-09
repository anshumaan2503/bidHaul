import '../models/admin_dashboard_item.dart';

final List<AdminDashboardItem> dummyAdminDashboard = [
  const AdminDashboardItem(
    title: "Company Verification",
    subtitle: "Approve or Reject Companies",
    routeName: "company_verification",
  ),
  const AdminDashboardItem(
    title: "Transporter Verification",
    subtitle: "Approve or Reject Transporters",
    routeName: "transporter_verification",
  ),
  const AdminDashboardItem(
    title: "Tender Monitoring",
    subtitle: "Monitor Live Auctions",
    routeName: "tender_monitoring",
  ),
  const AdminDashboardItem(
    title: "User Management",
    subtitle: "Manage Platform Users",
    routeName: "user_management",
  ),
  const AdminDashboardItem(
    title: "Subscriptions",
    subtitle: "Subscription Analytics",
    routeName: "subscriptions",
  ),
  const AdminDashboardItem(
    title: "Reports",
    subtitle: "Platform Reports",
    routeName: "reports",
  ),
  const AdminDashboardItem(
    title: "Revenue Analytics",
    subtitle: "Platform Revenue",
    routeName: "revenue_analytics",
  ),

  const AdminDashboardItem(
    title: "Payment Gateway Control",
    subtitle: "Shutdown or Turn ON Platform Payment Gateway",
    routeName: "payment_gateway_control",
  ),
  const AdminDashboardItem(
    title: "Platform Settings",
    subtitle: "Manage Platform",
    routeName: "platform_settings",
  ),

  const AdminDashboardItem(
    title: "Admin Management",
    subtitle: "Manage Admin Accounts",
    routeName: "admin_management",
  ),

  const AdminDashboardItem(
    title: "Audit Logs",
    subtitle: "System Activity",
    routeName: "audit_logs",
  ),
];
