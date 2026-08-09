import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/company_profile_provider.dart';
import '../../../providers/transporter_profile_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/common/app_status_badge.dart';
import '../../../widgets/inputs/app_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Common / Company controllers
  final _companyNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _gstController = TextEditingController();
  final _licenseController = TextEditingController();

  // Transporter specific controllers
  final _vehicleTypeController = TextEditingController();
  final _fleetSizeController = TextEditingController();

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _addressController.dispose();
    _gstController.dispose();
    _licenseController.dispose();
    _vehicleTypeController.dispose();
    _fleetSizeController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null && user.isCompany) {
      final provider = Provider.of<CompanyProfileProvider>(context, listen: false);
      await provider.fetchProfile();
      if (provider.profile != null) {
        final p = provider.profile!;
        _companyNameController.text = p.companyName;
        _addressController.text = p.address ?? '';
        _gstController.text = p.gstNumber ?? '';
        _licenseController.text = p.licenseNumber ?? '';
      }
    } else if (user != null && user.isTransporter) {
      final provider = Provider.of<TransporterProfileProvider>(context, listen: false);
      await provider.fetchProfile();
      if (provider.profile != null) {
        final p = provider.profile!;
        _companyNameController.text = p.companyName;
        _vehicleTypeController.text = p.vehicleType ?? '';
        _fleetSizeController.text = p.fleetSize?.toString() ?? '0';
        _licenseController.text = p.licenseNumber ?? '';
      }
    }
    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  Future<void> _onSaveProfilePressed() async {
    FocusScope.of(context).unfocus();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (_companyNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Company name is required'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    bool success = false;
    if (user != null && user.isCompany) {
      final provider = Provider.of<CompanyProfileProvider>(context, listen: false);
      if (provider.hasProfile) {
        success = await provider.updateProfile(
          companyName: _companyNameController.text.trim(),
          address: _addressController.text.trim(),
          gstNumber: _gstController.text.trim(),
          licenseNumber: _licenseController.text.trim(),
        );
      } else {
        success = await provider.createProfile(
          companyName: _companyNameController.text.trim(),
          address: _addressController.text.trim(),
          gstNumber: _gstController.text.trim(),
          licenseNumber: _licenseController.text.trim(),
        );
      }
    } else if (user != null && user.isTransporter) {
      final fleet = int.tryParse(_fleetSizeController.text.trim()) ?? 0;
      final provider = Provider.of<TransporterProfileProvider>(context, listen: false);
      if (provider.hasProfile) {
        success = await provider.updateProfile(
          companyName: _companyNameController.text.trim(),
          vehicleType: _vehicleTypeController.text.trim(),
          fleetSize: fleet,
          licenseNumber: _licenseController.text.trim(),
        );
      } else {
        success = await provider.createProfile(
          companyName: _companyNameController.text.trim(),
          vehicleType: _vehicleTypeController.text.trim(),
          fleetSize: fleet,
          licenseNumber: _licenseController.text.trim(),
        );
      }
    }

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    } else {
      final companyErr = Provider.of<CompanyProfileProvider>(context, listen: false).errorMessage;
      final transpErr = Provider.of<TransporterProfileProvider>(context, listen: false).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(companyErr ?? transpErr ?? 'Failed to save profile'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _onSubmitKycPressed() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    bool success = false;
    if (user != null && user.isCompany) {
      final provider = Provider.of<CompanyProfileProvider>(context, listen: false);
      success = await provider.submitKyc();
    } else if (user != null && user.isTransporter) {
      final provider = Provider.of<TransporterProfileProvider>(context, listen: false);
      success = await provider.submitKyc();
    }

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('KYC Application submitted for verification!'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    } else {
      final companyErr = Provider.of<CompanyProfileProvider>(context, listen: false).errorMessage;
      final transpErr = Provider.of<TransporterProfileProvider>(context, listen: false).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(companyErr ?? transpErr ?? 'Failed to submit KYC'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final isCompany = user?.isCompany ?? true;

    final companyProvider = Provider.of<CompanyProfileProvider>(context);
    final transporterProvider = Provider.of<TransporterProfileProvider>(context);

    final isLoading = companyProvider.isLoading || transporterProvider.isLoading;
    final kycStatus = isCompany
        ? (companyProvider.profile?.verificationStatus ?? 'PENDING')
        : (transporterProvider.profile?.verificationStatus ?? 'PENDING');
    final rejectionReason = isCompany
        ? companyProvider.profile?.rejectionReason
        : transporterProvider.profile?.rejectionReason;

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
            child: !_initialized
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryCyan),
                  )
                : SingleChildScrollView(
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
                            Expanded(
                              child: Text(
                                "Profile & KYC",
                                style: AppTypography.displayHero(),
                              ),
                            ),
                            AppStatusBadge(status: kycStatus),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // KYC Banner Card
                        _buildKycStatusBanner(kycStatus, rejectionReason, isLoading),

                        const SizedBox(height: AppSpacing.xl),

                        // Form Container
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.glassSurfaceDark.withValues(alpha: 0.85),
                            borderRadius: AppRadius.xl,
                            border: Border.all(color: AppColors.glassBorderDark),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isCompany ? 'COMPANY INFORMATION' : 'FLEET INFORMATION',
                                style: AppTypography.microBadge(color: AppColors.iceCyan),
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // Company Name
                              Text(
                                'LEGAL COMPANY NAME',
                                style: AppTypography.microBadge(color: AppColors.iceCyan),
                              ),
                              const SizedBox(height: 8),
                              AppTextField(
                                controller: _companyNameController,
                                hint: 'e.g. Acme Logistics',
                                prefixIcon: isCompany ? Icons.business_rounded : Icons.local_shipping_rounded,
                              ),

                              const SizedBox(height: AppSpacing.md),

                              if (isCompany) ...[
                                Text(
                                  'REGISTERED ADDRESS',
                                  style: AppTypography.microBadge(color: AppColors.iceCyan),
                                ),
                                const SizedBox(height: 8),
                                AppTextField(
                                  controller: _addressController,
                                  hint: 'Full street address, City, State, PIN',
                                  prefixIcon: Icons.location_on_outlined,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'GSTIN NUMBER',
                                  style: AppTypography.microBadge(color: AppColors.iceCyan),
                                ),
                                const SizedBox(height: 8),
                                AppTextField(
                                  controller: _gstController,
                                  hint: 'e.g. 07AAAAA0000A1Z5',
                                  prefixIcon: Icons.assignment_outlined,
                                ),
                              ] else ...[
                                Text(
                                  'PRIMARY VEHICLE TYPE',
                                  style: AppTypography.microBadge(color: AppColors.iceCyan),
                                ),
                                const SizedBox(height: 8),
                                AppTextField(
                                  controller: _vehicleTypeController,
                                  hint: 'e.g. 32ft Multi-Axle Container',
                                  prefixIcon: Icons.local_shipping_outlined,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'FLEET SIZE',
                                  style: AppTypography.microBadge(color: AppColors.iceCyan),
                                ),
                                const SizedBox(height: 8),
                                AppTextField(
                                  controller: _fleetSizeController,
                                  hint: 'Number of active trucks',
                                  prefixIcon: Icons.format_list_numbered_rounded,
                                  keyboardType: TextInputType.number,
                                ),
                              ],

                              const SizedBox(height: AppSpacing.md),

                              Text(
                                'OPERATING LICENSE / PERMIT NUMBER',
                                style: AppTypography.microBadge(color: AppColors.iceCyan),
                              ),
                              const SizedBox(height: 8),
                              AppTextField(
                                controller: _licenseController,
                                hint: 'e.g. LIC-99887766',
                                prefixIcon: Icons.verified_outlined,
                              ),

                              const SizedBox(height: AppSpacing.xl),

                              PrimaryButton(
                                title: "Save Profile Details",
                                icon: Icons.save_rounded,
                                isLoading: isLoading,
                                onPressed: _onSaveProfilePressed,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildKycStatusBanner(String status, String? reason, bool isLoading) {
    final upperStatus = status.toUpperCase();

    if (upperStatus == 'VERIFIED') {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.successGreen.withValues(alpha: 0.15),
          borderRadius: AppRadius.lg,
          border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_rounded, color: AppColors.successGreen, size: 28),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Verified Enterprise', style: AppTypography.h3(color: AppColors.successGreen)),
                  Text(
                    'Your business KYC documentation has been fully approved.',
                    style: AppTypography.bodySecondary(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (upperStatus == 'SUBMITTED') {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.warningAmber.withValues(alpha: 0.15),
          borderRadius: AppRadius.lg,
          border: Border.all(color: AppColors.warningAmber.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.hourglass_top_rounded, color: AppColors.warningAmber, size: 28),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KYC Verification Pending Review', style: AppTypography.h3(color: AppColors.warningAmber)),
                  Text(
                    'Your KYC application is currently being evaluated by platform administrators.',
                    style: AppTypography.bodySecondary(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (upperStatus == 'REJECTED') {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.dangerRed.withValues(alpha: 0.15),
          borderRadius: AppRadius.lg,
          border: Border.all(color: AppColors.dangerRed.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cancel_rounded, color: AppColors.dangerRed, size: 28),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('KYC Application Rejected', style: AppTypography.h3(color: AppColors.dangerRed)),
                      if (reason != null && reason.isNotEmpty)
                        Text('Reason: $reason', style: AppTypography.bodySecondary(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              title: "Resubmit KYC Verification",
              icon: Icons.send_rounded,
              isLoading: isLoading,
              onPressed: _onSubmitKycPressed,
            ),
          ],
        ),
      );
    }

    // Default: PENDING
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryCyan.withValues(alpha: 0.10),
        borderRadius: AppRadius.lg,
        border: Border.all(color: AppColors.primaryCyan.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.primaryCyan, size: 28),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Submit KYC for Verification', style: AppTypography.h3(color: AppColors.primaryCyan)),
                    Text(
                      'Ensure profile details are complete, then submit for official admin verification.',
                      style: AppTypography.bodySecondary(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            title: "Submit KYC Application",
            icon: Icons.send_rounded,
            isLoading: isLoading,
            onPressed: _onSubmitKycPressed,
          ),
        ],
      ),
    );
  }
}
