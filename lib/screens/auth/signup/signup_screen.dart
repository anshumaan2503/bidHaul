import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/bidhaul_logo.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/inputs/app_text_field.dart';
import '../../transporter/dashboard/transporter_dashboard_screen.dart';
import '../../company/navigation/company_navigation_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.role});

  final String role;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _companyController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    _companyController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignupPressed() {
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

                  const SizedBox(height: 30),

                  Text('Create Account', style: AppTypography.displayHero()),

                  const SizedBox(height: 6),

                  Text(
                    widget.role == 'company'
                        ? 'Company Registration'
                        : 'Transporter Registration',
                    style: AppTypography.h2(color: AppColors.iceCyan),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Complete the information below.',
                    style: AppTypography.bodySecondary(),
                  ),

                  const SizedBox(height: 32),

                  // Company / Transport Company
                  AppTextField(
                    controller: _companyController,
                    hint: widget.role == 'company'
                        ? 'Company Name'
                        : 'Transport Company',
                    prefixIcon: Icons.business_rounded,
                  ),

                  const SizedBox(height: 18),

                  // Contact Person / Owner
                  AppTextField(
                    controller: _contactController,
                    hint: widget.role == 'company'
                        ? 'Contact Person'
                        : 'Owner Name',
                    prefixIcon: Icons.person_outline_rounded,
                  ),

                  const SizedBox(height: 18),

                  // Email
                  AppTextField(
                    controller: _emailController,
                    hint: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 18),

                  // Phone
                  AppTextField(
                    controller: _phoneController,
                    hint: 'Phone Number',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 18),

                  // Password
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

                  const SizedBox(height: 18),

                  // Confirm Password
                  AppTextField(
                    controller: _confirmPasswordController,
                    hint: 'Confirm Password',
                    prefixIcon: Icons.lock_reset_rounded,
                    obscureText: obscureConfirmPassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.iceCyan,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  PrimaryButton(
                    title: 'Create Account',
                    onPressed: _onSignupPressed,
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTypography.bodySecondary(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Sign In',
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
