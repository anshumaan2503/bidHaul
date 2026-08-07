class Transporter {
  final String id;
  final String companyName;
  final String ownerName;
  final String phone;
  final int completedDeliveries;
  final double rating;
  final String status;

  const Transporter({
    required this.id,
    required this.companyName,
    required this.ownerName,
    required this.phone,
    required this.completedDeliveries,
    required this.rating,
    required this.status,
  });
}