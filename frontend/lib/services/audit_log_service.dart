import '../core/services/api_client.dart';

class AuditLogService {
  final ApiClient _apiClient;

  AuditLogService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  /// GET /api/v1/admin/audit-logs
  Future<Map<String, dynamic>> getAllAuditLogs({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/v1/admin/audit-logs',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/admin/audit-logs/actor/{actorUserId}
  Future<Map<String, dynamic>> getAuditLogsByActor({
    required String actorUserId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/v1/admin/audit-logs/actor/$actorUserId',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/admin/audit-logs/entity/{entityType}/{entityId}
  Future<Map<String, dynamic>> getAuditLogsByEntity({
    required String entityType,
    required String entityId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/v1/admin/audit-logs/entity/$entityType/$entityId',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
