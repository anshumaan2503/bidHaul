import 'package:flutter/material.dart';

import '../models/contract.dart';
import '../services/contract_service.dart';

class ContractProvider with ChangeNotifier {
  final ContractService _contractService;

  ContractProvider({ContractService? contractService})
      : _contractService = contractService ?? ContractService();

  List<ContractModel> _myContracts = [];
  ContractModel? _currentContract;
  ContractModel? _tenderContract;

  bool _isLoading = false;
  String? _errorMessage;

  List<ContractModel> get myContracts => _myContracts;
  ContractModel? get currentContract => _currentContract;
  ContractModel? get tenderContract => _tenderContract;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchMyContracts() async {
    _setLoading(true);
    _setError(null);
    try {
      _myContracts = await _contractService.getMyContracts();
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchContract(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      _currentContract = await _contractService.getContract(id);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchTenderContract(String tenderId) async {
    _setLoading(true);
    _setError(null);
    try {
      _tenderContract = await _contractService.getTenderContract(tenderId);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> acceptContract(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      final updated = await _contractService.acceptContract(id);
      _currentContract = updated;
      final idx = _myContracts.indexWhere((c) => c.id == updated.id);
      if (idx != -1) {
        _myContracts[idx] = updated;
      }
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
