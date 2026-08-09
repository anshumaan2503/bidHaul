// ignore_for_file: constant_identifier_names

typedef Tender = TenderModel;

enum TenderStatus {
  DRAFT,
  LIVE,
  COMPLETED,
  AWARDED,
  CONTRACT_PENDING,
  CONTRACT_ACCEPTED,
  IN_TRANSIT,
  COMPLETED_DELIVERY,
  CANCELLED,
}

class TenderModel {
  final String id;
  final String tenderNumber;
  final String title;
  final String description;
  final String pickupLocation;
  final String deliveryLocation;
  final String materialType;
  final String vehicleType;
  final double weightTons;
  final double ceilingBudget;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  TenderModel({
    required this.id,
    required this.tenderNumber,
    required this.title,
    required this.description,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.materialType,
    required this.vehicleType,
    required this.weightTons,
    required this.ceilingBudget,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  // Backward compatible getters for existing UI
  String get weight => '${weightTons.toStringAsFixed(1)} Tons';
  String get budget => '₹${ceilingBudget.toStringAsFixed(0)}';

  TenderStatus get statusEnum {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return TenderStatus.DRAFT;
      case 'LIVE':
        return TenderStatus.LIVE;
      case 'COMPLETED':
        return TenderStatus.COMPLETED;
      case 'AWARDED':
        return TenderStatus.AWARDED;
      case 'CONTRACT_PENDING':
        return TenderStatus.CONTRACT_PENDING;
      case 'CONTRACT_ACCEPTED':
        return TenderStatus.CONTRACT_ACCEPTED;
      case 'IN_TRANSIT':
        return TenderStatus.IN_TRANSIT;
      case 'COMPLETED_DELIVERY':
        return TenderStatus.COMPLETED_DELIVERY;
      case 'CANCELLED':
        return TenderStatus.CANCELLED;
      default:
        return TenderStatus.LIVE;
    }
  }

  bool get isLive => status.toUpperCase() == 'LIVE';
  bool get isCompleted => status.toUpperCase() == 'COMPLETED';
  bool get isAwarded => status.toUpperCase() == 'AWARDED';
  bool get isCancelled => status.toUpperCase() == 'CANCELLED';
  bool get isDraft => status.toUpperCase() == 'DRAFT';

  factory TenderModel.fromJson(Map<String, dynamic> json) {
    return TenderModel(
      id: json['id']?.toString() ?? '',
      tenderNumber: json['tenderNumber']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      pickupLocation: json['pickupLocation']?.toString() ?? '',
      deliveryLocation: json['deliveryLocation']?.toString() ?? '',
      materialType: json['materialType']?.toString() ?? '',
      vehicleType: json['vehicleType']?.toString() ?? '',
      weightTons: (json['weightTons'] as num?)?.toDouble() ?? 0.0,
      ceilingBudget: (json['ceilingBudget'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'LIVE',
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenderNumber': tenderNumber,
      'title': title,
      'description': description,
      'pickupLocation': pickupLocation,
      'deliveryLocation': deliveryLocation,
      'materialType': materialType,
      'vehicleType': vehicleType,
      'weightTons': weightTons,
      'ceilingBudget': ceilingBudget,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class CreateTenderRequest {
  final String title;
  final String description;
  final String pickupLocation;
  final String deliveryLocation;
  final String materialType;
  final String vehicleType;
  final double weightTons;
  final double ceilingBudget;

  CreateTenderRequest({
    required this.title,
    required this.description,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.materialType,
    required this.vehicleType,
    required this.weightTons,
    required this.ceilingBudget,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title.trim(),
      'description': description.trim(),
      'pickupLocation': pickupLocation.trim(),
      'deliveryLocation': deliveryLocation.trim(),
      'materialType': materialType.trim(),
      'vehicleType': vehicleType.trim(),
      'weightTons': weightTons,
      'ceilingBudget': ceilingBudget,
    };
  }
}