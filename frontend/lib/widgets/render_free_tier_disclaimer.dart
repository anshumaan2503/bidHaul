import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// RenderFreeTierDisclaimer
/// A sleek, compact notice informing users that the initial request
/// may take up to 30-50s while the Render free-tier backend wakes from sleep.
class RenderFreeTierDisclaimer extends StatelessWidget {
  const RenderFreeTierDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1810).withValues(alpha: 0.85), // Warm dark amber accent
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.35), // Metallic gold border
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.hourglass_top_rounded,
            color: Color(0xFFF39C12),
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.35,
                  color: Color(0xFFE2E8F0),
                ),
                children: const [
                  TextSpan(
                    text: 'Server Cold-Start Notice: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF39C12),
                    ),
                  ),
                  TextSpan(
                    text:
                        'The backend is hosted on Render free tier. Initial login or request may take 30–50s to wake the server. Subsequent actions will be immediate.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
