import '../core/services/api_client.dart';
import '../models/delivery.dart';

class DeliveryService {
  final ApiClient _apiClient;

  DeliveryService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  /// GET /api/v1/deliveries/my
  Future<List<DeliveryModel>> getMyDeliveries() async {
    try {
      final response = await _apiClient.dio.get('/api/v1/deliveries/my');
      final list = response.data as List<dynamic>;
      return list
          .map((item) => DeliveryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/deliveries/{id}
  Future<DeliveryModel> getDelivery(String id) async {
    try {
      final response = await _apiClient.dio.get('/api/v1/deliveries/$id');
      return DeliveryModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/deliveries/contract/{contractId}
  Future<DeliveryModel> getContractDelivery(String contractId) async {
    try {
      final response =
          await _apiClient.dio.get('/api/v1/deliveries/contract/$contractId');
      return DeliveryModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/deliveries/{id}/tracking
  Future<List<TrackingEventModel>> getTrackingHistory(String id) async {
    try {
      final response =
          await _apiClient.dio.get('/api/v1/deliveries/$id/tracking');
      final list = response.data as List<dynamic>;
      return list
          .map((item) =>
              TrackingEventModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// POST /api/v1/deliveries/{id}/pickup
  Future<DeliveryModel> markPickedUp(
    String id,
    AddTrackingUpdateRequest request,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/deliveries/$id/pickup',
        data: request.toJson(),
      );
      return DeliveryModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// POST /api/v1/deliveries/{id}/tracking
  Future<TrackingEventModel> addTrackingUpdate(
    String id,
    AddTrackingUpdateRequest request,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/deliveries/$id/tracking',
        data: request.toJson(),
      );
      return TrackingEventModel.fromJson(
          response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// POST /api/v1/deliveries/{id}/delivered
  Future<DeliveryModel> markDelivered(
    String id,
    AddTrackingUpdateRequest request,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/deliveries/$id/delivered',
        data: request.toJson(),
      );
      return DeliveryModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// POST /api/v1/deliveries/{id}/confirm
  Future<DeliveryModel> confirmDelivery(
    String id,
    RateDeliveryRequest request,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/deliveries/$id/confirm',
        data: request.toJson(),
      );
      return DeliveryModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
