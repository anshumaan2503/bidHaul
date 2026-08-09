import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dummy/dummy_platform_settings.dart';
import '../../../providers/payment_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/platform_setting_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';

class PlatformSettingsScreen extends StatelessWidget {
  const PlatformSettingsScreen({super.key});

  void _confirmPaymentGatewayToggle(BuildContext context, PaymentProvider paymentProvider) {
    final isShutdown = paymentProvider.isGatewayShutdown;
    final actionText = isShutdown ? "TURN ON" : "SHUTDOWN";

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.glassSurfaceDark,
        title: Row(
          children: [
            Icon(
              isShutdown ? Icons.play_circle_fill : Icons.warning_amber_rounded,
              color: isShutdown ? Colors.greenAccent : Colors.redAccent,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "$actionText Gateway?",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          isShutdown
              ? "Are you sure you want to RE-ACTIVATE the platform payment gateway? Users will be able to make subscription and invoice checkout payments."
              : "Are you sure you want to SHUT DOWN the platform payment gateway? All checkout and payment operations across the app will be temporarily suspended for maintenance.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isShutdown ? Colors.green : Colors.red,
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              paymentProvider.toggleGatewayShutdown();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: isShutdown ? Colors.green : Colors.red,
                  content: Text(
                    isShutdown
                        ? "✅ Payment Gateway is now ACTIVE globally."
                        : "🚨 Payment Gateway has been SHUT DOWN by Super Admin.",
                  ),
                ),
              );
            },
            child: Text(actionText, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "Platform Settings"),

          const SizedBox(height: AppSpacing.lg),

          Consumer<PaymentProvider>(
            builder: (context, paymentProvider, _) {
              final isShutdown = paymentProvider.isGatewayShutdown;
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isShutdown
                      ? Colors.red.withValues(alpha: 0.15)
                      : Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isShutdown ? Colors.redAccent : Colors.greenAccent,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isShutdown ? Icons.power_settings_new : Icons.payment,
                              color: isShutdown ? Colors.redAccent : Colors.greenAccent,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Payment Gateway",
                              style: AppTypography.h3().copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isShutdown
                                ? Colors.red.withValues(alpha: 0.3)
                                : Colors.green.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isShutdown ? Colors.redAccent : Colors.greenAccent,
                            ),
                          ),
                          child: Text(
                            isShutdown ? "SHUTDOWN" : "ONLINE",
                            style: TextStyle(
                              color: isShutdown ? Colors.redAccent : Colors.greenAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isShutdown
                          ? "Transactions are paused for maintenance."
                          : "Razorpay payment gateway is active.",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isShutdown ? Colors.green : Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: Icon(
                          isShutdown ? Icons.play_arrow : Icons.power_settings_new,
                          size: 16,
                        ),
                        label: Text(
                          isShutdown ? "TURN ON GATEWAY" : "SHUTDOWN GATEWAY",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        onPressed: () => _confirmPaymentGatewayToggle(context, paymentProvider),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

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
