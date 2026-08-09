import '../core/services/api_client.dart';
import '../models/payment.dart';

class PaymentService {
  final ApiClient _apiClient;

  PaymentService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  /// POST /api/v1/payments/orders
  Future<PaymentOrderResponse> createPaymentOrder(CreatePaymentOrderRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/payments/orders',
        data: request.toJson(),
      );
      return PaymentOrderResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// POST /api/v1/payments/verify
  Future<PaymentResponse> verifyPayment(VerifyPaymentRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/payments/verify',
        data: request.toJson(),
      );
      return PaymentResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
