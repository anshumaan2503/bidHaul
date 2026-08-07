import 'package:flutter/material.dart';

import '../../models/invoice.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class InvoiceCard extends StatelessWidget {
  final Invoice invoice;

  const InvoiceCard({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.glassSurfaceDark,
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.glassBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(invoice.invoiceNo, style: AppTypography.h2()),

          const SizedBox(height: AppSpacing.md),

          _row("Date", invoice.date),
          _row("Amount", "₹${invoice.amount.toStringAsFixed(0)}"),
          _row("Status", invoice.status),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(title, style: AppTypography.bodySecondary()),
          ),
          Expanded(child: Text(value, style: AppTypography.bodyPrimary())),
        ],
      ),
    );
  }
}
