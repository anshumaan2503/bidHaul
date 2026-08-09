typedef CompetitiveBid = CompetitiveBidModel;

class CompetitiveBidModel {
  final int rank;
  final String bidId;
  final String bidNumber;
  final String transporterId;
  final String transporterName;
  final double initialBidAmount;
  final double currentNegotiationAmount;
  final double finalNegotiatedAmount;
  final double savingsAmount;
  final String negotiationStatus;

  CompetitiveBidModel({
    required this.rank,
    required this.bidId,
    required this.bidNumber,
    required this.transporterId,
    required this.transporterName,
    required this.initialBidAmount,
    required this.currentNegotiationAmount,
    required this.finalNegotiatedAmount,
    required this.savingsAmount,
    required this.negotiationStatus,
  });

  // Backward compatible getters
  String get transporter => transporterName;
  double get initialBid => initialBidAmount;
  double get negotiatedBid => finalNegotiatedAmount > 0 ? finalNegotiatedAmount : currentNegotiationAmount;
  bool get winner => rank == 1;

  factory CompetitiveBidModel.fromJson(Map<String, dynamic> json) {
    return CompetitiveBidModel(
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      bidId: json['bidId']?.toString() ?? '',
      bidNumber: json['bidNumber']?.toString() ?? '',
      transporterId: json['transporterId']?.toString() ?? '',
      transporterName: json['transporterName']?.toString() ?? 'Transporter',
      initialBidAmount: (json['initialBidAmount'] as num?)?.toDouble() ?? 0.0,
      currentNegotiationAmount: (json['currentNegotiationAmount'] as num?)?.toDouble() ?? 0.0,
      finalNegotiatedAmount: (json['finalNegotiatedAmount'] as num?)?.toDouble() ?? 0.0,
      savingsAmount: (json['savingsAmount'] as num?)?.toDouble() ?? 0.0,
      negotiationStatus: json['negotiationStatus']?.toString() ?? 'PENDING',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'bidId': bidId,
      'bidNumber': bidNumber,
      'transporterId': transporterId,
      'transporterName': transporterName,
      'initialBidAmount': initialBidAmount,
      'currentNegotiationAmount': currentNegotiationAmount,
      'finalNegotiatedAmount': finalNegotiatedAmount,
      'savingsAmount': savingsAmount,
      'negotiationStatus': negotiationStatus,
    };
  }
}