import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/cards/role_card.dart';
import '../../../theme/app_page_transitions.dart';
import '../../splash/splash_screen.dart';
import '../login/login_screen.dart';

/// RoleSelectionScreen
///
/// Ultra-modern, executive role selection portal for BidHaul.
/// Features dark espresso fluid background gradient, ambient gold lighting,
/// glassmorphic selection cards, and responsive CTA button.
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  String? selectedRole;
  late final AnimationController _bgAnimationController;

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
    _bgAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushReplacement(
          context,
          AppPageRoute.create(const SplashScreen()),
        );
      },
      child: Scaffold(
      backgroundColor: AppColors.darkMidnight,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Fluid Dark Espresso Background Gradient
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
                      Color.lerp(AppColors.bgStop1, AppColors.bgStop3, t)!,
                      Color.lerp(AppColors.bgStop2, AppColors.bgStop5, t)!,
                      Color.lerp(AppColors.bgStop4, AppColors.bgStop6, t)!,
                      Color.lerp(AppColors.bgStop7, AppColors.bgStop8, t)!,
                    ],
                    stops: const [0.0, 0.35, 0.70, 1.0],
                  ),
                ),
              );
            },
          ),

          // 2. Top-Right Ambient Warm Gold Light Orb
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              final t = _bgAnimationController.value;
              final offsetY = math.sin(t * math.pi) * 15.0;

              return Positioned(
                top: -60 + offsetY,
                right: -70,
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

          // 3. Bottom-Left Ambient Bronze Glow Orb
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              final t = _bgAnimationController.value;
              final offsetX = math.cos(t * math.pi) * 15.0;

              return Positioned(
                bottom: -100 + offsetX,
                left: -80,
                child: Container(
                  width: screenSize.width * 0.75,
                  height: screenSize.width * 0.75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryBlue.withValues(alpha: 0.20),
                        AppColors.glassSurfaceDark.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          // 4. Main Scrollable Screen Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),

                // Top Navigation Bar (Back Glass Button)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Row(
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
                            width: 1,
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
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushReplacement(
                                context,
                                AppPageRoute.create(const SplashScreen()),
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.primaryCyan,
                            size: 18,
                          ),
                          tooltip: 'Back',
                        ),
                      ),

                      // Platform Micro Badge
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
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryCyan,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'BIDHAUL PORTAL',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: AppColors.primaryCyan,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Header Typography Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SELECT YOUR ROLE',
                        style: AppTypography.microBadge(
                          color: AppColors.iceCyan,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Choose Portal Access',
                        style: AppTypography.displayHero(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select how you wish to operate within the BidHaul reverse auction freight network.',
                        style: AppTypography.bodySecondary(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Role Options Section
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Role Option 1: Company
                        RoleCard(
                          title: 'Company / Shipper',
                          tag: 'FREIGHT OWNER',
                          subtitle:
                              'Create reverse auctions, post load tenders, evaluate bids, and streamline cargo logistics.',
                          icon: Icons.business_center_rounded,
                          features: const [
                            'Instant Auction Posting',
                            'Verified Transporters',
                            'Automated Settlement',
                          ],
                          selected: selectedRole == 'company',
                          onTap: () {
                            setState(() {
                              selectedRole = 'company';
                            });
                          },
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Role Option 2: Transporter
                        RoleCard(
                          title: 'Transporter / Carrier',
                          tag: 'FLEET OPERATOR',
                          subtitle:
                              'Discover active freight tenders, submit real-time competitive reverse bids, and win contracts.',
                          icon: Icons.local_shipping_rounded,
                          features: const [
                            'Live Load Board',
                            'Real-Time Bidding',
                            'Fast Payouts',
                          ],
                          selected: selectedRole == 'transporter',
                          onTap: () {
                            setState(() {
                              selectedRole = 'transporter';
                            });
                          },
                        ),

                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Footer
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.glassSurfaceDark.withValues(alpha: 0.9),
                    border: Border(
                      top: BorderSide(
                        color: AppColors.glassBorderDark,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Role Selection Hint / Feedback
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: selectedRole != null
                            ? Padding(
                                key: ValueKey(selectedRole),
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      size: 16,
                                      color: AppColors.primaryCyan,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Selected: ${selectedRole == 'company' ? 'Company (Shipper) Portal' : 'Transporter (Carrier) Portal'}',
                                      style: AppTypography.bodySecondary(
                                        color: AppColors.primaryCyan,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                key: const ValueKey('none'),
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  'Tap a card above to select your account type',
                                  style: AppTypography.bodySecondary(
                                    color: AppColors.iceCyan.withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                      ),

                      // Continue CTA Button
                      PrimaryButton(
                        title: 'Proceed to Portal',
                        icon: Icons.arrow_forward_rounded,
                        enabled: selectedRole != null,
                        onPressed: () {
                          if (selectedRole == null) return;
                          if (!mounted) return;

                          Navigator.push(
                            context,
                            AppPageRoute.create(
                              LoginScreen(role: selectedRole!),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
