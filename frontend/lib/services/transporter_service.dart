import '../core/constants/api_constants.dart';
import '../core/services/api_client.dart';
import '../models/transporter.dart';

class TransporterService {
  final ApiClient _apiClient;

  TransporterService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  Future<TransporterProfileModel?> getProfile() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.transporterProfile);
      if (response.data == null) return null;
      return TransporterProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<TransporterProfileModel> createProfile(CreateTransporterProfileRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.transporterProfile,
        data: request.toJson(),
      );
      return TransporterProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<TransporterProfileModel> updateProfile(UpdateTransporterProfileRequest request) async {
    try {
      final response = await _apiClient.dio.put(
        ApiConstants.transporterProfile,
        data: request.toJson(),
      );
      return TransporterProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<TransporterProfileModel> submitKyc() async {
    try {
      final response = await _apiClient.dio.post(ApiConstants.transporterKycSubmit);
      return TransporterProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
