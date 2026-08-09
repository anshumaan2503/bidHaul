class SignupRequest {
  final String email;
  final String password;
  final String fullName;
  final String? companyName;
  final String? phone;
  final String role; // COMPANY or TRANSPORTER

  SignupRequest({
    required this.email,
    required this.password,
    required this.fullName,
    this.companyName,
    this.phone,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'email': email.trim().toLowerCase(),
      'password': password,
      'fullName': fullName.trim(),
      'role': role.toUpperCase(),
    };
    if (companyName != null && companyName!.trim().isNotEmpty) {
      map['companyName'] = companyName!.trim();
    }
    if (phone != null && phone!.trim().isNotEmpty) {
      map['phone'] = phone!.trim();
    }
    return map;
  }
}

class LoginRequest {
  final String email;
  final String password;
  final String? role; // COMPANY or TRANSPORTER (optional)

  LoginRequest({
    required this.email,
    required this.password,
    this.role,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'email': email.trim().toLowerCase(),
      'password': password,
    };
    if (role != null && role!.trim().isNotEmpty) {
      map['role'] = role!.toUpperCase();
    }
    return map;
  }
}

class AdminLoginRequest {
  final String email;
  final String password;

  AdminLoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim().toLowerCase(),
      'password': password,
    };
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}
