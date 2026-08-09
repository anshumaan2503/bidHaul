typedef Transporter = TransporterProfileModel;

class TransporterProfileModel {
  final String id;
  final String userId;
  final String companyName;
  final String? ownerName;
  final String? email;
  final String? phone;
  final String? vehicleType;
  final int? fleetSize;
  final String? licenseNumber;
  final int completedDeliveries;
  final double rating;
  final String verificationStatus; // PENDING, SUBMITTED, VERIFIED, REJECTED
  final String? rejectionReason;
  final String? submittedAt;
  final String? verifiedAt;
  final String? createdAt;

  TransporterProfileModel({
    required this.id,
    required this.userId,
    required this.companyName,
    this.ownerName,
    this.email,
    this.phone,
    this.vehicleType,
    this.fleetSize,
    this.licenseNumber,
    this.completedDeliveries = 0,
    this.rating = 0.0,
    required this.verificationStatus,
    this.rejectionReason,
    this.submittedAt,
    this.verifiedAt,
    this.createdAt,
  });

  bool get isVerified => verificationStatus.toUpperCase() == 'VERIFIED';
  bool get isSubmitted => verificationStatus.toUpperCase() == 'SUBMITTED';
  bool get isPending => verificationStatus.toUpperCase() == 'PENDING';
  bool get isRejected => verificationStatus.toUpperCase() == 'REJECTED';

  String get transporterName => companyName;
  String get registrationDate => submittedAt ?? createdAt ?? '';
  String get status => verificationStatus;

  factory TransporterProfileModel.fromJson(Map<String, dynamic> json) {
    return TransporterProfileModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? '',
      ownerName: json['ownerName']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      vehicleType: json['vehicleType']?.toString(),
      fleetSize: (json['fleetSize'] as num?)?.toInt(),
      licenseNumber: json['licenseNumber']?.toString(),
      completedDeliveries: (json['completedDeliveries'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      verificationStatus: json['verificationStatus']?.toString() ?? 'PENDING',
      rejectionReason: json['rejectionReason']?.toString(),
      submittedAt: json['submittedAt']?.toString(),
      verifiedAt: json['verifiedAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'companyName': companyName,
      'ownerName': ownerName,
      'email': email,
      'phone': phone,
      'vehicleType': vehicleType,
      'fleetSize': fleetSize,
      'licenseNumber': licenseNumber,
      'completedDeliveries': completedDeliveries,
      'rating': rating,
      'verificationStatus': verificationStatus,
      'rejectionReason': rejectionReason,
      'submittedAt': submittedAt,
      'verifiedAt': verifiedAt,
      'createdAt': createdAt,
    };
  }
}

class CreateTransporterProfileRequest {
  final String companyName;
  final String vehicleType;
  final int fleetSize;
  final String? licenseNumber;

  CreateTransporterProfileRequest({
    required this.companyName,
    required this.vehicleType,
    required this.fleetSize,
    this.licenseNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName.trim(),
      'vehicleType': vehicleType.trim(),
      'fleetSize': fleetSize,
      if (licenseNumber != null && licenseNumber!.trim().isNotEmpty) 'licenseNumber': licenseNumber!.trim(),
    };
  }
}

class UpdateTransporterProfileRequest {
  final String companyName;
  final String vehicleType;
  final int fleetSize;
  final String? licenseNumber;

  UpdateTransporterProfileRequest({
    required this.companyName,
    required this.vehicleType,
    required this.fleetSize,
    this.licenseNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName.trim(),
      'vehicleType': vehicleType.trim(),
      'fleetSize': fleetSize,
      if (licenseNumber != null && licenseNumber!.trim().isNotEmpty) 'licenseNumber': licenseNumber!.trim(),
    };
  }
}