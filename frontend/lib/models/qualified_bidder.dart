class QualifiedBidder {
  final int rank;
  final String transporterName;
  final double bidAmount;
  final String vehicleType;
  final String status;

  const QualifiedBidder({
    required this.rank,
    required this.transporterName,
    required this.bidAmount,
    required this.vehicleType,
    required this.status,
  });
}