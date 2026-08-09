import '../core/services/api_client.dart';
import '../models/invoice.dart';

class InvoiceService {
  final ApiClient _apiClient;

  InvoiceService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  /// GET /api/v1/invoices/my
  Future<List<InvoiceModel>> getMyInvoices() async {
    try {
      final response = await _apiClient.dio.get('/api/v1/invoices/my');
      final data = response.data as List;
      return data.map((json) => InvoiceModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/invoices/{id}
  Future<InvoiceModel> getInvoice(String id) async {
    try {
      final response = await _apiClient.dio.get('/api/v1/invoices/$id');
      return InvoiceModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/invoices/subscription/{subscriptionId}
  Future<InvoiceModel> getSubscriptionInvoice(String subscriptionId) async {
    try {
      final response = await _apiClient.dio.get('/api/v1/invoices/subscription/$subscriptionId');
      return InvoiceModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
