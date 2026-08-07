import '../models/admin_tender.dart';

final List<AdminTender> dummyAdminTenders = [
  const AdminTender(
    id: 1,
    title: "Delhi → Mumbai Containers",
    company: "ABC Logistics",
    route: "Delhi - Mumbai",
    bids: 18,
    status: "Live",
  ),
  const AdminTender(
    id: 2,
    title: "Hyderabad → Pune Steel",
    company: "Fast Freight",
    route: "Hyderabad - Pune",
    bids: 27,
    status: "Completed",
  ),
  const AdminTender(
    id: 3,
    title: "Jaipur → Ahmedabad Cement",
    company: "CargoMax",
    route: "Jaipur - Ahmedabad",
    bids: 5,
    status: "Cancelled",
  ),
];
