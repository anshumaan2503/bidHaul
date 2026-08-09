import '../models/audit_log.dart';

final List<AuditLogModel> dummyAuditLogs = [
  AuditLogModel(
    id: "LOG-001",
    actorUserId: "ADMIN-01",
    action: "Approved Company Registration",
    entityType: "COMPANY",
    entityId: "COMP-101",
    metadata: "KYC Verified",
    timestamp: DateTime.now().subtract(const Duration(hours: 4)),
  ),
  AuditLogModel(
    id: "LOG-002",
    actorUserId: "ADMIN-01",
    action: "Suspended Transporter Account",
    entityType: "TRANSPORTER",
    entityId: "TR-205",
    metadata: "Policy Violation",
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
  ),
];