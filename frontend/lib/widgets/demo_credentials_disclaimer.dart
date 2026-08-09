import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// DemoCredentialsDisclaimer
/// Displays demo login credentials directly on the login screen for evaluator convenience.
class DemoCredentialsDisclaimer extends StatelessWidget {
  final String role;
  final Function(String email, String password)? onQuickFill;

  const DemoCredentialsDisclaimer({
    super.key,
    required this.role,
    this.onQuickFill,
  });

  @override
  Widget build(BuildContext context) {
    final isCompany = role.toLowerCase() == 'company';
    final isAdmin = role.toLowerCase() == 'admin';

    String demoEmail = 'test@company.com';
    String roleLabel = 'Company Shipper';
    if (isAdmin) {
      demoEmail = 'superadmin@bidhaul.com';
      roleLabel = 'Super Admin';
    } else if (!isCompany) {
      demoEmail = 'transporter@bidhaul.com';
      roleLabel = 'Fleet Transporter';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryCyan.withValues(alpha: 0.08),
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: AppColors.primaryCyan.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.key_rounded,
            color: AppColors.primaryCyan,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Demo ($roleLabel): $demoEmail / password123',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.iceCyan,
              ),
            ),
          ),
          if (onQuickFill != null)
            GestureDetector(
              onTap: () => onQuickFill!(demoEmail, 'password123'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryCyan.withValues(alpha: 0.2),
                  borderRadius: AppRadius.full,
                ),
                child: const Text(
                  'Auto-fill',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryCyan,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
