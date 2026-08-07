import 'package:flutter/material.dart';

import 'screens/splash/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BidHaulApp());
}

class BidHaulApp extends StatelessWidget {
  const BidHaulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BidHaul - Smart Reverse Auction Network',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}