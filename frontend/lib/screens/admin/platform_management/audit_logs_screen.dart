import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/audit_log_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/audit_log_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  final TextEditingController _actorController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isFiltering = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuditLogProvider>(context, listen: false).fetchAuditLogs(refresh: true);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _actorController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      Provider.of<AuditLogProvider>(context, listen: false).loadNextPage();
    }
  }

  void _applyActorFilter() {
    final actorId = _actorController.text.trim();
    Provider.of<AuditLogProvider>(context, listen: false).fetchAuditLogs(
      refresh: true,
      actorUserId: actorId.isEmpty ? null : actorId,
    );
  }

  void _clearFilter() {
    _actorController.clear();
    setState(() => _isFiltering = false);
    Provider.of<AuditLogProvider>(context, listen: false).fetchAuditLogs(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "Audit Logs"),
          const SizedBox(height: AppSpacing.md),

          // Filter Row
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.glassSurfaceDark,
              borderRadius: AppRadius.md,
              border: Border.all(color: AppColors.glassBorderDark),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _actorController,
                    style: AppTypography.bodyPrimary(),
                    decoration: InputDecoration(
                      hintText: "Filter by Actor User ID...",
                      hintStyle: AppTypography.bodySecondary(),
                      prefixIcon: const Icon(Icons.filter_list, color: AppColors.primaryCyan, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onSubmitted: (_) {
                      setState(() => _isFiltering = _actorController.text.trim().isNotEmpty);
                      _applyActorFilter();
                    },
                  ),
                ),
                if (_isFiltering || _actorController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white70),
                    onPressed: _clearFilter,
                  ),
                IconButton(
                  icon: const Icon(Icons.search, color: AppColors.primaryCyan),
                  onPressed: () {
                    setState(() => _isFiltering = _actorController.text.trim().isNotEmpty);
                    _applyActorFilter();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: Consumer<AuditLogProvider>(
              builder: (context, auditProvider, child) {
                if (auditProvider.isLoading && auditProvider.auditLogs.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (auditProvider.errorMessage != null && auditProvider.auditLogs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            "Failed to load audit logs",
                            style: AppTypography.h2(),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            auditProvider.errorMessage!,
                            style: AppTypography.bodySecondary(),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          ElevatedButton(
                            onPressed: () => auditProvider.fetchAuditLogs(refresh: true),
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (auditProvider.auditLogs.isEmpty) {
                  return Center(
                    child: Text(
                      "No audit log records found.",
                      style: AppTypography.bodySecondary(),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => auditProvider.fetchAuditLogs(refresh: true),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: auditProvider.auditLogs.length + (auditProvider.hasMore ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (index == auditProvider.auditLogs.length) {
                        return const Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final log = auditProvider.auditLogs[index];
                      return AuditLogCard(log: log);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
