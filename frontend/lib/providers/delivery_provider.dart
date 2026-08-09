import 'package:flutter/material.dart';

import '../models/delivery.dart';
import '../services/delivery_service.dart';

class DeliveryProvider with ChangeNotifier {
  final DeliveryService _deliveryService;

  DeliveryProvider({DeliveryService? deliveryService})
      : _deliveryService = deliveryService ?? DeliveryService();

  List<DeliveryModel> _myDeliveries = [];
  DeliveryModel? _currentDelivery;
  List<TrackingEventModel> _trackingHistory = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<DeliveryModel> get myDeliveries => _myDeliveries;
  List<DeliveryModel> get activeDeliveries =>
      _myDeliveries.where((d) => d.status != 'COMPLETED').toList();
  List<DeliveryModel> get completedDeliveries =>
      _myDeliveries.where((d) => d.status == 'COMPLETED').toList();

  DeliveryModel? get currentDelivery => _currentDelivery;
  List<TrackingEventModel> get trackingHistory => _trackingHistory;
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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchMyDeliveries() async {
    _setLoading(true);
    _setError(null);
    try {
      _myDeliveries = await _deliveryService.getMyDeliveries();
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchDelivery(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      _currentDelivery = await _deliveryService.getDelivery(id);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchContractDelivery(String contractId) async {
    _setLoading(true);
    _setError(null);
    try {
      _currentDelivery =
          await _deliveryService.getContractDelivery(contractId);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchTrackingHistory(String deliveryId) async {
    _setError(null);
    try {
      _trackingHistory =
          await _deliveryService.getTrackingHistory(deliveryId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<bool> markPickedUp(
    String id,
    String location, {
    String? remarks,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final updated = await _deliveryService.markPickedUp(
        id,
        AddTrackingUpdateRequest(location: location, remarks: remarks),
      );
      _currentDelivery = updated;
      _updateLocalDeliveryList(updated);
      await fetchTrackingHistory(id);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addTrackingUpdate(
    String id,
    String location, {
    String? remarks,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      await _deliveryService.addTrackingUpdate(
        id,
        AddTrackingUpdateRequest(location: location, remarks: remarks),
      );
      await fetchTrackingHistory(id);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> markDelivered(
    String id,
    String location, {
    String? remarks,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final updated = await _deliveryService.markDelivered(
        id,
        AddTrackingUpdateRequest(location: location, remarks: remarks),
      );
      _currentDelivery = updated;
      _updateLocalDeliveryList(updated);
      await fetchTrackingHistory(id);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> confirmDelivery(String id, double rating) async {
    _setLoading(true);
    _setError(null);
    try {
      final updated = await _deliveryService.confirmDelivery(
        id,
        RateDeliveryRequest(rating: rating),
      );
      _currentDelivery = updated;
      _updateLocalDeliveryList(updated);
      await fetchTrackingHistory(id);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _updateLocalDeliveryList(DeliveryModel updated) {
    final idx = _myDeliveries.indexWhere((d) => d.id == updated.id);
    if (idx != -1) {
      _myDeliveries[idx] = updated;
    } else {
      _myDeliveries.insert(0, updated);
    }
  }
}
