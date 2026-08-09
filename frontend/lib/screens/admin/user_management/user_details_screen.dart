import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/platform_user.dart';
import '../../../providers/admin_governance_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';
import '../../../widgets/common/info_row.dart';

class UserDetailsScreen extends StatefulWidget {
  final PlatformUser user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late UserStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.user.status;
  }

  Future<void> _handleToggleStatus(AdminGovernanceProvider govProvider) async {
    final isSuspending = _currentStatus == UserStatus.active;
    final actionName = isSuspending ? "Suspend" : "Activate";

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkMidnight,
        title: Text("$actionName User", style: AppTypography.h2()),
        content: Text(
          "Are you sure you want to $actionName user '${widget.user.name}' (ID: ${widget.user.userId})?",
          style: AppTypography.bodyPrimary(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSuspending ? Colors.redAccent : AppColors.primaryCyan,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(actionName, style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      bool success;
      if (isSuspending) {
        success = await govProvider.suspendUser(widget.user.userId);
      } else {
        success = await govProvider.activateUser(widget.user.userId);
      }

      if (success && mounted) {
        setState(() {
          _currentStatus = isSuspending ? UserStatus.suspended : UserStatus.active;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("User successfully ${isSuspending ? 'suspended' : 'activated'}!"),
            backgroundColor: isSuspending ? Colors.orange : AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to $actionName user: ${govProvider.actionError ?? e.toString()}"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final govProvider = Provider.of<AdminGovernanceProvider>(context);
    final isActive = _currentStatus == UserStatus.active;

    return BaseScreenLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonAppBar(
            title: widget.user.name,
            titleStyle: AppTypography.h2(),
          ),

          const SizedBox(height: AppSpacing.xl),

          InfoRow(title: "User ID", value: widget.user.userId, labelWidth: 110),
          InfoRow(title: "Type", value: widget.user.type.name.toUpperCase(), labelWidth: 110),
          InfoRow(title: "Email", value: widget.user.email, labelWidth: 110),
          InfoRow(title: "Phone", value: widget.user.phone, labelWidth: 110),
          InfoRow(
            title: "Status",
            value: _currentStatus.name.toUpperCase(),
            labelWidth: 110,
          ),

          const Spacer(),

          if (govProvider.isActioningUser)
            const Center(child: CircularProgressIndicator())
          else
            PrimaryButton(
              title: isActive ? "Suspend User" : "Activate User",
              onPressed: () => _handleToggleStatus(govProvider),
            ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
