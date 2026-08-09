import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/bidhaul_logo.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/inputs/app_text_field.dart';
import '../../../theme/app_page_transitions.dart';
import '../../company/navigation/company_navigation_screen.dart';
import '../../transporter/dashboard/transporter_dashboard_screen.dart';

/// SignupScreen
///
/// Executive dark espresso registration screen for BidHaul.
/// Tailors form fields, labels, and badges based on the user role (Company vs Transporter).
class SignupScreen extends StatefulWidget {
  final String role;

  const SignupScreen({super.key, required this.role});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _companyController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AnimationController _bgAnimationController;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

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
    _companyController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _bgAnimationController.dispose();
    super.dispose();
  }

  Future<void> _onSignupPressed() async {
    FocusScope.of(context).unfocus();

    final fullName = _contactController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final companyName = _companyController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Full name, email address, and password are required.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters long.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match. Please verify.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final portalRole = widget.role.toLowerCase() == 'company' ? 'COMPANY' : 'TRANSPORTER';

    final success = await authProvider.signup(
      email: email,
      password: password,
      fullName: fullName,
      companyName: companyName.isNotEmpty ? companyName : null,
      phone: phone.isNotEmpty ? phone : null,
      role: portalRole,
    );

    if (!mounted) return;

    if (success) {
      final user = authProvider.user;
      if (user != null && user.isCompany) {
        Navigator.pushAndRemoveUntil(
          context,
          AppPageRoute.create(const CompanyNavigationScreen()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          AppPageRoute.create(const TransporterDashboardScreen()),
          (route) => false,
        );
      }
    } else {
      final error = authProvider.errorMessage ?? 'Registration failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isCompany = widget.role == 'company';
    final roleTitle = isCompany ? 'Company Account' : 'Transporter Account';
    final roleBadge = isCompany ? 'SHIPPER REGISTRATION' : 'CARRIER REGISTRATION';
    final roleIcon = isCompany ? Icons.business_center_rounded : Icons.local_shipping_rounded;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Animated Dark Espresso Fluid Background
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
                      Color.lerp(AppColors.bgStop1, AppColors.bgStop2, t)!,
                      Color.lerp(AppColors.bgStop3, AppColors.bgStop5, t)!,
                      Color.lerp(AppColors.bgStop4, AppColors.bgStop6, t)!,
                      Color.lerp(AppColors.bgStop7, AppColors.bgStop8, t)!,
                    ],
                    stops: const [0.0, 0.35, 0.70, 1.0],
                  ),
                ),
              );
            },
          ),

          // 2. Ambient Top Light Glow Orb
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              final t = _bgAnimationController.value;
              final offsetY = math.sin(t * math.pi) * 15.0;

              return Positioned(
                top: -80 + offsetY,
                right: -60,
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

          // 3. Main Screen Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sm),

                  // Top Bar (Back Button + Portal Badge)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.glassSurfaceDark,
                          border: Border.all(
                            color: AppColors.glassBorderDark,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.primaryCyan,
                            size: 18,
                          ),
                        ),
                      ),

                      // Role Pill Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCyan.withValues(alpha: 0.12),
                          borderRadius: AppRadius.full,
                          border: Border.all(
                            color: AppColors.primaryCyan.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              roleIcon,
                              size: 14,
                              color: AppColors.primaryCyan,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              roleBadge,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.1,
                                color: AppColors.primaryCyan,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Logo Box
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.glassSurfaceDark.withValues(alpha: 0.8),
                        borderRadius: AppRadius.xl,
                        border: Border.all(
                          color: AppColors.glassBorderDark,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const BidHaulLogo(
                        isVertical: false,
                        logoSize: 42,
                        showSubtitle: false,
                        showGetStarted: false,
                        animateEntrance: false,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Header Typography
                  Text(
                    'ONBOARDING',
                    style: AppTypography.microBadge(color: AppColors.iceCyan),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create $roleTitle',
                    style: AppTypography.displayHero(),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Fill in your business credentials to register your account on the BidHaul reverse auction network.',
                    style: AppTypography.bodySecondary(),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Main Form Card (Glass Container)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.glassSurfaceDark.withValues(alpha: 0.85),
                      borderRadius: AppRadius.xl,
                      border: Border.all(
                        color: AppColors.glassBorderDark,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Organization / Company Name
                        Text(
                          isCompany ? 'COMPANY LEGAL NAME' : 'TRANSPORT FLEET NAME',
                          style: AppTypography.microBadge(color: AppColors.iceCyan),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: _companyController,
                          hint: isCompany ? 'e.g. Global Freight Logistics Ltd.' : 'e.g. Apex Transport Fleet',
                          prefixIcon: isCompany ? Icons.business_rounded : Icons.local_shipping_rounded,
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // 2. Primary Contact / Owner
                        Text(
                          isCompany ? 'PRIMARY CONTACT PERSON' : 'FLEET OWNER / MANAGER',
                          style: AppTypography.microBadge(color: AppColors.iceCyan),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: _contactController,
                          hint: 'Full Name',
                          prefixIcon: Icons.person_outline_rounded,
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // 3. Work Email
                        Text(
                          'WORK EMAIL ADDRESS',
                          style: AppTypography.microBadge(color: AppColors.iceCyan),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: _emailController,
                          hint: 'corporate@domain.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // 4. Phone Number
                        Text(
                          'DIRECT PHONE NUMBER',
                          style: AppTypography.microBadge(color: AppColors.iceCyan),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: _phoneController,
                          hint: '+1 (555) 000-0000',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // 5. Password
                        Text(
                          'PASSWORD',
                          style: AppTypography.microBadge(color: AppColors.iceCyan),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: _passwordController,
                          hint: 'Minimum 8 characters',
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
                              size: 20,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // 6. Confirm Password
                        Text(
                          'CONFIRM PASSWORD',
                          style: AppTypography.microBadge(color: AppColors.iceCyan),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: _confirmPasswordController,
                          hint: 'Re-enter password',
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
                              size: 20,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Register CTA Button
                        PrimaryButton(
                          title: 'Complete Registration',
                          icon: Icons.arrow_forward_rounded,
                          isLoading: authProvider.isLoading,
                          onPressed: _onSignupPressed,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Already registered footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTypography.bodySecondary(),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Sign In',
                          style: AppTypography.bodyPrimary(
                            color: AppColors.primaryCyan,
                          ).copyWith(
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryCyan,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
