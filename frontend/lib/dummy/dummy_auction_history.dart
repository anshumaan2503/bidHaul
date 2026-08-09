import '../models/auction_history.dart';

final List<AuctionHistory> dummyAuctionHistory = [
  const AuctionHistory(
    tenderId: "TN-5101",
    route: "Delhi → Mumbai",
    vehicleType: "Container",
    finalAmount: 42500,
    winner: "ABC Logistics",
    closedDate: "12 Aug 2026",
    status: "Completed",
  ),
  const AuctionHistory(
    tenderId: "TN-5102",
    route: "Pune → Hyderabad",
    vehicleType: "Trailer",
    finalAmount: 36800,
    winner: "BlueLine Cargo",
    closedDate: "14 Aug 2026",
    status: "Completed",
  ),
  const AuctionHistory(
    tenderId: "TN-5103",
    route: "Jaipur → Ahmedabad",
    vehicleType: "Open Body",
    finalAmount: 28900,
    winner: "SpeedX Logistics",
    closedDate: "17 Aug 2026",
    status: "Cancelled",
  ),
];