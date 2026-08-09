import '../core/services/api_client.dart';
import '../models/negotiation.dart';

class NegotiationService {
  final ApiClient _apiClient;

  NegotiationService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  /// POST /api/v1/negotiations
  Future<NegotiationModel> createNegotiation(CreateNegotiationRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/negotiations',
        data: request.toJson(),
      );
      return NegotiationModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/negotiations/{id}
  Future<NegotiationModel> getNegotiation(String id) async {
    try {
      final response = await _apiClient.dio.get('/api/v1/negotiations/$id');
      return NegotiationModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/negotiations/my
  Future<List<NegotiationModel>> getMyNegotiations() async {
    try {
      final response = await _apiClient.dio.get('/api/v1/negotiations/my');
      final list = response.data as List<dynamic>;
      return list
          .map((item) => NegotiationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/negotiations/tender/{tenderId}
  Future<List<NegotiationModel>> getTenderNegotiations(String tenderId) async {
    try {
      final response = await _apiClient.dio.get('/api/v1/negotiations/tender/$tenderId');
      final list = response.data as List<dynamic>;
      return list
          .map((item) => NegotiationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// POST /api/v1/negotiations/{id}/offers
  Future<NegotiationModel> addOffer(
    String id,
    CreateNegotiationOfferRequest request,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/negotiations/$id/offers',
        data: request.toJson(),
      );
      return NegotiationModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// POST /api/v1/negotiations/{id}/accept
  Future<NegotiationModel> acceptNegotiation(String id) async {
    try {
      final response = await _apiClient.dio.post('/api/v1/negotiations/$id/accept');
      return NegotiationModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// POST /api/v1/negotiations/{id}/reject
  Future<NegotiationModel> rejectNegotiation(String id) async {
    try {
      final response = await _apiClient.dio.post('/api/v1/negotiations/$id/reject');
      return NegotiationModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
