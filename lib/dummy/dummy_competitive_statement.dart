import '../models/competitive_bid.dart';

final List<CompetitiveBid> dummyCompetitiveStatement = [
  const CompetitiveBid(
    rank: 1,
    transporter: "ABC Logistics",
    initialBid: 42000,
    negotiatedBid: 41500,
    winner: true,
  ),
  const CompetitiveBid(
    rank: 2,
    transporter: "BlueLine Cargo",
    initialBid: 42500,
    negotiatedBid: 41900,
    winner: false,
  ),
  const CompetitiveBid(
    rank: 3,
    transporter: "SpeedX Logistics",
    initialBid: 43000,
    negotiatedBid: 42400,
    winner: false,
  ),
  const CompetitiveBid(
    rank: 4,
    transporter: "Rapid Movers",
    initialBid: 43400,
    negotiatedBid: 42800,
    winner: false,
  ),
  const CompetitiveBid(
    rank: 5,
    transporter: "Fast Freight",
    initialBid: 43800,
    negotiatedBid: 43200,
    winner: false,
  ),
];