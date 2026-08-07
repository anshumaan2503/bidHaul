import '../models/accepted_contract.dart';

final List<AcceptedContract> dummyAcceptedContracts = [
  const AcceptedContract(
    id: "TN-4001",
    company: "ABC Logistics",
    origin: "Delhi",
    destination: "Mumbai",
    vehicleType: "Container Truck",
    contractAmount: 42000,
    pickupDate: "15 Aug 2026",
    acceptedOn: "12 Aug 2026",
    status: "Ready For Pickup",
  ),
  const AcceptedContract(
    id: "TN-4002",
    company: "BlueLine Cargo",
    origin: "Pune",
    destination: "Hyderabad",
    vehicleType: "Trailer",
    contractAmount: 36500,
    pickupDate: "18 Aug 2026",
    acceptedOn: "14 Aug 2026",
    status: "Assigned",
  ),
  const AcceptedContract(
    id: "TN-4003",
    company: "SpeedX Logistics",
    origin: "Ahmedabad",
    destination: "Jaipur",
    vehicleType: "Open Body",
    contractAmount: 28900,
    pickupDate: "20 Aug 2026",
    acceptedOn: "16 Aug 2026",
    status: "Ready For Pickup",
  ),
];