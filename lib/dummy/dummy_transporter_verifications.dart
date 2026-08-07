import '../models/transporter_verification.dart';

final List<TransporterVerification> dummyTransporterVerifications = [
  const TransporterVerification(
    id: 1,
    transporterName: "ABC Logistics",
    ownerName: "Rahul Sharma",
    email: "abc@gmail.com",
    phone: "+91 9876543210",
    vehicleType: "Container",
    fleetSize: "45",
    licenseNumber: "TRP-1001",
    registrationDate: "02 Aug 2026",
    status: "Pending",
  ),
  const TransporterVerification(
    id: 2,
    transporterName: "Fast Freight",
    ownerName: "Amit Verma",
    email: "fast@gmail.com",
    phone: "+91 9988776655",
    vehicleType: "Trailer",
    fleetSize: "28",
    licenseNumber: "TRP-1002",
    registrationDate: "03 Aug 2026",
    status: "Pending",
  ),
];
