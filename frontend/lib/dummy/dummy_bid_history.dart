import '../models/bid_history.dart';

final List<BidHistory> dummyBidHistory = [
  const BidHistory(
    tenderId: "TN-6201",
    company: "ABC Logistics",
    route: "Delhi → Mumbai",
    bidAmount: 42500,
    bidDate: "10 Aug 2026",
    status: "Won",
  ),
  const BidHistory(
    tenderId: "TN-6202",
    company: "BlueLine Cargo",
    route: "Pune → Hyderabad",
    bidAmount: 36500,
    bidDate: "12 Aug 2026",
    status: "Lost",
  ),
  const BidHistory(
    tenderId: "TN-6203",
    company: "SpeedX Logistics",
    route: "Jaipur → Ahmedabad",
    bidAmount: 28750,
    bidDate: "14 Aug 2026",
    status: "Cancelled",
  ),
];