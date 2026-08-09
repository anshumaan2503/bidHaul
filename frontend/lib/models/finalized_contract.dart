class FinalizedContract {
  final String transporter;
  final double amount;
  final String tenderId;
  final String status;

  const FinalizedContract({
    required this.transporter,
    required this.amount,
    required this.tenderId,
    required this.status,
  });
}