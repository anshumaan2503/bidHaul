enum TenderStatus {
  draft,
  live,
  completed,
  cancelled,
}

class Tender {
  final String id;

  final String title;

  final String description;

  final String pickupLocation;

  final String deliveryLocation;

  final String materialType;

  final String vehicleType;

  final String weight;

  final String budget;

  final TenderStatus status;

  const Tender({
    required this.id,
    required this.title,
    required this.description,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.materialType,
    required this.vehicleType,
    required this.weight,
    required this.budget,
    required this.status,
  });
}