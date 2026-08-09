import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/platform_user.dart';
import '../../../providers/admin_kyc_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/cards/platform_user_card.dart';
import '../../../widgets/common/base_screen_layout.dart';
import '../../../widgets/common/common_app_bar.dart';
import 'user_details_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final kycProvider = Provider.of<AdminKycProvider>(context, listen: false);
      kycProvider.fetchCompanyApplications();
      kycProvider.fetchTransporterApplications();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PlatformUser> _buildUserList(AdminKycProvider kycProvider) {
    final List<PlatformUser> users = [];

    for (final c in kycProvider.companyApplications) {
      if (c.userId.isNotEmpty) {
        users.add(
          PlatformUser(
            userId: c.userId,
            name: "${c.ownerName} (${c.companyName})",
            email: c.email ?? "",
            phone: c.phone ?? "",
            type: UserType.company,
            status: UserStatus.active,
          ),
        );
      }
    }

    for (final t in kycProvider.transporterApplications) {
      if (t.userId.isNotEmpty) {
        users.add(
          PlatformUser(
            userId: t.userId,
            name: "${t.ownerName} (${t.companyName})",
            email: t.email ?? "",
            phone: t.phone ?? "",
            type: UserType.transporter,
            status: UserStatus.active,
          ),
        );
      }
    }

    if (_searchQuery.trim().isEmpty) {
      return users;
    }

    final query = _searchQuery.trim().toLowerCase();
    return users.where((u) {
      return u.name.toLowerCase().contains(query) ||
          u.email.toLowerCase().contains(query) ||
          u.userId.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      child: Column(
        children: [
          const CommonAppBar(title: "User Management"),
          const SizedBox(height: AppSpacing.md),

          // Search Field for User ID or Name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.glassSurfaceDark,
              borderRadius: AppRadius.md,
              border: Border.all(color: AppColors.glassBorderDark),
            ),
            child: TextField(
              controller: _searchController,
              style: AppTypography.bodyPrimary(),
              decoration: InputDecoration(
                hintText: "Search user by Name, Email, or User ID...",
                hintStyle: AppTypography.bodySecondary(),
                icon: const Icon(Icons.search, color: AppColors.primaryCyan),
                border: InputBorder.none,
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.iceCyan),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                setState(() => _searchQuery = val);
              },
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: Consumer<AdminKycProvider>(
              builder: (context, kycProvider, child) {
                if (kycProvider.isLoading && kycProvider.companyApplications.isEmpty && kycProvider.transporterApplications.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final userList = _buildUserList(kycProvider);

                if (userList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _searchQuery.isNotEmpty
                              ? "No users found matching '$_searchQuery'"
                              : "No platform users found",
                          style: AppTypography.bodySecondary(),
                        ),
                        if (_searchQuery.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          ElevatedButton.icon(
                            onPressed: () {
                              final queryUser = PlatformUser(
                                userId: _searchQuery.trim(),
                                name: "User (${_searchQuery.trim().substring(0, _searchQuery.trim().length > 8 ? 8 : _searchQuery.trim().length)})",
                                email: "user@bidhaul.com",
                                phone: "N/A",
                                type: UserType.company,
                                status: UserStatus.active,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UserDetailsScreen(user: queryUser),
                                ),
                              );
                            },
                            icon: const Icon(Icons.person),
                            label: const Text("Manage direct User ID"),
                          ),
                        ]
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await kycProvider.fetchCompanyApplications();
                    await kycProvider.fetchTransporterApplications();
                  },
                  child: ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (_, index) {
                      final user = userList[index];

                      return PlatformUserCard(
                        user: user,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserDetailsScreen(user: user),
                            ),
                          );
                        },
                      );
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
