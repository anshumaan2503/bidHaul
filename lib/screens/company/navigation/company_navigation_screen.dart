import 'package:flutter/material.dart';

import '../../../widgets/navigation/app_bottom_navigation.dart';
import '../create_tender/create_tender_screen.dart';
import '../dashboard/company_dashboard_screen.dart';
import '../my_tenders/my_tenders_screen.dart';

class CompanyNavigationScreen extends StatefulWidget {
  const CompanyNavigationScreen({super.key});

  @override
  State<CompanyNavigationScreen> createState() =>
      _CompanyNavigationScreenState();
}

class _CompanyNavigationScreenState extends State<CompanyNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CompanyDashboardScreen(),
    MyTendersScreen(),
    CreateTenderScreen(),
    _CompanyNotificationsScreen(),
    _CompanyProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _CompanyNotificationsScreen extends StatelessWidget {
  const _CompanyNotificationsScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Company Notifications",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}

class _CompanyProfileScreen extends StatelessWidget {
  const _CompanyProfileScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Company Profile",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}