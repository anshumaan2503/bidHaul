import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/company.dart';
import '../../../providers/admin_kyc_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/common/app_status_badge.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';
import '../../../widgets/common/info_row.dart';
import '../../../widgets/inputs/app_text_field.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final CompanyProfileModel company;

  const CompanyDetailsScreen({
    super.key,
    required this.company,
  });

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  final _rejectionController = TextEditingController();

  @override
  void dispose() {
    _rejectionController.dispose();
    super.dispose();
  }

  Future<void> _onApprovePressed() async {
    final provider = Provider.of<AdminKycProvider>(context, listen: false);
    final success = await provider.approveCompanyKyc(widget.company.id);

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Company KYC Approved Successfully"),
          backgroundColor: AppColors.successGreen,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? "Approval failed"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showRejectDialog() {
    _rejectionController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.glassSurfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lg,
          side: BorderSide(color: AppColors.glassBorderDark),
        ),
        title: Text("Reject KYC Application", style: AppTypography.h2()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "REJECTION REASON (REQUIRED)",
              style: AppTypography.microBadge(color: AppColors.iceCyan),
            ),
            const SizedBox(height: 8),
            AppTextField(
              controller: _rejectionController,
              hint: "Specify document invalidity or discrepancy...",
              prefixIcon: Icons.description_outlined,
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: AppTypography.bodySecondary()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.dangerRed),
            onPressed: () async {
              final reason = _rejectionController.text.trim();
              if (reason.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Rejection reason is required")),
                );
                return;
              }
              Navigator.pop(ctx);
              final provider = Provider.of<AdminKycProvider>(context, listen: false);
              final success = await provider.rejectCompanyKyc(widget.company.id, reason);

              if (!mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Company KYC Rejected"),
                    backgroundColor: AppColors.dangerRed,
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(provider.errorMessage ?? "Rejection failed"),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text("Confirm Rejection"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminKycProvider>(context);

    return BaseScreenLayout(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CommonAppBar(
                  title: widget.company.companyName,
                  titleStyle: AppTypography.h2(),
                ),
              ),
              AppStatusBadge(status: widget.company.verificationStatus),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          InfoRow(title: "Owner", value: widget.company.ownerName ?? 'N/A'),
          InfoRow(title: "Email", value: widget.company.email ?? 'N/A'),
          InfoRow(title: "Phone", value: widget.company.phone ?? 'N/A'),
          InfoRow(title: "GSTIN", value: widget.company.gstNumber ?? 'N/A'),
          InfoRow(title: "License", value: widget.company.licenseNumber ?? 'N/A'),
          InfoRow(title: "Address", value: widget.company.address ?? 'N/A'),
          InfoRow(title: "Registered", value: widget.company.registrationDate),

          if (widget.company.rejectionReason != null && widget.company.rejectionReason!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            InfoRow(
              title: "Rejection Reason",
              value: widget.company.rejectionReason!,
              valueColor: AppColors.dangerRed,
            ),
          ],

          const Spacer(),

          if (widget.company.isSubmitted || widget.company.isPending) ...[
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    title: "Approve",
                    icon: Icons.check_circle_outline,
                    isLoading: provider.isLoading,
                    onPressed: _onApprovePressed,
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                Expanded(
                  child: PrimaryButton(
                    title: "Reject",
                    icon: Icons.cancel_outlined,
                    isLoading: provider.isLoading,
                    onPressed: _showRejectDialog,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}