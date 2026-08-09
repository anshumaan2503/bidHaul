import '../models/bid.dart';

final List<BidModel> dummyBids = [
  BidModel(
    id: "B101",
    bidNumber: "BID-101",
    tenderId: "245",
    transporterName: "ABC Transport",
    amount: 42000.0,
    estimatedDays: 4,
    remarks: "Safe and Fast Delivery",
    status: "PENDING",
  ),
  BidModel(
    id: "B102",
    bidNumber: "BID-102",
    tenderId: "245",
    transporterName: "Express Logistics",
    amount: 43500.0,
    estimatedDays: 3,
    remarks: "GPS Enabled Fleet",
    status: "PENDING",
  ),
  BidModel(
    id: "B103",
    bidNumber: "BID-103",
    tenderId: "241",
    transporterName: "Fast Movers",
    amount: 39000.0,
    estimatedDays: 5,
    remarks: "Experienced Drivers",
    status: "ACCEPTED",
  ),
];