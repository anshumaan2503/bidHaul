class BidHistory {
  final String tenderId;
  final String company;
  final String route;
  final double bidAmount;
  final String bidDate;
  final String status;

  const BidHistory({
    required this.tenderId,
    required this.company,
    required this.route,
    required this.bidAmount,
    required this.bidDate,
    required this.status,
  });
}