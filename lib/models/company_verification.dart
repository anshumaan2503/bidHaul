class CompanyVerification {
  final int id;
  final String companyName;
  final String ownerName;
  final String email;
  final String phone;
  final String address;
  final String gstNumber;
  final String licenseNumber;
  final String registrationDate;
  final String status;

  const CompanyVerification({
    required this.id,
    required this.companyName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.address,
    required this.gstNumber,
    required this.licenseNumber,
    required this.registrationDate,
    required this.status,
  });
}