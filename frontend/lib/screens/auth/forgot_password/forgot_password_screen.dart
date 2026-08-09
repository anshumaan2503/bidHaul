import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/bidhaul_logo.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/inputs/app_text_field.dart';

/// ForgotPasswordScreen
///
/// Executive dark espresso password recovery screen for BidHaul.
class ForgotPasswordScreen extends StatefulWidget {
  final String role;

  const ForgotPasswordScreen({super.key, required this.role});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  late final AnimationController _bgAnimationController;
  bool isLoading = false;
  bool isSent = false;

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
    _bgAnimationController.dispose();
    super.dispose();
  }

  void _onResetPressed() {
    FocusScope.of(context).unfocus();
    if (!mounted) return;
    setState(() {
      isSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Fluid Dark Espresso Background
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

          // 2. Ambient Light Orb
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

                  // Back Glass Button
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

                  // Header Text
                  Text(
                    'RECOVERY',
                    style: AppTypography.microBadge(color: AppColors.iceCyan),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Reset Password',
                    style: AppTypography.displayHero(),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Enter your registered enterprise email address below to receive password reset instructions.',
                    style: AppTypography.bodySecondary(),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Glass Form Card
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
                    child: isSent
                        ? Column(
                            children: [
                              const Icon(
                                Icons.mark_email_read_rounded,
                                size: 56,
                                color: AppColors.primaryCyan,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'Reset Link Sent',
                                style: AppTypography.h2(color: Colors.white),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'We have dispatched a password recovery link to ${_emailController.text}. Please check your inbox.',
                                textAlign: TextAlign.center,
                                style: AppTypography.bodySecondary(),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              PrimaryButton(
                                title: 'Back to Login',
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'REGISTERED WORK EMAIL',
                                style: AppTypography.microBadge(color: AppColors.iceCyan),
                              ),
                              const SizedBox(height: 8),
                              AppTextField(
                                controller: _emailController,
                                hint: 'user@company.com',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              PrimaryButton(
                                title: 'Send Recovery Link',
                                icon: Icons.send_rounded,
                                isLoading: isLoading,
                                onPressed: _onResetPressed,
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
