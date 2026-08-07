class NegotiationOffer {
  final String transporter;
  final double initialBid;
  final double currentOffer;
  final bool isAccepted;

  const NegotiationOffer({
    required this.transporter,
    required this.initialBid,
    required this.currentOffer,
    required this.isAccepted,
  });
}