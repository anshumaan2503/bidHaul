class AuditLogModel {
  final String id;
  final String actorUserId;
  final String action;
  final String entityType;
  final String entityId;
  final String? metadata;
  final DateTime timestamp;

  const AuditLogModel({
    required this.id,
    required this.actorUserId,
    required this.action,
    required this.entityType,
    required this.entityId,
    this.metadata,
    required this.timestamp,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id']?.toString() ?? '',
      actorUserId: json['actorUserId']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      entityType: json['entityType']?.toString() ?? '',
      entityId: json['entityId']?.toString() ?? '',
      metadata: json['metadata']?.toString(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actorUserId': actorUserId,
      'action': action,
      'entityType': entityType,
      'entityId': entityId,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}