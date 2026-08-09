import '../models/subscription_plan.dart';

final List<SubscriptionPlanModel> dummySubscriptionPlans = [
  SubscriptionPlanModel(
    id: "dummy-plan-1",
    name: "Basic",
    monthlyPrice: 499,
    description: "For small transport businesses",
    recommended: false,
    active: true,
    features: [
      "Up to 20 Auctions",
      "Basic Notifications",
      "Tender Participation",
    ],
  ),
  SubscriptionPlanModel(
    id: "dummy-plan-2",
    name: "Professional",
    monthlyPrice: 999,
    description: "Best for growing companies",
    recommended: true,
    active: true,
    features: [
      "Unlimited Auctions",
      "Priority Notifications",
      "Negotiation Access",
      "Reports",
    ],
  ),
  SubscriptionPlanModel(
    id: "dummy-plan-3",
    name: "Enterprise",
    monthlyPrice: 1999,
    description: "For large logistics organizations",
    recommended: false,
    active: true,
    features: [
      "Unlimited Everything",
      "Dedicated Support",
      "Advanced Reports",
      "Multi Branch",
      "Analytics",
    ],
  ),
];