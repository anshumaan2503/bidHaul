import 'package:flutter/material.dart';

import '../../../models/platform_user.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';
import '../../../widgets/common/info_row.dart';

class UserDetailsScreen extends StatelessWidget {
  final PlatformUser user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isActive = user.status == UserStatus.active;

    return BaseScreenLayout(
      child: Column(
        children: [
          CommonAppBar(
            title: user.name,
            titleStyle: AppTypography.h2(),
          ),

          const SizedBox(height: AppSpacing.xl),

          InfoRow(title: "Type", value: user.type.name, labelWidth: 110),
          InfoRow(title: "Email", value: user.email, labelWidth: 110),
          InfoRow(title: "Phone", value: user.phone, labelWidth: 110),
          InfoRow(title: "Status", value: user.status.name, labelWidth: 110),

          const Spacer(),

          PrimaryButton(
            title: isActive ? "Suspend User" : "Activate User",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isActive ? "User Suspended" : "User Activated",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
