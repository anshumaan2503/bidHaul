import '../core/services/api_client.dart';
import '../models/bid.dart';

class BidService {
  final ApiClient _apiClient;

  BidService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  Future<BidModel> placeBid(String tenderId, CreateBidRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/tenders/$tenderId/bids',
        data: request.toJson(),
      );
      return BidModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<List<BidModel>> getTenderBids(String tenderId) async {
    try {
      final response = await _apiClient.dio.get('/api/v1/tenders/$tenderId/bids');
      final list = response.data as List<dynamic>;
      return list
          .map((item) => BidModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<List<BidModel>> getMyBids() async {
    try {
      final response = await _apiClient.dio.get('/api/v1/bids/my');
      final list = response.data as List<dynamic>;
      return list
          .map((item) => BidModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
