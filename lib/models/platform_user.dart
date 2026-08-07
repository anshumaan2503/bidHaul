enum UserType { company, transporter }

enum UserStatus { active, suspended }

class PlatformUser {
  final int id;
  final String name;
  final String email;
  final String phone;
  final UserType type;
  final UserStatus status;

  const PlatformUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
    required this.status,
  });
}