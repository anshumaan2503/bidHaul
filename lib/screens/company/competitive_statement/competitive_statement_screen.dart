import 'package:flutter/material.dart';

import '../../../dummy/dummy_competitive_statement.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/cards/competitive_statement_card.dart';
import '../winner_finalization/winner_finalization_screen.dart';

class CompetitiveStatementScreen extends StatelessWidget {
  const CompetitiveStatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkMidnight,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.darkFluidGradient,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Competitive Statement",
                          style: AppTypography.displayHero(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Final comparison after negotiation",
                    style: AppTypography.bodySecondary(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dummyCompetitiveStatement.length,
                      itemBuilder: (context, index) {
                        return CompetitiveStatementCard(
                          bid: dummyCompetitiveStatement[index],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    title: "Finalize Winner",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WinnerFinalizationScreen(),
                        ),
                      );
                    },
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
