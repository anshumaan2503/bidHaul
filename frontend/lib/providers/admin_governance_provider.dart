import 'package:flutter/material.dart';
import '../models/admin_dashboard.dart';
import '../services/admin_governance_service.dart';

class AdminGovernanceProvider with ChangeNotifier {
  final AdminGovernanceService _service;

  AdminDashboardModel? _dashboard;
  bool _isLoadingDashboard = false;
  String? _dashboardError;

  bool _isActioningUser = false;
  String? _actionError;

  AdminGovernanceProvider({AdminGovernanceService? service})
      : _service = service ?? AdminGovernanceService();

  AdminDashboardModel? get dashboard => _dashboard;
  bool get isLoadingDashboard => _isLoadingDashboard;
  String? get dashboardError => _dashboardError;
  bool get isActioningUser => _isActioningUser;
  String? get actionError => _actionError;

  Future<void> fetchDashboard() async {
    _isLoadingDashboard = true;
    _dashboardError = null;
    notifyListeners();

    try {
      _dashboard = await _service.getDashboard();
    } catch (e) {
      _dashboardError = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingDashboard = false;
      notifyListeners();
    }
  }

  Future<bool> suspendUser(String userId) async {
    _isActioningUser = true;
    _actionError = null;
    notifyListeners();

    try {
      final success = await _service.suspendUser(userId);
      if (success) {
        await fetchDashboard();
      }
      return success;
    } catch (e) {
      _actionError = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isActioningUser = false;
      notifyListeners();
    }
  }

  Future<bool> activateUser(String userId) async {
    _isActioningUser = true;
    _actionError = null;
    notifyListeners();

    try {
      final success = await _service.activateUser(userId);
      if (success) {
        await fetchDashboard();
      }
      return success;
    } catch (e) {
      _actionError = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isActioningUser = false;
      notifyListeners();
    }
  }
}
