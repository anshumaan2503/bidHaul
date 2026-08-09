import 'package:flutter/material.dart';
import '../models/invoice.dart';
import '../services/invoice_service.dart';

class InvoiceProvider with ChangeNotifier {
  final InvoiceService _service;

  List<InvoiceModel> _myInvoices = [];
  InvoiceModel? _selectedInvoice;
  InvoiceModel? _subscriptionInvoice;

  bool _isLoading = false;
  String? _errorMessage;

  InvoiceProvider({InvoiceService? service})
      : _service = service ?? InvoiceService();

  List<InvoiceModel> get myInvoices => _myInvoices;
  InvoiceModel? get selectedInvoice => _selectedInvoice;
  InvoiceModel? get subscriptionInvoice => _subscriptionInvoice;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchMyInvoices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _myInvoices = await _service.getMyInvoices();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInvoice(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedInvoice = await _service.getInvoice(id);
    } catch (e) {
      _selectedInvoice = null;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSubscriptionInvoice(String subscriptionId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _subscriptionInvoice = await _service.getSubscriptionInvoice(subscriptionId);
    } catch (e) {
      _subscriptionInvoice = null;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
