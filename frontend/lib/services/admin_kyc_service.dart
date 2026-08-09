import '../core/services/api_client.dart';
import '../models/company.dart';
import '../models/transporter.dart';

class AdminKycService {
  final ApiClient _apiClient;

  AdminKycService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  // Company KYC Applications
  Future<List<CompanyProfileModel>> getCompanyApplications({String? status}) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/v1/admin/kyc/companies',
        queryParameters: status != null && status.isNotEmpty ? {'status': status} : null,
      );
      final list = response.data as List<dynamic>;
      return list.map((item) => CompanyProfileModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<CompanyProfileModel> getCompanyApplication(String profileId) async {
    try {
      final response = await _apiClient.dio.get('/api/v1/admin/kyc/companies/$profileId');
      return CompanyProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<CompanyProfileModel> approveCompanyKyc(String profileId) async {
    try {
      final response = await _apiClient.dio.post('/api/v1/admin/kyc/companies/$profileId/approve');
      return CompanyProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<CompanyProfileModel> rejectCompanyKyc(String profileId, String rejectionReason) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/admin/kyc/companies/$profileId/reject',
        data: {'rejectionReason': rejectionReason.trim()},
      );
      return CompanyProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  // Transporter KYC Applications
  Future<List<TransporterProfileModel>> getTransporterApplications({String? status}) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/v1/admin/kyc/transporters',
        queryParameters: status != null && status.isNotEmpty ? {'status': status} : null,
      );
      final list = response.data as List<dynamic>;
      return list.map((item) => TransporterProfileModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<TransporterProfileModel> getTransporterApplication(String profileId) async {
    try {
      final response = await _apiClient.dio.get('/api/v1/admin/kyc/transporters/$profileId');
      return TransporterProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<TransporterProfileModel> approveTransporterKyc(String profileId) async {
    try {
      final response = await _apiClient.dio.post('/api/v1/admin/kyc/transporters/$profileId/approve');
      return TransporterProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  Future<TransporterProfileModel> rejectTransporterKyc(String profileId, String rejectionReason) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/admin/kyc/transporters/$profileId/reject',
        data: {'rejectionReason': rejectionReason.trim()},
      );
      return TransporterProfileModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
