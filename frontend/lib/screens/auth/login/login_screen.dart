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
import '../../admin/dashboard/admin_dashboard_screen.dart';
import '../../company/navigation/company_navigation_screen.dart';
import '../../transporter/dashboard/transporter_dashboard_screen.dart';
import '../forgot_password/forgot_password_screen.dart';
import '../signup/signup_screen.dart';

/// LoginScreen
///
/// Executive dark espresso login portal for BidHaul.
/// Dynamically customizes layout, badges, and colors based on role (Company vs Transporter).
class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AnimationController _bgAnimationController;
  bool obscurePassword = true;

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
    _emailController.dispose();
    _passwordController.dispose();
    _bgAnimationController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email address and password'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final portalRole = widget.role.toLowerCase() == 'company' ? 'COMPANY' : 'TRANSPORTER';

    final success = await authProvider.login(
      email: email,
      password: password,
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
      } else if (user != null && user.isTransporter) {
        Navigator.pushAndRemoveUntil(
          context,
          AppPageRoute.create(const TransporterDashboardScreen()),
          (route) => false,
        );
      } else if (user != null && user.isAdministrative) {
        Navigator.pushAndRemoveUntil(
          context,
          AppPageRoute.create(const AdminDashboardScreen()),
          (route) => false,
        );
      }
    } else {
      final error = authProvider.errorMessage ?? 'Authentication failed';
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
    final roleTitle = isCompany ? 'Company Shipper' : 'Fleet Carrier';
    final roleBadge = isCompany ? 'SHIPPER PORTAL' : 'CARRIER PORTAL';
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
                left: -60,
                child: Container(
                  width: screenSize.width * 0.85,
                  height: screenSize.width * 0.85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryCyan.withValues(alpha: 0.22),
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

                  // Center Logo Box
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

                  // Welcome Header Section
                  Text(
                    'WELCOME BACK',
                    style: AppTypography.microBadge(color: AppColors.iceCyan),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$roleTitle Login',
                    style: AppTypography.displayHero(),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sign in with your enterprise credentials to access your reverse auction dashboard.',
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
                        // Email Field
                        Text(
                          'WORK EMAIL ADDRESS',
                          style: AppTypography.microBadge(color: AppColors.iceCyan),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: _emailController,
                          hint: isCompany ? 'company@domain.com' : 'transporter@carrier.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Password Field
                        Text(
                          'ACCOUNT PASSWORD',
                          style: AppTypography.microBadge(color: AppColors.iceCyan),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: _passwordController,
                          hint: '••••••••••••',
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

                        const SizedBox(height: AppSpacing.sm),

                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                               AppPageRoute.create(
                                  ForgotPasswordScreen(role: widget.role),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: AppTypography.bodySecondary(
                                color: AppColors.primaryCyan,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Login CTA Button
                        PrimaryButton(
                          title: 'Sign In to Portal',
                          icon: Icons.arrow_forward_rounded,
                          isLoading: authProvider.isLoading,
                          onPressed: _onLoginPressed,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Register / Signup Footer
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
                            AppPageRoute.create(
                              SignupScreen(role: widget.role),
                            ),
                          );
                        },
                        child: Text(
                          'Register Here',
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
