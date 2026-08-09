import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'storage_service.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;
  bool _isRefreshing = false;

  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  static ApiClient getInstance() {
    _instance ??= ApiClient._();
    return _instance!;
  }

  Dio get dio => _dio;

  void updateBaseUrl(String newUrl) {
    ApiConstants.baseUrl = newUrl;
    _dio.options.baseUrl = newUrl;
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final storage = await StorageService.getInstance();
          final accessToken = storage.getAccessToken();

          // Do not attach access token to public endpoints or refresh endpoint
          final isPublicAuth = options.path.contains('/api/v1/auth/login') ||
              options.path.contains('/api/v1/auth/signup') ||
              options.path.contains('/api/v1/auth/admin-login') ||
              options.path.contains('/api/v1/auth/refresh');

          if (accessToken != null && accessToken.isNotEmpty && !isPublicAuth) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401 && !_isRefreshing) {
            final path = error.requestOptions.path;
            final isAuthPath = path.contains('/api/v1/auth/login') ||
                path.contains('/api/v1/auth/signup') ||
                path.contains('/api/v1/auth/admin-login') ||
                path.contains('/api/v1/auth/refresh');

            if (!isAuthPath) {
              _isRefreshing = true;
              final storage = await StorageService.getInstance();
              final refreshToken = storage.getRefreshToken();

              if (refreshToken != null && refreshToken.isNotEmpty) {
                try {
                  // Attempt token refresh using a clean Dio instance to prevent infinite loop
                  final refreshDio = Dio(
                    BaseOptions(
                      baseUrl: _dio.options.baseUrl,
                      headers: {'Content-Type': 'application/json'},
                    ),
                  );

                  final response = await refreshDio.post(
                    ApiConstants.refreshToken,
                    data: {'refreshToken': refreshToken},
                  );

                  if (response.statusCode == 200 && response.data != null) {
                    final data = response.data as Map<String, dynamic>;
                    final newAccessToken = data['token']?.toString();
                    final newRefreshToken = data['refreshToken']?.toString();

                    if (newAccessToken != null && newRefreshToken != null) {
                      await storage.setAccessToken(newAccessToken);
                      await storage.setRefreshToken(newRefreshToken);

                      // Retry original request with new access token
                      final opts = error.requestOptions;
                      opts.headers['Authorization'] = 'Bearer $newAccessToken';
                      _isRefreshing = false;

                      final clonedRequest = await _dio.fetch(opts);
                      return handler.resolve(clonedRequest);
                    }
                  }
                } catch (refreshErr) {
                  // Refresh failed, clear session
                  await storage.clearSession();
                } finally {
                  _isRefreshing = false;
                }
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Parse backend error messages
  static String parseError(dynamic error) {
    if (error is DioException) {
      if (error.response != null && error.response?.data != null) {
        final data = error.response?.data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('message') && data['message'] != null) {
            return data['message'].toString();
          }
          if (data.containsKey('error') && data['error'] != null) {
            return data['error'].toString();
          }
        }
      }
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timed out. Please check your network or server URL.';
        case DioExceptionType.receiveTimeout:
          return 'Server response timed out. Please try again.';
        case DioExceptionType.connectionError:
          return 'Unable to connect to BidHaul backend server (${ApiConstants.baseUrl}).';
        default:
          return 'Network request failed (${error.response?.statusCode ?? 'Connection Error'}).';
      }
    }
    return error.toString();
  }
}
