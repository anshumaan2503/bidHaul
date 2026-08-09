import 'package:flutter/material.dart';
import '../models/company.dart';
import '../models/transporter.dart';
import '../services/admin_kyc_service.dart';

class AdminKycProvider with ChangeNotifier {
  final AdminKycService _adminKycService;

  List<CompanyProfileModel> _companyApplications = [];
  List<TransporterProfileModel> _transporterApplications = [];
  bool _isLoading = false;
  String? _errorMessage;

  AdminKycProvider({AdminKycService? adminKycService})
      : _adminKycService = adminKycService ?? AdminKycService();

  List<CompanyProfileModel> get companyApplications => _companyApplications;
  List<TransporterProfileModel> get transporterApplications => _transporterApplications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchCompanyApplications({String? status}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _companyApplications = await _adminKycService.getCompanyApplications(status: status);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> approveCompanyKyc(String profileId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _adminKycService.approveCompanyKyc(profileId);
      final index = _companyApplications.indexWhere((item) => item.id == profileId);
      if (index != -1) {
        _companyApplications[index] = updated;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> rejectCompanyKyc(String profileId, String rejectionReason) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _adminKycService.rejectCompanyKyc(profileId, rejectionReason);
      final index = _companyApplications.indexWhere((item) => item.id == profileId);
      if (index != -1) {
        _companyApplications[index] = updated;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchTransporterApplications({String? status}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transporterApplications = await _adminKycService.getTransporterApplications(status: status);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> approveTransporterKyc(String profileId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _adminKycService.approveTransporterKyc(profileId);
      final index = _transporterApplications.indexWhere((item) => item.id == profileId);
      if (index != -1) {
        _transporterApplications[index] = updated;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> rejectTransporterKyc(String profileId, String rejectionReason) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _adminKycService.rejectTransporterKyc(profileId, rejectionReason);
      final index = _transporterApplications.indexWhere((item) => item.id == profileId);
      if (index != -1) {
        _transporterApplications[index] = updated;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
