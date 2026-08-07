import 'package:flutter/material.dart';

import '../../../dummy/dummy_admin_accounts.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/cards/admin_account_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';

class AdminManagementScreen extends StatelessWidget {
  const AdminManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "Admin Management"),

          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: ListView.builder(
              itemCount: dummyAdminAccounts.length,
              itemBuilder: (_, index) {
                return AdminAccountCard(
                  admin: dummyAdminAccounts[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
