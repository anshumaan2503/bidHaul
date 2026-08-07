import 'package:flutter/material.dart';

import '../../../dummy/dummy_platform_users.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/cards/platform_user_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';
import 'user_details_screen.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "User Management"),

          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: ListView.builder(
              itemCount: dummyPlatformUsers.length,
              itemBuilder: (_, index) {
                final user = dummyPlatformUsers[index];

                return PlatformUserCard(
                  user: user,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserDetailsScreen(user: user),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
