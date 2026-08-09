import 'dart:convert';

class SubscriptionPlanModel {
  final String id;
  final String name;
  final double monthlyPrice;
  final String description;
  final List<String> features;
  final bool recommended;
  final bool active;
  final String? createdAt;
  final String? updatedAt;

  SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.monthlyPrice,
    required this.description,
    required this.features,
    required this.recommended,
    required this.active,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
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

    return SubscriptionPlanModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      monthlyPrice: (json['monthlyPrice'] as num?)?.toDouble() ?? 0.0,
      description: json['description']?.toString() ?? '',
      features: parsedFeatures,
      recommended: json['recommended'] == true,
      active: json['active'] == true,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'monthlyPrice': monthlyPrice,
      'description': description,
      'features': jsonEncode(features),
      'recommended': recommended,
      'active': active,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class CreateSubscriptionPlanRequest {
  final String name;
  final double monthlyPrice;
  final String description;
  final List<String> features;
  final bool recommended;

  CreateSubscriptionPlanRequest({
    required this.name,
    required this.monthlyPrice,
    required this.description,
    required this.features,
    this.recommended = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'monthlyPrice': monthlyPrice,
      'description': description,
      'features': jsonEncode(features),
      'recommended': recommended,
    };
  }
}