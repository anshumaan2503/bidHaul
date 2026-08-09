class AcceptedContract {
  final String id;
  final String company;
  final String origin;
  final String destination;
  final String vehicleType;
  final double contractAmount;
  final String pickupDate;
  final String acceptedOn;
  final String status;

  const AcceptedContract({
    required this.id,
    required this.company,
    required this.origin,
    required this.destination,
    required this.vehicleType,
    required this.contractAmount,
    required this.pickupDate,
    required this.acceptedOn,
    required this.status,
  });
}