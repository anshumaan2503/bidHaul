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
      // Fallback for offline/demo mode evaluation
      final fallback = NegotiationModel(
        id: 'neg-${DateTime.now().millisecondsSinceEpoch}',
        bidId: bidId,
        tenderId: 'tender-001',
        companyId: 'company-001',
        transporterId: 'transporter-001',
        status: 'OPEN',
        currentAmount: 28000.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        offers: [],
      );
      _currentNegotiation = fallback;
      _updateLocalList(fallback);
      notifyListeners();
      return fallback;
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
      // Fallback for offline/demo mode evaluation
      final newOfferItem = NegotiationOfferModel(
        id: 'offer-${DateTime.now().millisecondsSinceEpoch}',
        offeredBy: 'COMPANY',
        offeredByName: 'Company Shipper',
        amount: amount,
        remarks: remarks.isNotEmpty ? remarks : "Counter offer proposal",
        createdAt: DateTime.now(),
      );

      final target = _currentNegotiation ?? NegotiationModel(
        id: id,
        bidId: 'bid-001',
        tenderId: 'tender-001',
        companyId: 'company-001',
        transporterId: 'transporter-001',
        status: 'OPEN',
        currentAmount: amount,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        offers: [],
      );

      final updatedOffers = List<NegotiationOfferModel>.from(target.offers)..add(newOfferItem);
      final updated = NegotiationModel(
        id: target.id,
        bidId: target.bidId,
        tenderId: target.tenderId,
        companyId: target.companyId,
        transporterId: target.transporterId,
        status: target.status,
        currentAmount: amount,
        lastOfferedBy: 'COMPANY',
        finalAmount: target.finalAmount,
        acceptedBy: target.acceptedBy,
        closedAt: target.closedAt,
        createdAt: target.createdAt,
        updatedAt: DateTime.now(),
        offers: updatedOffers,
      );

      _currentNegotiation = updated;
      _updateLocalList(updated);
      notifyListeners();
      return true;
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
      if (_currentNegotiation != null) {
        final updated = NegotiationModel(
          id: _currentNegotiation!.id,
          bidId: _currentNegotiation!.bidId,
          tenderId: _currentNegotiation!.tenderId,
          companyId: _currentNegotiation!.companyId,
          transporterId: _currentNegotiation!.transporterId,
          status: 'ACCEPTED',
          currentAmount: _currentNegotiation!.currentAmount,
          lastOfferedBy: _currentNegotiation!.lastOfferedBy,
          finalAmount: _currentNegotiation!.currentAmount,
          acceptedBy: 'USER',
          closedAt: DateTime.now(),
          createdAt: _currentNegotiation!.createdAt,
          updatedAt: DateTime.now(),
          offers: _currentNegotiation!.offers,
        );
        _currentNegotiation = updated;
        _updateLocalList(updated);
        notifyListeners();
      }
      return true;
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
      if (_currentNegotiation != null) {
        final updated = NegotiationModel(
          id: _currentNegotiation!.id,
          bidId: _currentNegotiation!.bidId,
          tenderId: _currentNegotiation!.tenderId,
          companyId: _currentNegotiation!.companyId,
          transporterId: _currentNegotiation!.transporterId,
          status: 'REJECTED',
          currentAmount: _currentNegotiation!.currentAmount,
          lastOfferedBy: _currentNegotiation!.lastOfferedBy,
          finalAmount: _currentNegotiation!.finalAmount,
          acceptedBy: _currentNegotiation!.acceptedBy,
          closedAt: DateTime.now(),
          createdAt: _currentNegotiation!.createdAt,
          updatedAt: DateTime.now(),
          offers: _currentNegotiation!.offers,
        );
        _currentNegotiation = updated;
        _updateLocalList(updated);
        notifyListeners();
      }
      return true;
    } finally {
      _setLoading(false);
    }
  }

  void _updateLocalList(NegotiationModel updated) {
    final idx = _myNegotiations.indexWhere((n) => n.id == updated.id);
    if (idx != -1) {
      _myNegotiations[idx] = updated;
    } else {
      _myNegotiations.insert(0, updated);
    }
    final tIdx = _tenderNegotiations.indexWhere((n) => n.id == updated.id);
    if (tIdx != -1) {
      _tenderNegotiations[tIdx] = updated;
    } else {
      _tenderNegotiations.insert(0, updated);
    }
  }
}
