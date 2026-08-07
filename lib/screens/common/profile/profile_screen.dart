import 'package:flutter/material.dart';

import '../../../dummy/dummy_profile_options.dart';
import '../../../dummy/dummy_user_profile.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/profile_option_card.dart';
import 'about_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'help_support_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_conditions_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "My Profile",
                          style: AppTypography.displayHero(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: AppColors.primaryBlue,
                    child: Icon(Icons.person, size: 45, color: Colors.white),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Text(dummyUserProfile.name, style: AppTypography.h2()),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    dummyUserProfile.email,
                    style: AppTypography.bodySecondary(),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    dummyUserProfile.role,
                    style: AppTypography.bodySecondary(
                      color: AppColors.primaryCyan,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  Expanded(
                    child: ListView.builder(
                      itemCount: dummyProfileOptions.length,
                      itemBuilder: (context, index) {
                        final option = dummyProfileOptions[index];

                        return ProfileOptionCard(
                          option: option,
                          onTap: () {
                            switch (option.routeName) {
                              case "edit_profile":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const EditProfileScreen(),
                                  ),
                                );
                                break;

                              case "change_password":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ChangePasswordScreen(),
                                  ),
                                );
                                break;

                              case "help_support":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HelpSupportScreen(),
                                  ),
                                );
                                break;

                              case "privacy_policy":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PrivacyPolicyScreen(),
                                  ),
                                );
                                break;

                              case "terms_conditions":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const TermsConditionsScreen(),
                                  ),
                                );
                                break;

                              case "about":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AboutScreen(),
                                  ),
                                );
                                break;

                              case "logout":
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                                break;
                            }
                          },
                        );
                      },
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
