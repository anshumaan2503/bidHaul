import '../core/constants/api_constants.dart';
import '../core/services/api_client.dart';
import '../models/auth_request.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  Future<AuthResponse> signup(SignupRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.signup,
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<AuthResponse> adminLogin(AdminLoginRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.adminLogin,
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.refreshToken,
        data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
      );
      return AuthResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.me);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
