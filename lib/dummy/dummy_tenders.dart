import '../models/tender.dart';

const List<Tender> dummyTenders = [

  Tender(
    id: "245",
    title: "Steel Rod Transportation",
    description: "Transport steel rods safely.",
    pickupLocation: "Delhi",
    deliveryLocation: "Mumbai",
    materialType: "Steel",
    vehicleType: "Trailer",
    weight: "25 Tons",
    budget: "₹45,000",
    status: TenderStatus.live,
  ),

  Tender(
    id: "241",
    title: "Cement Bags",
    description: "Deliver cement bags.",
    pickupLocation: "Pune",
    deliveryLocation: "Surat",
    materialType: "Cement",
    vehicleType: "Truck",
    weight: "18 Tons",
    budget: "₹28,000",
    status: TenderStatus.completed,
  ),

  Tender(
    id: "238",
    title: "Furniture Shipment",
    description: "Office furniture transport.",
    pickupLocation: "Indore",
    deliveryLocation: "Jaipur",
    materialType: "Furniture",
    vehicleType: "Container",
    weight: "12 Tons",
    budget: "₹18,000",
    status: TenderStatus.draft,
  ),

];