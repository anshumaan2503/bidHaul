class SubscriptionRecord {
  final int id;
  final String userName;
  final String userType;
  final String planName;
  final double amount;
  final String purchaseDate;
  final String expiryDate;
  final String status;

  const SubscriptionRecord({
    required this.id,
    required this.userName,
    required this.userType,
    required this.planName,
    required this.amount,
    required this.purchaseDate,
    required this.expiryDate,
    required this.status,
  });
}