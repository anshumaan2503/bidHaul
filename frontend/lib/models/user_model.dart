class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String userType; // COMPANY, TRANSPORTER, ADMIN, SUPER_ADMIN
  final String status; // ACTIVE, SUSPENDED, PENDING
  final String? createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    required this.userType,
    required this.status,
    this.createdAt,
  });

  bool get isCompany => userType.toUpperCase() == 'COMPANY';
  bool get isTransporter => userType.toUpperCase() == 'TRANSPORTER';
  bool get isAdmin => userType.toUpperCase() == 'ADMIN';
  bool get isSuperAdmin => userType.toUpperCase() == 'SUPER_ADMIN';
  bool get isAdministrative => isAdmin || isSuperAdmin;
  bool get isSuspended => status.toUpperCase() == 'SUSPENDED';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      phone: json['phone']?.toString(),
      userType: json['userType']?.toString() ?? 'COMPANY',
      status: json['status']?.toString() ?? 'ACTIVE',
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'userType': userType,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
