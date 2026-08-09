import '../core/services/api_client.dart';
import '../models/admin_dashboard.dart';

class AdminGovernanceService {
  final ApiClient _apiClient;

  AdminGovernanceService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  /// GET /api/v1/admin/dashboard
  Future<AdminDashboardModel> getDashboard() async {
    try {
      final response = await _apiClient.dio.get('/api/v1/admin/dashboard');
      return AdminDashboardModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// PATCH /api/v1/admin/users/{userId}/suspend
  Future<bool> suspendUser(String userId) async {
    try {
      final response = await _apiClient.dio.patch('/api/v1/admin/users/$userId/suspend');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// PATCH /api/v1/admin/users/{userId}/activate
  Future<bool> activateUser(String userId) async {
    try {
      final response = await _apiClient.dio.patch('/api/v1/admin/users/$userId/activate');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
