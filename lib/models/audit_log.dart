class AuditLog {
  final String action;
  final String performedBy;
  final String dateTime;

  const AuditLog({
    required this.action,
    required this.performedBy,
    required this.dateTime,
  });
}