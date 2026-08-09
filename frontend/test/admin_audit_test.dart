import 'package:flutter_test/flutter_test.dart';
import 'package:bidhaul/models/admin_dashboard.dart';
import 'package:bidhaul/models/audit_log.dart';
import 'package:bidhaul/models/platform_user.dart';

void main() {
  group('Part 9 Admin & Audit Models Test', () {
    test('AdminDashboardModel.fromJson parses fields correctly', () {
      final json = {
        'totalUsers': 150,
        'activeCompanies': 45,
        'activeTransporters': 90,
        'liveTenders': 12,
        'openNegotiations': 5,
      };

      final model = AdminDashboardModel.fromJson(json);

      expect(model.totalUsers, equals(150));
      expect(model.activeCompanies, equals(45));
      expect(model.activeTransporters, equals(90));
      expect(model.liveTenders, equals(12));
      expect(model.openNegotiations, equals(5));
    });

    test('AuditLogModel.fromJson parses backend DTO correctly', () {
      final json = {
        'id': 'audit-uuid-101',
        'actorUserId': 'admin-uuid-001',
        'action': 'USER_SUSPENDED',
        'entityType': 'USER',
        'entityId': 'target-user-002',
        'metadata': 'Suspended due to policy violation',
        'timestamp': '2026-08-09T04:00:00Z',
      };

      final log = AuditLogModel.fromJson(json);

      expect(log.id, equals('audit-uuid-101'));
      expect(log.actorUserId, equals('admin-uuid-001'));
      expect(log.action, equals('USER_SUSPENDED'));
      expect(log.entityType, equals('USER'));
      expect(log.entityId, equals('target-user-002'));
      expect(log.metadata, equals('Suspended due to policy violation'));
      expect(log.timestamp.year, equals(2026));
    });

    test('PlatformUser.fromJson parses roles and status correctly', () {
      final companyJson = {
        'userId': 'user-1',
        'fullName': 'Acme Corp',
        'email': 'acme@test.com',
        'phone': '9876543210',
        'userType': 'COMPANY',
        'status': 'ACTIVE',
      };

      final user = PlatformUser.fromJson(companyJson);

      expect(user.userId, equals('user-1'));
      expect(user.name, equals('Acme Corp'));
      expect(user.type, equals(UserType.company));
      expect(user.status, equals(UserStatus.active));
    });
  });
}
