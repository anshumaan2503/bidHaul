import '../models/audit_log.dart';

final List<AuditLog> dummyAuditLogs = [
  const AuditLog(
    action: "Approved Company",
    performedBy: "Admin",
    dateTime: "07 Aug 2026 09:45",
  ),
  const AuditLog(
    action: "Suspended User",
    performedBy: "Admin",
    dateTime: "07 Aug 2026 10:20",
  ),
];