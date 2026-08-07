enum BidStatus {
  pending,
  accepted,
  rejected,
}

class Bid {
  final String id;
  final String tenderId;
  final String transporterName;
  final String amount;
  final String estimatedDays;
  final String remarks;
  final BidStatus status;

  const Bid({
    required this.id,
    required this.tenderId,
    required this.transporterName,
    required this.amount,
    required this.estimatedDays,
    required this.remarks,
    required this.status,
  });
}