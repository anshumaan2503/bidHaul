import '../core/constants/api_constants.dart';
import '../core/services/api_client.dart';
import '../models/company.dart';

class CompanyService {
  final ApiClient _apiClient;

  CompanyService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  Future<CompanyProfileModel?> getProfile() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.companyProfile);
      if (response.data == null) return null;
      return CompanyProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<CompanyProfileModel> createProfile(CreateCompanyProfileRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.companyProfile,
        data: request.toJson(),
      );
      return CompanyProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<CompanyProfileModel> updateProfile(UpdateCompanyProfileRequest request) async {
    try {
      final response = await _apiClient.dio.put(
        ApiConstants.companyProfile,
        data: request.toJson(),
      );
      return CompanyProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<CompanyProfileModel> submitKyc() async {
    try {
      final response = await _apiClient.dio.post(ApiConstants.companyKycSubmit);
      return CompanyProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
