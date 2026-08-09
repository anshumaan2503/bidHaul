import '../models/qualified_bidder.dart';

final List<QualifiedBidder> dummyQualifiedBidders = [
  const QualifiedBidder(
    rank: 1,
    transporterName: "ABC Logistics",
    bidAmount: 42000,
    vehicleType: "Container",
    status: "Qualified",
  ),
  const QualifiedBidder(
    rank: 2,
    transporterName: "BlueLine Cargo",
    bidAmount: 42500,
    vehicleType: "Container",
    status: "Qualified",
  ),
  const QualifiedBidder(
    rank: 3,
    transporterName: "SpeedX Logistics",
    bidAmount: 43000,
    vehicleType: "Container",
    status: "Qualified",
  ),
  const QualifiedBidder(
    rank: 4,
    transporterName: "Rapid Movers",
    bidAmount: 43500,
    vehicleType: "Container",
    status: "Qualified",
  ),
  const QualifiedBidder(
    rank: 5,
    transporterName: "Fast Freight",
    bidAmount: 43800,
    vehicleType: "Container",
    status: "Qualified",
  ),
];