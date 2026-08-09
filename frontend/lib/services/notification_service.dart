import '../core/services/api_client.dart';
import '../models/notification.dart';

class NotificationService {
  final ApiClient _apiClient;

  NotificationService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  /// GET /api/v1/notifications/my
  Future<List<NotificationModel>> getMyNotifications({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/v1/notifications/my',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final List content = data is Map ? (data['content'] ?? []) : (data is List ? data : []);
        return content
            .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/notifications/my/unread
  Future<List<NotificationModel>> getUnreadNotifications({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/v1/notifications/my/unread',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final List content = data is Map ? (data['content'] ?? []) : (data is List ? data : []);
        return content
            .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/notifications/my/unread/count
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.dio.get('/api/v1/notifications/my/unread/count');
      if (response.statusCode == 200 && response.data != null) {
        if (response.data is num) {
          return (response.data as num).toInt();
        }
        return int.tryParse(response.data.toString()) ?? 0;
      }
      return 0;
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// PATCH /api/v1/notifications/{id}/read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final response = await _apiClient.dio.patch('/api/v1/notifications/$notificationId/read');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// PATCH /api/v1/notifications/my/read-all
  Future<bool> markAllAsRead() async {
    try {
      final response = await _apiClient.dio.patch('/api/v1/notifications/my/read-all');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
