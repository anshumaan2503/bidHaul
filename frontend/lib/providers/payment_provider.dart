import 'package:flutter/foundation.dart';

import '../models/payment.dart';
import '../services/payment_service.dart';

enum PaymentFlowStatus {
  idle,
  creatingOrder,
  orderCreated,
  checkoutPending,
  verifying,
  success,
  failed,
  cancelled,
}

class PaymentProvider extends ChangeNotifier {
  final PaymentService _paymentService;

  PaymentProvider({PaymentService? paymentService})
      : _paymentService = paymentService ?? PaymentService();

  bool _isLoading = false;
  String? _errorMessage;
  PaymentFlowStatus _status = PaymentFlowStatus.idle;
  bool _isGatewayShutdown = false;

  PaymentOrderResponse? _currentOrder;
  PaymentResponse? _lastVerificationResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PaymentFlowStatus get status => _status;
  bool get isGatewayShutdown => _isGatewayShutdown;
  PaymentOrderResponse? get currentOrder => _currentOrder;
  PaymentResponse? get lastVerificationResponse => _lastVerificationResponse;

  void toggleGatewayShutdown() {
    _isGatewayShutdown = !_isGatewayShutdown;
    notifyListeners();
  }

  void setGatewayShutdown(bool shutdown) {
    _isGatewayShutdown = shutdown;
    notifyListeners();
  }

  void resetState() {
    _isLoading = false;
    _errorMessage = null;
    _status = PaymentFlowStatus.idle;
    _currentOrder = null;
    _lastVerificationResponse = null;
    notifyListeners();
  }

  /// STEP 1: Create Razorpay order via backend
  Future<PaymentOrderResponse?> createOrder(String invoiceId) async {
    if (_isGatewayShutdown) {
      _errorMessage = "Payment Gateway is currently shutdown by Super Admin for system maintenance.";
      _status = PaymentFlowStatus.failed;
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    _status = PaymentFlowStatus.creatingOrder;
    notifyListeners();

    try {
      final req = CreatePaymentOrderRequest(invoiceId: invoiceId);
      final res = await _paymentService.createPaymentOrder(req);
      _currentOrder = res;
      _status = PaymentFlowStatus.orderCreated;
      _isLoading = false;
      notifyListeners();
      return res;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = PaymentFlowStatus.failed;
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// STEP 5: Send returned Razorpay payment tokens to backend for verification
  Future<PaymentResponse?> verifyPayment({
    required String invoiceId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _status = PaymentFlowStatus.verifying;
    notifyListeners();

    try {
      final req = VerifyPaymentRequest(
        invoiceId: invoiceId,
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
      );
      final res = await _paymentService.verifyPayment(req);
      _lastVerificationResponse = res;

      if (res.isCaptured) {
        _status = PaymentFlowStatus.success;
      } else {
        _status = PaymentFlowStatus.failed;
        _errorMessage = 'Payment status: ${res.status}';
      }
      _isLoading = false;
      notifyListeners();
      return res;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = PaymentFlowStatus.failed;
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void handlePaymentCancelled() {
    _status = PaymentFlowStatus.cancelled;
    _errorMessage = 'Payment was cancelled or closed by user.';
    _isLoading = false;
    notifyListeners();
  }

  void handlePaymentFailed(String errorMsg) {
    _status = PaymentFlowStatus.failed;
    _errorMessage = errorMsg;
    _isLoading = false;
    notifyListeners();
  }
}
