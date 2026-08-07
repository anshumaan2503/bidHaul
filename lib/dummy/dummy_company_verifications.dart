import '../models/company_verification.dart';

final List<CompanyVerification> dummyCompanyVerifications = [
  const CompanyVerification(
    id: 1,
    companyName: "ABC Logistics Pvt Ltd",
    ownerName: "Rahul Sharma",
    email: "abc@gmail.com",
    phone: "+91 9876543210",
    address: "Delhi, India",
    gstNumber: "07ABCDE1234F1Z5",
    licenseNumber: "LIC123456",
    registrationDate: "01 Aug 2026",
    status: "Pending",
  ),
  const CompanyVerification(
    id: 2,
    companyName: "Speed Cargo Ltd",
    ownerName: "Amit Verma",
    email: "speed@gmail.com",
    phone: "+91 9988776655",
    address: "Mumbai, India",
    gstNumber: "27ABCDE9876F1Z2",
    licenseNumber: "LIC654321",
    registrationDate: "03 Aug 2026",
    status: "Pending",
  ),
];
