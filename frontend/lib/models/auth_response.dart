import 'user_model.dart';

class AuthResponse {
  final String token;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserModel user;

  AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token']?.toString() ?? json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      tokenType: json['tokenType']?.toString() ?? 'Bearer',
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 86400,
      user: UserModel.fromJson(
        (json['user'] ?? json['userResponse'] ?? {}) as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'user': user.toJson(),
    };
  }
}
