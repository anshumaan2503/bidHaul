import '../models/user_subscription.dart';

final dummyActiveSubscription = UserSubscriptionModel(
  id: "dummy-sub-id",
  userId: "dummy-user-id",
  planId: "dummy-plan-id",
  planName: "Professional",
  monthlyPrice: 999,
  priceAtSubscription: 999,
  description: "Best for growing companies",
  features: ["Unlimited Auctions", "Priority Support"],
  billingCycle: "MONTHLY",
  status: "ACTIVE",
  startDate: "2026-08-01T00:00:00Z",
  expiryDate: "2026-08-31T00:00:00Z",
  remainingDays: 24,
);