import '../core/services/api_client.dart';
import '../models/contract.dart';

class ContractService {
  final ApiClient _apiClient;

  ContractService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.getInstance();

  /// GET /api/v1/contracts/{id}
  Future<ContractModel> getContract(String id) async {
    try {
      final response = await _apiClient.dio.get('/api/v1/contracts/$id');
      return ContractModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/contracts/tender/{tenderId}
  Future<ContractModel> getTenderContract(String tenderId) async {
    try {
      final response = await _apiClient.dio.get('/api/v1/contracts/tender/$tenderId');
      return ContractModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// GET /api/v1/contracts/my
  Future<List<ContractModel>> getMyContracts() async {
    try {
      final response = await _apiClient.dio.get('/api/v1/contracts/my');
      final list = response.data as List<dynamic>;
      return list
          .map((item) => ContractModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }

  /// POST /api/v1/contracts/{id}/accept
  Future<ContractModel> acceptContract(
    String id, [
    AcceptContractRequest request = const AcceptContractRequest(accepted: true),
  ]) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/contracts/$id/accept',
        data: request.toJson(),
      );
      return ContractModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception(ApiClient.parseError(e));
    }
  }
}
