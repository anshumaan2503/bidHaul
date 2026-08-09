import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/admin_governance_provider.dart';
import 'providers/admin_kyc_provider.dart';
import 'providers/audit_log_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/bid_provider.dart';
import 'providers/company_profile_provider.dart';
import 'providers/contract_provider.dart';
import 'providers/delivery_provider.dart';
import 'providers/invoice_provider.dart';
import 'providers/negotiation_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/subscription_provider.dart';
import 'providers/tender_provider.dart';
import 'providers/transporter_profile_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'services/push_notification_service.dart';
import 'theme/app_theme.dart';
import 'theme/bidhaul_scroll_behavior.dart';
import 'widgets/web_responsive_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService().initialize();
  PushNotificationService().startLiveBidPolling();
  runApp(const BidHaulApp());
}

class BidHaulApp extends StatelessWidget {
  const BidHaulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..restoreSession()),
        ChangeNotifierProvider(create: (_) => CompanyProfileProvider()),
        ChangeNotifierProvider(create: (_) => TransporterProfileProvider()),
        ChangeNotifierProvider(create: (_) => AdminKycProvider()),
        ChangeNotifierProvider(create: (_) => AdminGovernanceProvider()),
        ChangeNotifierProvider(create: (_) => AuditLogProvider()),
        ChangeNotifierProvider(create: (_) => TenderProvider()),
        ChangeNotifierProvider(create: (_) => BidProvider()),
        ChangeNotifierProvider(create: (_) => NegotiationProvider()),
        ChangeNotifierProvider(create: (_) => ContractProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'BidHaul - Smart Reverse Auction Network',
        debugShowCheckedModeBanner: false,
        scrollBehavior: const BidHaulScrollBehavior(),
        themeMode: ThemeMode.dark,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        builder: (context, child) => WebResponsiveWrapper(child: child ?? const SizedBox()),
        home: const SplashScreen(),
      ),
    );
  }
}