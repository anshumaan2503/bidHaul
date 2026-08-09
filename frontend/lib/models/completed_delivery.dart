class CompletedDelivery {
  final String id;
  final String company;
  final String origin;
  final String destination;
  final String vehicleType;
  final double amount;
  final String deliveredOn;
  final String completedOn;
  final String rating;

  const CompletedDelivery({
    required this.id,
    required this.company,
    required this.origin,
    required this.destination,
    required this.vehicleType,
    required this.amount,
    required this.deliveredOn,
    required this.completedOn,
    required this.rating,
  });
}