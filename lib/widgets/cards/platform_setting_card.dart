import 'package:flutter/material.dart';

import '../../models/platform_setting.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../common/base_glass_card.dart';

class PlatformSettingCard extends StatelessWidget {
  final PlatformSetting setting;

  const PlatformSettingCard({super.key, required this.setting});

  @override
  Widget build(BuildContext context) {
    return BaseGlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(setting.title, style: AppTypography.bodyPrimary()),
          Text(
            setting.value,
            style: AppTypography.h3(color: AppColors.primaryCyan),
          ),
        ],
      ),
    );
  }
}
