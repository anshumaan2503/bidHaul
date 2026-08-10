// ignore_for_file: constant_identifier_names

enum NegotiationStatus {
  OPEN,
  ACCEPTED,
  REJECTED,
  CANCELLED,
}

class NegotiationOfferModel {
  final String id;
  final String offeredBy;
  final String offeredByName;
  final double amount;
  final String remarks;
  final DateTime? createdAt;

  const NegotiationOfferModel({
    required this.id,
    required this.offeredBy,
    required this.offeredByName,
    required this.amount,
    required this.remarks,
    this.createdAt,
  });

  factory NegotiationOfferModel.fromJson(Map<String, dynamic> json) {
    return NegotiationOfferModel(
      id: json['id'] as String? ?? '',
      offeredBy: json['offeredBy'] as String? ?? '',
      offeredByName: json['offeredByName'] as String? ?? 'Unknown Participant',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      remarks: json['remarks'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offeredBy': offeredBy,
      'offeredByName': offeredByName,
      'amount': amount,
      'remarks': remarks,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class NegotiationModel {
  final String id;
  final String tenderId;
  final String bidId;
  final String companyId;
  final String transporterId;
  final String status;
  final double? currentAmount;
  final String? lastOfferedBy;
  final double? finalAmount;
  final String? acceptedBy;
  final DateTime? closedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<NegotiationOfferModel> offers;

  const NegotiationModel({
    required this.id,
    required this.tenderId,
    required this.bidId,
    required this.companyId,
    required this.transporterId,
    required this.status,
    this.currentAmount,
    this.lastOfferedBy,
    this.finalAmount,
    this.acceptedBy,
    this.closedAt,
    this.createdAt,
    this.updatedAt,
    this.offers = const [],
  });

  factory NegotiationModel.fromJson(Map<String, dynamic> json) {
    var rawOffers = json['offers'] as List<dynamic>? ?? [];
    List<NegotiationOfferModel> offerList = rawOffers
        .map((e) => NegotiationOfferModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return NegotiationModel(
      id: json['id'] as String? ?? '',
      tenderId: json['tenderId'] as String? ?? '',
      bidId: json['bidId'] as String? ?? '',
      companyId: json['companyId'] as String? ?? '',
      transporterId: json['transporterId'] as String? ?? '',
      status: json['status'] as String? ?? 'OPEN',
      currentAmount: (json['currentAmount'] as num?)?.toDouble(),
      lastOfferedBy: json['lastOfferedBy'] as String?,
      finalAmount: (json['finalAmount'] as num?)?.toDouble(),
      acceptedBy: json['acceptedBy'] as String?,
      closedAt: json['closedAt'] != null
          ? DateTime.tryParse(json['closedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      offers: offerList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenderId': tenderId,
      'bidId': bidId,
      'companyId': companyId,
      'transporterId': transporterId,
      'status': status,
      'currentAmount': currentAmount,
      'lastOfferedBy': lastOfferedBy,
      'finalAmount': finalAmount,
      'acceptedBy': acceptedBy,
      'closedAt': closedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'offers': offers.map((e) => e.toJson()).toList(),
    };
  }

  bool get isOpen =>
      status.toUpperCase() == 'OPEN' ||
      status.toUpperCase() == 'COUNTER_OFFERED' ||
      status.toUpperCase() == 'IN_PROGRESS';
  bool get isAccepted => status.toUpperCase() == 'ACCEPTED';
  bool get isRejected => status.toUpperCase() == 'REJECTED';
}

class CreateNegotiationRequest {
  final String bidId;
  final String? remarks;

  const CreateNegotiationRequest({
    required this.bidId,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'bidId': bidId,
    };
    if (remarks != null && remarks!.isNotEmpty) {
      map['remarks'] = remarks;
    }
    return map;
  }
}

class CreateNegotiationOfferRequest {
  final double amount;
  final String remarks;

  const CreateNegotiationOfferRequest({
    required this.amount,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'remarks': remarks,
    };
  }
}
