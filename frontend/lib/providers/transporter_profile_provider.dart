import 'package:flutter/material.dart';
import '../models/transporter.dart';
import '../services/transporter_service.dart';

class TransporterProfileProvider with ChangeNotifier {
  final TransporterService _transporterService;
  TransporterProfileModel? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  TransporterProfileProvider({TransporterService? transporterService})
      : _transporterService = transporterService ?? TransporterService();

  TransporterProfileModel? get profile => _profile;
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
      _profile = await _transporterService.getProfile();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createProfile({
    required String companyName,
    required String vehicleType,
    required int fleetSize,
    String? licenseNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = CreateTransporterProfileRequest(
        companyName: companyName,
        vehicleType: vehicleType,
        fleetSize: fleetSize,
        licenseNumber: licenseNumber,
      );
      _profile = await _transporterService.createProfile(request);
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
    required String vehicleType,
    required int fleetSize,
    String? licenseNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = UpdateTransporterProfileRequest(
        companyName: companyName,
        vehicleType: vehicleType,
        fleetSize: fleetSize,
        licenseNumber: licenseNumber,
      );
      _profile = await _transporterService.updateProfile(request);
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
      _profile = await _transporterService.submitKyc();
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
