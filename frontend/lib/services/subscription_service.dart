import '../core/services/api_client.dart';
import '../models/subscription_plan.dart';
import '../models/user_subscription.dart';

class SubscriptionService {
  final ApiClient _apiClient;

  SubscriptionService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  /// GET /api/v1/subscriptions/plans
  Future<List<SubscriptionPlanModel>> getActivePlans() async {
    try {
      final response = await _apiClient.dio.get('/api/v1/subscriptions/plans');
      final data = response.data as List;
      return data.map((json) => SubscriptionPlanModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// POST /api/v1/subscriptions/plans (Super Admin only)
  Future<SubscriptionPlanModel> createPlan(CreateSubscriptionPlanRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/subscriptions/plans',
        data: request.toJson(),
      );
      return SubscriptionPlanModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// POST /api/v1/subscriptions/subscribe
  Future<UserSubscriptionModel> subscribe(SubscribeRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/subscriptions/subscribe',
        data: request.toJson(),
      );
      return UserSubscriptionModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/subscriptions/me
  Future<UserSubscriptionModel> getMySubscription() async {
    try {
      final response = await _apiClient.dio.get('/api/v1/subscriptions/me');
      return UserSubscriptionModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/subscriptions/me/status
  Future<UserSubscriptionModel> getMySubscriptionStatus() async {
    try {
      final response = await _apiClient.dio.get('/api/v1/subscriptions/me/status');
      return UserSubscriptionModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/subscriptions/me/history
  Future<List<UserSubscriptionModel>> getMySubscriptionHistory() async {
    try {
      final response = await _apiClient.dio.get('/api/v1/subscriptions/me/history');
      final data = response.data as List;
      return data.map((json) => UserSubscriptionModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
