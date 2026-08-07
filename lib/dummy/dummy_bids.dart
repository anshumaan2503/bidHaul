import '../models/bid.dart';

const dummyBids = [

  Bid(
    id: "B101",
    tenderId: "245",
    transporterName: "ABC Transport",
    amount: "₹42,000",
    estimatedDays: "4 Days",
    remarks: "Safe and Fast Delivery",
    status: BidStatus.pending,
  ),

  Bid(
    id: "B102",
    tenderId: "245",
    transporterName: "Express Logistics",
    amount: "₹43,500",
    estimatedDays: "3 Days",
    remarks: "GPS Enabled Fleet",
    status: BidStatus.pending,
  ),

  Bid(
    id: "B103",
    tenderId: "241",
    transporterName: "Fast Movers",
    amount: "₹39,000",
    estimatedDays: "5 Days",
    remarks: "Experienced Drivers",
    status: BidStatus.accepted,
  ),

];