class CompetitiveBid {
  final int rank;
  final String transporter;
  final double initialBid;
  final double negotiatedBid;
  final bool winner;

  const CompetitiveBid({
    required this.rank,
    required this.transporter,
    required this.initialBid,
    required this.negotiatedBid,
    required this.winner,
  });
}