class SubscriptionPlan {
  final String name;
  final double monthlyPrice;
  final String description;
  final List<String> features;
  final bool recommended;

  const SubscriptionPlan({
    required this.name,
    required this.monthlyPrice,
    required this.description,
    required this.features,
    required this.recommended,
  });
}