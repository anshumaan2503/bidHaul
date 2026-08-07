import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/role_card.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../login/login_screen.dart';

/// RoleSelectionScreen
///
/// Luminous enterprise role selection screen for BidHaul.
/// Features a dark sapphire fluid gradient background, ambient light orbs,
/// glassmorphic selection cards, and a glowing CTA proceed button.
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
      duration: const Duration(milliseconds: 6000),
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

    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Fluid Dark Sapphire Navy Background Gradient
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              final t = _bgAnimationController.value;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1.2 + (t * 0.5), -1.0),
                    end: Alignment(1.2 - (t * 0.5), 1.0),
                    colors: [
                      Color.lerp(AppColors.bgStop1, AppColors.bgStop2, t)!,
                      Color.lerp(AppColors.bgStop3, AppColors.bgStop4, t)!,
                      Color.lerp(AppColors.bgStop5, AppColors.bgStop6, t)!,
                      Color.lerp(AppColors.bgStop7, AppColors.bgStop8, t)!,
                    ],
                    stops: const [0.0, 0.35, 0.70, 1.0],
                  ),
                ),
              );
            },
          ),

          // 2. Ambient Top-Left Cyan Glow Orb
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              final t = _bgAnimationController.value;
              final offsetY = math.sin(t * math.pi) * 20.0;

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
                        AppColors.primaryCyan.withValues(alpha: 0.28),
                        AppColors.primaryBlue.withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          // 3. Main Screen Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),

                // Back Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      tooltip: 'Back',
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Text(
                    'WELCOME TO',
                    style: AppTypography.subtitle(color: AppColors.iceCyan),
                  ),
                ),

                const SizedBox(height: AppSpacing.xs),

                // Hero Brand Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Text(
                    'BidHaul',
                    style: AppTypography.displayHero(color: Colors.white),
                  ),
                ),

                const SizedBox(height: AppSpacing.xs),

                // Subtext
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Text(
                    'Choose how you want to continue',
                    style: AppTypography.bodyPrimary(
                      color: Colors.white.withValues(alpha: 0.70),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Role Option 1: Company
                RoleCard(
                  title: 'Company',
                  subtitle:
                      'Post transport requirements, create reverse auctions, and manage freight tenders.',
                  icon: Icons.business_rounded,
                  selected: selectedRole == 'company',
                  onTap: () {
                    setState(() {
                      selectedRole = 'company';
                    });
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                // Role Option 2: Transporter
                RoleCard(
                  title: 'Transporter',
                  subtitle:
                      'Browse available loads, place competitive reverse bids, and win contracts.',
                  icon: Icons.local_shipping_rounded,
                  selected: selectedRole == 'transporter',
                  onTap: () {
                    setState(() {
                      selectedRole = 'transporter';
                    });
                  },
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: PrimaryButton(
                    title: 'Continue',
                    enabled: selectedRole != null,
                    onPressed: () {
                      if (selectedRole == null) return;
                      if (!mounted) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoginScreen(role: selectedRole!),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
