class ActiveSubscription {
  final String planName;
  final double monthlyPrice;
  final String startDate;
  final String expiryDate;
  final int remainingDays;

  const ActiveSubscription({
    required this.planName,
    required this.monthlyPrice,
    required this.startDate,
    required this.expiryDate,
    required this.remainingDays,
  });
}