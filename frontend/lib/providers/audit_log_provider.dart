import 'package:flutter/material.dart';
import '../models/audit_log.dart';
import '../services/audit_log_service.dart';

class AuditLogProvider with ChangeNotifier {
  final AuditLogService _service;

  List<AuditLogModel> _auditLogs = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 0;
  int _totalPages = 1;
  int _totalElements = 0;
  bool _hasMore = false;

  String? _filterActorUserId;
  String? _filterEntityType;
  String? _filterEntityId;

  AuditLogProvider({AuditLogService? service})
      : _service = service ?? AuditLogService();

  List<AuditLogModel> get auditLogs => _auditLogs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalElements => _totalElements;
  bool get hasMore => _hasMore;

  String? get filterActorUserId => _filterActorUserId;
  String? get filterEntityType => _filterEntityType;
  String? get filterEntityId => _filterEntityId;

  Future<void> fetchAuditLogs({
    bool refresh = false,
    String? actorUserId,
    String? entityType,
    String? entityId,
  }) async {
    if (refresh) {
      _currentPage = 0;
      _auditLogs = [];
      _filterActorUserId = actorUserId;
      _filterEntityType = entityType;
      _filterEntityId = entityId;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      Map<String, dynamic> pageData;

      if (_filterActorUserId != null && _filterActorUserId!.isNotEmpty) {
        pageData = await _service.getAuditLogsByActor(
          actorUserId: _filterActorUserId!,
          page: _currentPage,
        );
      } else if (_filterEntityType != null &&
          _filterEntityType!.isNotEmpty &&
          _filterEntityId != null &&
          _filterEntityId!.isNotEmpty) {
        pageData = await _service.getAuditLogsByEntity(
          entityType: _filterEntityType!,
          entityId: _filterEntityId!,
          page: _currentPage,
        );
      } else {
        pageData = await _service.getAllAuditLogs(page: _currentPage);
      }

      final List content = (pageData['content'] as List?) ?? [];
      final newLogs = content
          .map((json) => AuditLogModel.fromJson(json as Map<String, dynamic>))
          .toList();

      if (refresh) {
        _auditLogs = newLogs;
      } else {
        _auditLogs.addAll(newLogs);
      }

      _totalPages = (pageData['totalPages'] as num?)?.toInt() ?? 1;
      _totalElements = (pageData['totalElements'] as num?)?.toInt() ?? _auditLogs.length;
      _hasMore = (pageData['last'] as bool?) == false;
      _currentPage = (pageData['number'] as num?)?.toInt() ?? _currentPage;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (!_isLoading && _hasMore) {
      _currentPage++;
      await fetchAuditLogs();
    }
  }
}
