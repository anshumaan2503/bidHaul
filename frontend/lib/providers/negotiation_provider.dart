import 'package:flutter/material.dart';

import '../models/negotiation.dart';
import '../services/negotiation_service.dart';

class NegotiationProvider with ChangeNotifier {
  final NegotiationService _negotiationService;

  NegotiationProvider({NegotiationService? negotiationService})
      : _negotiationService = negotiationService ?? NegotiationService();

  List<NegotiationModel> _myNegotiations = [];
  List<NegotiationModel> _tenderNegotiations = [];
  NegotiationModel? _currentNegotiation;

  bool _isLoading = false;
  String? _errorMessage;

  List<NegotiationModel> get myNegotiations => _myNegotiations;
  List<NegotiationModel> get tenderNegotiations => _tenderNegotiations;
  NegotiationModel? get currentNegotiation => _currentNegotiation;
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

  Future<void> fetchMyNegotiations() async {
    _setLoading(true);
    _setError(null);
    try {
      _myNegotiations = await _negotiationService.getMyNegotiations();
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchTenderNegotiations(String tenderId) async {
    _setLoading(true);
    _setError(null);
    try {
      _tenderNegotiations = await _negotiationService.getTenderNegotiations(tenderId);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchNegotiation(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      _currentNegotiation = await _negotiationService.getNegotiation(id);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<NegotiationModel?> createNegotiation(String bidId, [String? remarks]) async {
    _setLoading(true);
    _setError(null);
    try {
      final req = CreateNegotiationRequest(bidId: bidId, remarks: remarks);
      final created = await _negotiationService.createNegotiation(req);
      _currentNegotiation = created;
      await fetchMyNegotiations();
      return created;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addOffer(String id, double amount, String remarks) async {
    _setLoading(true);
    _setError(null);
    try {
      final req = CreateNegotiationOfferRequest(amount: amount, remarks: remarks);
      final updated = await _negotiationService.addOffer(id, req);
      _currentNegotiation = updated;
      _updateLocalList(updated);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> acceptNegotiation(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      final updated = await _negotiationService.acceptNegotiation(id);
      _currentNegotiation = updated;
      _updateLocalList(updated);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> rejectNegotiation(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      final updated = await _negotiationService.rejectNegotiation(id);
      _currentNegotiation = updated;
      _updateLocalList(updated);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _updateLocalList(NegotiationModel updated) {
    final idx = _myNegotiations.indexWhere((n) => n.id == updated.id);
    if (idx != -1) {
      _myNegotiations[idx] = updated;
    }
    final tIdx = _tenderNegotiations.indexWhere((n) => n.id == updated.id);
    if (tIdx != -1) {
      _tenderNegotiations[tIdx] = updated;
    }
  }
}
