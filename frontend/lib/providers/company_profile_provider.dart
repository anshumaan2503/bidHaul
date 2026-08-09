import 'package:flutter/material.dart';
import '../models/company.dart';
import '../services/company_service.dart';

class CompanyProfileProvider with ChangeNotifier {
  final CompanyService _companyService;
  CompanyProfileModel? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  CompanyProfileProvider({CompanyService? companyService})
      : _companyService = companyService ?? CompanyService();

  CompanyProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasProfile => _profile != null;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _companyService.getProfile();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createProfile({
    required String companyName,
    String? address,
    String? gstNumber,
    String? licenseNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = CreateCompanyProfileRequest(
        companyName: companyName,
        address: address,
        gstNumber: gstNumber,
        licenseNumber: licenseNumber,
      );
      _profile = await _companyService.createProfile(request);
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

  Future<bool> updateProfile({
    required String companyName,
    String? address,
    String? gstNumber,
    String? licenseNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = UpdateCompanyProfileRequest(
        companyName: companyName,
        address: address,
        gstNumber: gstNumber,
        licenseNumber: licenseNumber,
      );
      _profile = await _companyService.updateProfile(request);
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

  Future<bool> submitKyc() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _companyService.submitKyc();
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
