import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/bidhaul_logo.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/inputs/app_text_field.dart';
import '../signup/signup_screen.dart';
import '../../transporter/dashboard/transporter_dashboard_screen.dart';
import '../../company/navigation/company_navigation_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.role});

  final String role;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    FocusScope.of(context).unfocus();
    if (!mounted) return;

    if (widget.role == 'company') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CompanyNavigationScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TransporterDashboardScreen()),
      );
    }
  }

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

          Positioned(
            top: -140,
            left: -120,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryCyan.withValues(alpha: .20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -170,
            right: -120,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryBlue.withValues(alpha: .18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: .08),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .15),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Center(
                    child: BidHaulLogo(
                      isVertical: true,
                      logoSize: 85,
                      showSubtitle: false,
                      showGetStarted: false,
                      animateEntrance: false,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text('Welcome Back', style: AppTypography.displayHero()),

                  const SizedBox(height: 6),

                  Text(
                    widget.role == 'company'
                        ? 'Company Portal Login'
                        : 'Transporter Portal Login',
                    style: AppTypography.h2(color: AppColors.iceCyan),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Sign in to access your reverse auction dashboard.',
                    style: AppTypography.bodySecondary(),
                  ),

                  const SizedBox(height: 32),

                  // 1. Email Field
                  AppTextField(
                    controller: _emailController,
                    hint: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 18),

                  // 2. Password Field
                  AppTextField(
                    controller: _passwordController,
                    hint: 'Password',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: obscurePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.iceCyan,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: AppTypography.bodySecondary(
                          color: AppColors.primaryCyan,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Sign In CTA Button
                  PrimaryButton(title: 'Sign In', onPressed: _onLoginPressed),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTypography.bodySecondary(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SignupScreen(role: widget.role),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTypography.bodyPrimary(
                            color: AppColors.primaryCyan,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
