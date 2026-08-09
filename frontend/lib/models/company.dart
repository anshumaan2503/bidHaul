typedef Company = CompanyProfileModel;

class CompanyProfileModel {
  final String id;
  final String userId;
  final String companyName;
  final String? ownerName;
  final String? email;
  final String? phone;
  final String? address;
  final String? gstNumber;
  final String? licenseNumber;
  final String verificationStatus; // PENDING, SUBMITTED, VERIFIED, REJECTED
  final String? rejectionReason;
  final String? submittedAt;
  final String? verifiedAt;
  final String? createdAt;

  CompanyProfileModel({
    required this.id,
    required this.userId,
    required this.companyName,
    this.ownerName,
    this.email,
    this.phone,
    this.address,
    this.gstNumber,
    this.licenseNumber,
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

  String get status => verificationStatus;
  String get registrationDate => submittedAt ?? createdAt ?? '';

  factory CompanyProfileModel.fromJson(Map<String, dynamic> json) {
    return CompanyProfileModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? '',
      ownerName: json['ownerName']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      gstNumber: json['gstNumber']?.toString(),
      licenseNumber: json['licenseNumber']?.toString(),
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
      'address': address,
      'gstNumber': gstNumber,
      'licenseNumber': licenseNumber,
      'verificationStatus': verificationStatus,
      'rejectionReason': rejectionReason,
      'submittedAt': submittedAt,
      'verifiedAt': verifiedAt,
      'createdAt': createdAt,
    };
  }
}

class CreateCompanyProfileRequest {
  final String companyName;
  final String? address;
  final String? gstNumber;
  final String? licenseNumber;

  CreateCompanyProfileRequest({
    required this.companyName,
    this.address,
    this.gstNumber,
    this.licenseNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName.trim(),
      if (address != null && address!.trim().isNotEmpty) 'address': address!.trim(),
      if (gstNumber != null && gstNumber!.trim().isNotEmpty) 'gstNumber': gstNumber!.trim(),
      if (licenseNumber != null && licenseNumber!.trim().isNotEmpty) 'licenseNumber': licenseNumber!.trim(),
    };
  }
}

class UpdateCompanyProfileRequest {
  final String companyName;
  final String? address;
  final String? gstNumber;
  final String? licenseNumber;

  UpdateCompanyProfileRequest({
    required this.companyName,
    this.address,
    this.gstNumber,
    this.licenseNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName.trim(),
      if (address != null && address!.trim().isNotEmpty) 'address': address!.trim(),
      if (gstNumber != null && gstNumber!.trim().isNotEmpty) 'gstNumber': gstNumber!.trim(),
      if (licenseNumber != null && licenseNumber!.trim().isNotEmpty) 'licenseNumber': licenseNumber!.trim(),
    };
  }
}
