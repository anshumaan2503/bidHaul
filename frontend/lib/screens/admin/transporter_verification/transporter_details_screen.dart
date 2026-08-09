import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/transporter.dart';
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

class TransporterDetailsScreen extends StatefulWidget {
  final TransporterProfileModel transporter;

  const TransporterDetailsScreen({super.key, required this.transporter});

  @override
  State<TransporterDetailsScreen> createState() => _TransporterDetailsScreenState();
}

class _TransporterDetailsScreenState extends State<TransporterDetailsScreen> {
  final _rejectionController = TextEditingController();

  @override
  void dispose() {
    _rejectionController.dispose();
    super.dispose();
  }

  Future<void> _onApprovePressed() async {
    final provider = Provider.of<AdminKycProvider>(context, listen: false);
    final success = await provider.approveTransporterKyc(widget.transporter.id);

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Transporter KYC Approved Successfully"),
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
              hint: "Specify permit invalidity or vehicle specification discrepancy...",
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
              final success = await provider.rejectTransporterKyc(widget.transporter.id, reason);

              if (!mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Transporter KYC Rejected"),
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
                  title: widget.transporter.transporterName,
                  titleStyle: AppTypography.h2(),
                ),
              ),
              AppStatusBadge(status: widget.transporter.verificationStatus),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          InfoRow(title: "Owner", value: widget.transporter.ownerName ?? 'N/A'),
          InfoRow(title: "Email", value: widget.transporter.email ?? 'N/A'),
          InfoRow(title: "Phone", value: widget.transporter.phone ?? 'N/A'),
          InfoRow(title: "Vehicle", value: widget.transporter.vehicleType ?? 'N/A'),
          InfoRow(title: "Fleet Size", value: widget.transporter.fleetSize?.toString() ?? 'N/A'),
          InfoRow(title: "License", value: widget.transporter.licenseNumber ?? 'N/A'),
          InfoRow(title: "Completed Deliveries", value: widget.transporter.completedDeliveries.toString()),
          InfoRow(title: "Rating", value: widget.transporter.rating.toStringAsFixed(1)),
          InfoRow(title: "Registered", value: widget.transporter.registrationDate),

          if (widget.transporter.rejectionReason != null && widget.transporter.rejectionReason!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            InfoRow(
              title: "Rejection Reason",
              value: widget.transporter.rejectionReason!,
              valueColor: AppColors.dangerRed,
            ),
          ],

          const Spacer(),

          if (widget.transporter.isSubmitted || widget.transporter.isPending) ...[
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
