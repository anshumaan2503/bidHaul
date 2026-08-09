import 'dart:convert';

class UserSubscriptionModel {
  final String id;
  final String userId;
  final String planId;
  final String planName;
  final double monthlyPrice;
  final double priceAtSubscription;
  final String description;
  final List<String> features;
  final String billingCycle; // MONTHLY, ANNUAL
  final String status; // PENDING_PAYMENT, ACTIVE, EXPIRED, CANCELLED
  final String? startDate;
  final String? expiryDate;
  final int remainingDays;
  final String? createdAt;
  final String? updatedAt;

  UserSubscriptionModel({
    required this.id,
    required this.userId,
    required this.planId,
    required this.planName,
    required this.monthlyPrice,
    required this.priceAtSubscription,
    required this.description,
    required this.features,
    required this.billingCycle,
    required this.status,
    this.startDate,
    this.expiryDate,
    required this.remainingDays,
    this.createdAt,
    this.updatedAt,
  });

  bool get isPendingPayment => status.toUpperCase() == 'PENDING_PAYMENT';
  bool get isActive => status.toUpperCase() == 'ACTIVE';
  bool get isExpired => status.toUpperCase() == 'EXPIRED';
  bool get isCancelled => status.toUpperCase() == 'CANCELLED';

  factory UserSubscriptionModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedFeatures = [];
    final rawFeatures = json['features'];
    if (rawFeatures is String) {
      if (rawFeatures.trim().startsWith('[')) {
        try {
          final decoded = jsonDecode(rawFeatures);
          if (decoded is List) {
            parsedFeatures = decoded.map((e) => e.toString()).toList();
          }
        } catch (_) {
          parsedFeatures = [rawFeatures];
        }
      } else {
        parsedFeatures = rawFeatures.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }
    } else if (rawFeatures is List) {
      parsedFeatures = rawFeatures.map((e) => e.toString()).toList();
    }

    return UserSubscriptionModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      planId: json['planId']?.toString() ?? '',
      planName: json['planName']?.toString() ?? 'Subscription Plan',
      monthlyPrice: (json['monthlyPrice'] as num?)?.toDouble() ?? 0.0,
      priceAtSubscription: (json['priceAtSubscription'] as num?)?.toDouble() ?? 0.0,
      description: json['description']?.toString() ?? '',
      features: parsedFeatures,
      billingCycle: json['billingCycle']?.toString() ?? 'MONTHLY',
      status: json['status']?.toString() ?? 'PENDING_PAYMENT',
      startDate: json['startDate']?.toString(),
      expiryDate: json['expiryDate']?.toString(),
      remainingDays: (json['remainingDays'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'planId': planId,
      'planName': planName,
      'monthlyPrice': monthlyPrice,
      'priceAtSubscription': priceAtSubscription,
      'description': description,
      'features': jsonEncode(features),
      'billingCycle': billingCycle,
      'status': status,
      'startDate': startDate,
      'expiryDate': expiryDate,
      'remainingDays': remainingDays,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class SubscribeRequest {
  final String planId;
  final String billingCycle;

  SubscribeRequest({
    required this.planId,
    this.billingCycle = 'MONTHLY',
  });

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'billingCycle': billingCycle,
    };
  }
}
