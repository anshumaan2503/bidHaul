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
import '../../../widgets/render_free_tier_disclaimer.dart';
import '../../../widgets/demo_credentials_disclaimer.dart';
import '../../../theme/app_page_transitions.dart';
import '../dashboard/admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onAdminLoginPressed() async {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter administrative email and password.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.adminLogin(
      email: email,
      password: password,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        AppPageRoute.create(const AdminDashboardScreen()),
        (route) => false,
      );
    } else {
      final error = authProvider.errorMessage ?? 'Admin authentication failed';
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
    final authProvider = Provider.of<AuthProvider>(context);

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.primaryCyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const BidHaulLogo(
                    isVertical: true,
                    logoSize: 100,
                    showSubtitle: true,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.glassSurfaceDark.withValues(alpha: 0.9),
                      borderRadius: AppRadius.xl,
                      border: Border.all(color: AppColors.glassBorderDark),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GOVERNANCE PORTAL',
                          style: AppTypography.microBadge(color: AppColors.glowCyan),
                        ),
                        const SizedBox(height: 4),
                        Text('Admin Portal Login', style: AppTypography.h1()),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'ADMIN EMAIL ADDRESS',
                          style: AppTypography.microBadge(color: AppColors.iceCyan),
                        ),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: _emailController,
                          hint: 'admin@bidhaul.com',
                          prefixIcon: Icons.admin_panel_settings_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'PASSWORD',
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
                        DemoCredentialsDisclaimer(
                          role: 'admin',
                          onQuickFill: (email, password) {
                            setState(() {
                              _emailController.text = email;
                              _passwordController.text = password;
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        const RenderFreeTierDisclaimer(),
                        const SizedBox(height: AppSpacing.md),
                        PrimaryButton(
                          title: 'Sign In to Admin Portal',
                          icon: Icons.shield_outlined,
                          isLoading: authProvider.isLoading,
                          onPressed: _onAdminLoginPressed,
                        ),
                      ],
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
