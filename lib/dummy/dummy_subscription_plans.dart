import '../models/subscription_plan.dart';

final List<SubscriptionPlan> dummySubscriptionPlans = [
  const SubscriptionPlan(
    name: "Basic",
    monthlyPrice: 499,
    description: "For small transport businesses",
    recommended: false,
    features: [
      "Up to 20 Auctions",
      "Basic Notifications",
      "Tender Participation",
    ],
  ),
  const SubscriptionPlan(
    name: "Professional",
    monthlyPrice: 999,
    description: "Best for growing companies",
    recommended: true,
    features: [
      "Unlimited Auctions",
      "Priority Notifications",
      "Negotiation Access",
      "Reports",
    ],
  ),
  const SubscriptionPlan(
    name: "Enterprise",
    monthlyPrice: 1999,
    description: "For large logistics organizations",
    recommended: false,
    features: [
      "Unlimited Everything",
      "Dedicated Support",
      "Advanced Reports",
      "Multi Branch",
      "Analytics",
    ],
  ),
];