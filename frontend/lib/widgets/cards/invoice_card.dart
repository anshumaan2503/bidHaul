import 'package:flutter/material.dart';

import '../../models/invoice.dart';
import '../../screens/shared/invoice_details_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../common/app_status_badge.dart';
import '../common/base_glass_card.dart';
import '../common/info_row.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoiceCard({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final displayDate = invoice.date != null
        ? (invoice.date!.length >= 10 ? invoice.date!.substring(0, 10) : invoice.date!)
        : 'N/A';

    return GestureDetector(
      onTap: () {
        if (invoice.id.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => InvoiceDetailsScreen(invoiceId: invoice.id),
            ),
          );
        }
      },
      child: BaseGlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.25),
                    borderRadius: AppRadius.md,
                    border: Border.all(
                      color: AppColors.glassBorderDark,
                    ),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: AppColors.primaryCyan,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoice.invoiceNo.isNotEmpty ? invoice.invoiceNo : invoice.id,
                        style: AppTypography.cardTitle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Issued: $displayDate",
                        style: AppTypography.bodySecondary(),
                      ),
                    ],
                  ),
                ),
                AppStatusBadge(status: invoice.status),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: AppRadius.md,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              child: Column(
                children: [
                  InfoRow(
                    title: "Total Amount",
                    value: "₹${invoice.amount.toStringAsFixed(0)}",
                    icon: Icons.payments_rounded,
                    valueStyle: AppTypography.priceText(color: AppColors.primaryCyan),
                  ),
                  InfoRow(
                    title: "Payment Status",
                    value: invoice.status.toUpperCase(),
                    icon: Icons.verified_rounded,
                    valueColor: AppColors.getStatusColor(invoice.status),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
