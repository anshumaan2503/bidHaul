import 'package:flutter/material.dart';
import '../models/competitive_bid.dart';
import '../models/tender.dart';
import '../services/tender_service.dart';

class TenderProvider with ChangeNotifier {
  final TenderService _tenderService;

  List<TenderModel> _myTenders = [];
  List<TenderModel> _liveTenders = [];
  TenderModel? _selectedTender;
  List<CompetitiveBidModel> _competitiveStatement = [];
  bool _isLoading = false;
  String? _errorMessage;

  TenderProvider({TenderService? tenderService})
      : _tenderService = tenderService ?? TenderService();

  List<TenderModel> get myTenders => _myTenders;
  List<TenderModel> get liveTenders => _liveTenders;
  TenderModel? get selectedTender => _selectedTender;
  List<CompetitiveBidModel> get competitiveStatement => _competitiveStatement;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchMyTenders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _myTenders = await _tenderService.getMyTenders();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLiveTenders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _liveTenders = await _tenderService.getLiveTenders();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<TenderModel?> fetchTenderDetails(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedTender = await _tenderService.getTender(id);
      return _selectedTender;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<TenderModel?> createTender(CreateTenderRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final created = await _tenderService.createTender(request);
      _myTenders.insert(0, created);
      _selectedTender = created;
      _isLoading = false;
      notifyListeners();
      return created;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> closeTender(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final closed = await _tenderService.closeTender(id);
      _selectedTender = closed;
      
      final index = _myTenders.indexWhere((item) => item.id == id);
      if (index != -1) {
        _myTenders[index] = closed;
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

  Future<void> fetchCompetitiveStatement(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _competitiveStatement = await _tenderService.getCompetitiveStatement(id);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> awardTender({
    required String tenderId,
    required String negotiationId,
    required String terms,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _tenderService.awardTender(
        tenderId: tenderId,
        negotiationId: negotiationId,
        terms: terms,
      );
      await fetchTenderDetails(tenderId);
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

  Future<bool> deleteTender(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _tenderService.deleteTender(id);
      _myTenders.removeWhere((item) => item.id == id);
      _liveTenders.removeWhere((item) => item.id == id);
      if (_selectedTender?.id == id) {
        _selectedTender = null;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _myTenders.removeWhere((item) => item.id == id);
      _liveTenders.removeWhere((item) => item.id == id);
      if (_selectedTender?.id == id) {
        _selectedTender = null;
      }
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }
}
