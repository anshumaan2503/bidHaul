import '../models/transporter.dart';

final List<Transporter> dummyTransporters = [
  TransporterProfileModel(
    id: "TR-101",
    userId: "usr-101",
    companyName: "ABC Logistics",
    ownerName: "Rahul Sharma",
    phone: "+91 9876543210",
    completedDeliveries: 182,
    rating: 4.8,
    verificationStatus: "VERIFIED",
  ),
  TransporterProfileModel(
    id: "TR-102",
    userId: "usr-102",
    companyName: "BlueLine Cargo",
    ownerName: "Amit Patel",
    phone: "+91 9898989898",
    completedDeliveries: 141,
    rating: 4.6,
    verificationStatus: "VERIFIED",
  ),
  TransporterProfileModel(
    id: "TR-103",
    userId: "usr-103",
    companyName: "SpeedX Logistics",
    ownerName: "Rohit Singh",
    phone: "+91 9123456789",
    completedDeliveries: 67,
    rating: 4.2,
    verificationStatus: "PENDING",
  ),
];