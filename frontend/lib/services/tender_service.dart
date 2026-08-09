import '../core/services/api_client.dart';
import '../models/competitive_bid.dart';
import '../models/tender.dart';

class TenderService {
  final ApiClient _apiClient;

  TenderService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  Future<TenderModel> createTender(CreateTenderRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/tenders',
        data: request.toJson(),
      );
      return TenderModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<TenderModel> getTender(String id) async {
    try {
      final response = await _apiClient.dio.get('/api/v1/tenders/$id');
      return TenderModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<List<TenderModel>> getMyTenders() async {
    try {
      final response = await _apiClient.dio.get('/api/v1/tenders/my');
      final list = response.data as List<dynamic>;
      return list
          .map((item) => TenderModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<List<TenderModel>> getLiveTenders() async {
    try {
      final response = await _apiClient.dio.get('/api/v1/tenders/live');
      final list = response.data as List<dynamic>;
      return list
          .map((item) => TenderModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<TenderModel> closeTender(String id) async {
    try {
      final response = await _apiClient.dio.put('/api/v1/tenders/$id/close');
      return TenderModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<List<CompetitiveBidModel>> getCompetitiveStatement(String id) async {
    try {
      final response = await _apiClient.dio.get('/api/v1/tenders/$id/competitive-statement');
      final list = response.data as List<dynamic>;
      return list
          .map((item) => CompetitiveBidModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<Map<String, dynamic>> awardTender({
    required String tenderId,
    required String negotiationId,
    required String terms,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/tenders/$tenderId/award',
        queryParameters: {'negotiationId': negotiationId},
        data: terms,
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<void> deleteTender(String id) async {
    try {
      await _apiClient.dio.delete('/api/v1/tenders/$id');
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
