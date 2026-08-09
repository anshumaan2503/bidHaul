import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bidhaul_logo.dart';
import '../../theme/app_page_transitions.dart';
import '../admin/dashboard/admin_dashboard_screen.dart';
import '../admin/login/admin_login_screen.dart';
import '../auth/role_selection/role_selection_screen.dart';
import '../company/navigation/company_navigation_screen.dart';
import '../transporter/dashboard/transporter_dashboard_screen.dart';

/// SplashScreen
///
/// Luminous, vibrant enterprise splash screen for BidHaul.
/// Features a live fluid sapphire-indigo gradient blend, vibrant ambient light orbs,
/// glowing ambient particle specks, the dead-centered BidHaul brand architecture,
/// an interactive "Get Started" call-to-action button, and a hidden developer/admin entry point.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgAnimationController;
  late final AnimationController _progressController;
  late final AnimationController _particleController;

  // Hidden Admin Entry State (10 logo taps within 5 seconds)
  int _logoTapCount = 0;
  DateTime? _firstTapTime;
  DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();

    // 1. Live Fluid Gradient Shift (6.0s smooth loop)
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat(reverse: true);

    // 2. Mobile Progress Bar Fill (2.0s loop)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // 3. Ambient Floating Particles (8.0s loop)
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat();
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    _progressController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _onGetStartedPressed() {
    if (!mounted) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isAuthenticated && authProvider.user != null) {
      final user = authProvider.user!;
      if (user.isCompany) {
        Navigator.pushReplacement(
          context,
          AppPageRoute.create(const CompanyNavigationScreen()),
        );
      } else if (user.isTransporter) {
        Navigator.pushReplacement(
          context,
          AppPageRoute.create(const TransporterDashboardScreen()),
        );
      } else if (user.isAdministrative) {
        Navigator.pushReplacement(
          context,
          AppPageRoute.create(const AdminDashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          AppPageRoute.create(const RoleSelectionScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        AppPageRoute.create(const RoleSelectionScreen()),
      );
    }
  }

  /// Hidden Admin gesture handler: 10 taps on the logo mark within 5 seconds navigates to AdminLoginScreen.
  void _onLogoTapped() {
    final now = DateTime.now();

    // Reset tap counter if > 5 seconds passed since first tap or between consecutive taps
    if (_firstTapTime == null ||
        now.difference(_firstTapTime!).inSeconds >= 5 ||
        (_lastTapTime != null && now.difference(_lastTapTime!).inSeconds >= 5)) {
      _logoTapCount = 1;
      _firstTapTime = now;
      _lastTapTime = now;
    } else {
      _logoTapCount++;
      _lastTapTime = now;
    }

    // Trigger Admin navigation on 10th consecutive tap
    if (_logoTapCount >= 10) {
      _logoTapCount = 0;
      _firstTapTime = null;
      _lastTapTime = null;

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        AppPageRoute.create(const AdminLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Luminous Fluid Espresso-Bronze Gradient Background
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
                      Color.lerp(
                        AppColors.bgStop1,
                        AppColors.bgStop2,
                        t,
                      )!,
                      Color.lerp(
                        AppColors.bgStop3,
                        AppColors.bgStop4,
                        t,
                      )!,
                      Color.lerp(
                        AppColors.bgStop5,
                        AppColors.bgStop6,
                        t,
                      )!,
                      Color.lerp(
                        AppColors.bgStop7,
                        AppColors.bgStop8,
                        t,
                      )!,
                    ],
                    stops: const [0.0, 0.35, 0.70, 1.0],
                  ),
                ),
              );
            },
          ),

          // 2. Top-Left Floating Gold Glow Orb
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              final t = _bgAnimationController.value;
              final offsetX = math.sin(t * math.pi) * 35.0;
              final offsetY = math.cos(t * math.pi) * 30.0;

              return Positioned(
                top: -100 + offsetY,
                left: -80 + offsetX,
                child: Container(
                  width: screenSize.width * 0.95,
                  height: screenSize.width * 0.95,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryCyan.withValues(alpha: 0.28),
                        AppColors.primaryBlue.withValues(alpha: 0.16),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          // 3. Center Ambient Backing Glow (Behind Emblem)
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              final t = _bgAnimationController.value;
              final pulseOpacity = 0.24 + (t * 0.12);

              return Center(
                child: Container(
                  width: screenSize.width * 0.85,
                  height: screenSize.width * 0.85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.glowCyan.withValues(alpha: pulseOpacity),
                        AppColors.primaryBlue.withValues(alpha: pulseOpacity * 0.5),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          // 4. Bottom-Right Floating Warm Bronze Glow Orb
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              final t = _bgAnimationController.value;
              final offsetX = math.cos(t * math.pi) * 40.0;
              final offsetY = math.sin(t * math.pi) * 35.0;

              return Positioned(
                bottom: -120 + offsetY,
                right: -90 + offsetX,
                child: Container(
                  width: screenSize.width * 1.0,
                  height: screenSize.width * 1.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryBlue.withValues(alpha: 0.28),
                        AppColors.primaryCyan.withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          // 5. Ambient Floating Light Particles Overlay
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return RepaintBoundary(
                child: CustomPaint(
                  size: screenSize,
                  painter: _SplashParticlePainter(
                    progress: _particleController.value,
                  ),
                ),
              );
            },
          ),

          // 6. Dead-Centered Brand Composition with Get Started Button
          Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: BidHaulLogo(
                  isVertical: true,
                  logoSize: 180,
                  showSubtitle: true,
                  showGetStarted: true,
                  onGetStartedPressed: _onGetStartedPressed,
                  onLogoTap: _onLogoTapped,
                  animateEntrance: true,
                ),
              ),
            ),
          ),

          // 7. Mobile Animated Progress Bar & Enterprise Footer
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Glowing Progress Bar Track
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    final progress = _progressController.value;
                    return Container(
                      width: 150,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppColors.buttonGradient,
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryCyan.withValues(alpha: 0.75),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Enterprise Badge Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryCyan,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryCyan.withValues(alpha: 0.8),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SECURE REVERSE AUCTION NETWORK',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.4,
                        color: AppColors.iceCyan.withValues(alpha: 0.80),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mobile-efficient CustomPainter drawing 18 glowing floating light particle specks.
class _SplashParticlePainter extends CustomPainter {
  final double progress;

  // Fixed deterministic seeds for high performance
  static final List<math.Point<double>> _basePoints = [
    const math.Point(0.12, 0.88),
    const math.Point(0.24, 0.68),
    const math.Point(0.38, 0.94),
    const math.Point(0.50, 0.78),
    const math.Point(0.65, 0.85),
    const math.Point(0.78, 0.72),
    const math.Point(0.88, 0.90),
    const math.Point(0.15, 0.38),
    const math.Point(0.28, 0.24),
    const math.Point(0.44, 0.48),
    const math.Point(0.58, 0.28),
    const math.Point(0.72, 0.42),
    const math.Point(0.85, 0.20),
    const math.Point(0.92, 0.48),
    const math.Point(0.35, 0.12),
    const math.Point(0.62, 0.15),
    const math.Point(0.08, 0.58),
    const math.Point(0.95, 0.65),
  ];

  _SplashParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < _basePoints.length; i++) {
      final p = _basePoints[i];
      final currentY = ((p.y - (progress * 0.45) + 1.0) % 1.0) * size.height;
      final currentX =
          (p.x * size.width) + (math.sin((progress * 2 * math.pi) + i) * 14);

      final alpha =
          (math.sin((progress * 2 * math.pi) + (i * 0.5)) * 0.3 + 0.45).clamp(
            0.15,
            0.75,
          );
      final radius = (i % 2 == 0) ? 1.8 : 2.5;

      final paint = Paint()
        ..color = (i % 3 == 0)
            ? AppColors.primaryCyan.withValues(alpha: alpha)
            : AppColors.primaryBlue.withValues(alpha: alpha * 0.85)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

      canvas.drawCircle(Offset(currentX, currentY), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SplashParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
