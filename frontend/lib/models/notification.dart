enum NotificationTypeEnum {
  SYSTEM,
  TENDER,
  BID,
  NEGOTIATION,
  CONTRACT,
  DELIVERY,
  SUBSCRIPTION,
  INVOICE,
  PAYMENT,
  UNKNOWN;

  static NotificationTypeEnum fromString(String? type) {
    if (type == null || type.isEmpty) return NotificationTypeEnum.UNKNOWN;
    return NotificationTypeEnum.values.firstWhere(
      (e) => e.name.toUpperCase() == type.toUpperCase(),
      orElse: () => NotificationTypeEnum.UNKNOWN,
    );
  }
}

class NotificationModel {
  final String id;
  final NotificationTypeEnum type;
  final String title;
  final String message;
  final bool read;
  final DateTime? readAt;
  final String? referenceType;
  final String? referenceId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.read,
    this.readAt,
    this.referenceType,
    this.referenceId,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: NotificationTypeEnum.fromString(json['type']?.toString()),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      read: json['read'] == true,
      readAt: json['readAt'] != null ? DateTime.tryParse(json['readAt'].toString()) : null,
      referenceType: json['referenceType']?.toString(),
      referenceId: json['referenceId']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'message': message,
      'read': read,
      'readAt': readAt?.toIso8601String(),
      'referenceType': referenceType,
      'referenceId': referenceId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    NotificationTypeEnum? type,
    String? title,
    String? message,
    bool? read,
    DateTime? readAt,
    String? referenceType,
    String? referenceId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      read: read ?? this.read,
      readAt: readAt ?? this.readAt,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
