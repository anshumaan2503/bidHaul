import '../models/active_delivery.dart';

final List<ActiveDelivery> dummyActiveDeliveries = [
  const ActiveDelivery(
    id: "TN-2001",
    company: "ABC Logistics",
    origin: "Delhi",
    destination: "Mumbai",
    vehicleType: "Container Truck",
    amount: 42000,
    pickupDate: "12 Aug 2026",
    expectedDelivery: "15 Aug 2026",
    status: "In Transit",
  ),
  const ActiveDelivery(
    id: "TN-2002",
    company: "BlueLine Cargo",
    origin: "Pune",
    destination: "Hyderabad",
    vehicleType: "Trailer",
    amount: 36500,
    pickupDate: "14 Aug 2026",
    expectedDelivery: "16 Aug 2026",
    status: "Ready for Pickup",
  ),
  const ActiveDelivery(
    id: "TN-2003",
    company: "SpeedX Logistics",
    origin: "Ahmedabad",
    destination: "Jaipur",
    vehicleType: "Open Body",
    amount: 28750,
    pickupDate: "16 Aug 2026",
    expectedDelivery: "18 Aug 2026",
    status: "Delayed",
  ),
];