import '../models/transporter.dart';

final List<TransporterProfileModel> dummyTransporterVerifications = [
  TransporterProfileModel(
    id: "trans_1",
    userId: "usr_3",
    companyName: "ABC Logistics",
    ownerName: "Rahul Sharma",
    email: "abc@gmail.com",
    phone: "+91 9876543210",
    vehicleType: "Container",
    fleetSize: 45,
    licenseNumber: "TRP-1001",
    submittedAt: "02 Aug 2026",
    verificationStatus: "SUBMITTED",
  ),
  TransporterProfileModel(
    id: "trans_2",
    userId: "usr_4",
    companyName: "Fast Freight",
    ownerName: "Amit Verma",
    email: "fast@gmail.com",
    phone: "+91 9988776655",
    vehicleType: "Trailer",
    fleetSize: 28,
    licenseNumber: "TRP-1002",
    submittedAt: "03 Aug 2026",
    verificationStatus: "SUBMITTED",
  ),
];
