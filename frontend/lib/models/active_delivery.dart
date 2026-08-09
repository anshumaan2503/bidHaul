class ActiveDelivery {
  final String id;
  final String company;
  final String origin;
  final String destination;
  final String vehicleType;
  final double amount;
  final String pickupDate;
  final String expectedDelivery;
  final String status;

  const ActiveDelivery({
    required this.id,
    required this.company,
    required this.origin,
    required this.destination,
    required this.vehicleType,
    required this.amount,
    required this.pickupDate,
    required this.expectedDelivery,
    required this.status,
  });
}