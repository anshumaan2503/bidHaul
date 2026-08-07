import '../models/transporter.dart';

final List<Transporter> dummyTransporters = [
  const Transporter(
    id: "TR-101",
    companyName: "ABC Logistics",
    ownerName: "Rahul Sharma",
    phone: "+91 9876543210",
    completedDeliveries: 182,
    rating: 4.8,
    status: "Active",
  ),
  const Transporter(
    id: "TR-102",
    companyName: "BlueLine Cargo",
    ownerName: "Amit Patel",
    phone: "+91 9898989898",
    completedDeliveries: 141,
    rating: 4.6,
    status: "Active",
  ),
  const Transporter(
    id: "TR-103",
    companyName: "SpeedX Logistics",
    ownerName: "Rohit Singh",
    phone: "+91 9123456789",
    completedDeliveries: 67,
    rating: 4.2,
    status: "Inactive",
  ),
];