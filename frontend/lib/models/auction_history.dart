class AuctionHistory {
  final String tenderId;
  final String route;
  final String vehicleType;
  final double finalAmount;
  final String winner;
  final String closedDate;
  final String status;

  const AuctionHistory({
    required this.tenderId,
    required this.route,
    required this.vehicleType,
    required this.finalAmount,
    required this.winner,
    required this.closedDate,
    required this.status,
  });
}