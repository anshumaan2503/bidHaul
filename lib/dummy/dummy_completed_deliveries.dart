import '../models/completed_delivery.dart';

final List<CompletedDelivery> dummyCompletedDeliveries = [
  const CompletedDelivery(
    id: "TN-3001",
    company: "ABC Logistics",
    origin: "Delhi",
    destination: "Mumbai",
    vehicleType: "Container Truck",
    amount: 42000,
    deliveredOn: "15 Aug 2026",
    completedOn: "16 Aug 2026",
    rating: "★★★★★",
  ),
  const CompletedDelivery(
    id: "TN-3002",
    company: "BlueLine Cargo",
    origin: "Pune",
    destination: "Hyderabad",
    vehicleType: "Trailer",
    amount: 36500,
    deliveredOn: "18 Aug 2026",
    completedOn: "18 Aug 2026",
    rating: "★★★★☆",
  ),
  const CompletedDelivery(
    id: "TN-3003",
    company: "SpeedX Logistics",
    origin: "Ahmedabad",
    destination: "Jaipur",
    vehicleType: "Open Body",
    amount: 28800,
    deliveredOn: "20 Aug 2026",
    completedOn: "21 Aug 2026",
    rating: "★★★★★",
  ),
];