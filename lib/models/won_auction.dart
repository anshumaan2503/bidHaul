class WonAuction {
  final String id;
  final String company;
  final String origin;
  final String destination;
  final String vehicleType;
  final double winningPrice;
  final String pickupDate;
  final String awardedDate;
  final String status;

  const WonAuction({
    required this.id,
    required this.company,
    required this.origin,
    required this.destination,
    required this.vehicleType,
    required this.winningPrice,
    required this.pickupDate,
    required this.awardedDate,
    required this.status,
  });
}