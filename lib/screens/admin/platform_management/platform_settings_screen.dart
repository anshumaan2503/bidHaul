import 'package:flutter/material.dart';

import '../../../dummy/dummy_platform_settings.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/cards/platform_setting_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';

class PlatformSettingsScreen extends StatelessWidget {
  const PlatformSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "Platform Settings"),

          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: ListView.builder(
              itemCount: dummyPlatformSettings.length,
              itemBuilder: (_, index) {
                return PlatformSettingCard(
                  setting: dummyPlatformSettings[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
