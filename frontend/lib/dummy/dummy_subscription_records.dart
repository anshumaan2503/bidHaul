import '../models/subscription_record.dart';

final List<SubscriptionRecord> dummySubscriptionRecords = [
  const SubscriptionRecord(
    id: 1,
    userName: "ABC Logistics",
    userType: "Company",
    planName: "Professional",
    amount: 999,
    purchaseDate: "01 Aug 2026",
    expiryDate: "31 Aug 2026",
    status: "Active",
  ),
  const SubscriptionRecord(
    id: 2,
    userName: "Fast Freight",
    userType: "Transporter",
    planName: "Enterprise",
    amount: 1999,
    purchaseDate: "28 Jul 2026",
    expiryDate: "27 Aug 2026",
    status: "Active",
  ),
];
