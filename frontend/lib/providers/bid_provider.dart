import 'package:flutter/material.dart';
import '../models/bid.dart';
import '../services/bid_service.dart';

class BidProvider with ChangeNotifier {
  final BidService _bidService;

  List<BidModel> _myBids = [];
  List<BidModel> _tenderBids = [];
  bool _isLoading = false;
  String? _errorMessage;

  BidProvider({BidService? bidService})
      : _bidService = bidService ?? BidService();

  List<BidModel> get myBids => _myBids;
  List<BidModel> get tenderBids => _tenderBids;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchMyBids() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _myBids = await _bidService.getMyBids();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTenderBids(String tenderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tenderBids = await _bidService.getTenderBids(tenderId);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> placeBid(String tenderId, CreateBidRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final placedBid = await _bidService.placeBid(tenderId, request);
      _myBids.insert(0, placedBid);
      _tenderBids.insert(0, placedBid);
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
