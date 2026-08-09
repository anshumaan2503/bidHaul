enum UserType { company, transporter, admin, superAdmin }

enum UserStatus { active, suspended }

class PlatformUser {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final UserType type;
  final UserStatus status;

  const PlatformUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
    required this.status,
  });

  factory PlatformUser.fromJson(Map<String, dynamic> json) {
    UserType parseType(String? t) {
      if (t == null) return UserType.company;
      switch (t.toUpperCase()) {
        case 'TRANSPORTER':
          return UserType.transporter;
        case 'ADMIN':
          return UserType.admin;
        case 'SUPER_ADMIN':
          return UserType.superAdmin;
        case 'COMPANY':
        default:
          return UserType.company;
      }
    }

    UserStatus parseStatus(String? s) {
      if (s != null && s.toUpperCase() == 'SUSPENDED') {
        return UserStatus.suspended;
      }
      return UserStatus.active;
    }

    return PlatformUser(
      userId: json['userId']?.toString() ?? json['id']?.toString() ?? '',
      name: json['fullName']?.toString() ?? json['name']?.toString() ?? json['ownerName']?.toString() ?? 'User',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      type: parseType(json['userType']?.toString() ?? json['type']?.toString()),
      status: parseStatus(json['status']?.toString()),
    );
  }
}