import 'package:flutter/foundation.dart';

@immutable
class DeliveryModel {
  final String id;
  final String contractId;
  final String tenderId;
  final String companyId;
  final String transporterId;
  final String pickupLocation;
  final String deliveryLocation;
  final String status; // PENDING_PICKUP, IN_TRANSIT, DELIVERED, COMPLETED
  final String? pickedUpAt;
  final String? deliveredAt;
  final String? confirmedAt;
  final double? rating;
  final String? createdAt;
  final String? updatedAt;

  const DeliveryModel({
    required this.id,
    required this.contractId,
    required this.tenderId,
    required this.companyId,
    required this.transporterId,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.status,
    this.pickedUpAt,
    this.deliveredAt,
    this.confirmedAt,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  bool get isPendingPickup => status == 'PENDING_PICKUP';
  bool get isInTransit => status == 'IN_TRANSIT';
  bool get isDelivered => status == 'DELIVERED';
  bool get isCompleted => status == 'COMPLETED';

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id']?.toString() ?? '',
      contractId: json['contractId']?.toString() ?? '',
      tenderId: json['tenderId']?.toString() ?? '',
      companyId: json['companyId']?.toString() ?? '',
      transporterId: json['transporterId']?.toString() ?? '',
      pickupLocation: json['pickupLocation']?.toString() ?? '',
      deliveryLocation: json['deliveryLocation']?.toString() ?? '',
      status: json['status']?.toString() ?? 'PENDING_PICKUP',
      pickedUpAt: json['pickedUpAt']?.toString(),
      deliveredAt: json['deliveredAt']?.toString(),
      confirmedAt: json['confirmedAt']?.toString(),
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contractId': contractId,
      'tenderId': tenderId,
      'companyId': companyId,
      'transporterId': transporterId,
      'pickupLocation': pickupLocation,
      'deliveryLocation': deliveryLocation,
      'status': status,
      'pickedUpAt': pickedUpAt,
      'deliveredAt': deliveredAt,
      'confirmedAt': confirmedAt,
      'rating': rating,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

@immutable
class TrackingEventModel {
  final String id;
  final String deliveryId;
  final String status;
  final String location;
  final String? remarks;
  final String? createdAt;

  const TrackingEventModel({
    required this.id,
    required this.deliveryId,
    required this.status,
    required this.location,
    this.remarks,
    this.createdAt,
  });

  factory TrackingEventModel.fromJson(Map<String, dynamic> json) {
    return TrackingEventModel(
      id: json['id']?.toString() ?? '',
      deliveryId: json['deliveryId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      remarks: json['remarks']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deliveryId': deliveryId,
      'status': status,
      'location': location,
      'remarks': remarks,
      'createdAt': createdAt,
    };
  }
}

@immutable
class AddTrackingUpdateRequest {
  final String location;
  final String? remarks;

  const AddTrackingUpdateRequest({
    required this.location,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'location': location.trim(),
      if (remarks != null && remarks!.trim().isNotEmpty) 'remarks': remarks!.trim(),
    };
  }
}

@immutable
class RateDeliveryRequest {
  final double rating;

  const RateDeliveryRequest({
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
    };
  }
}
