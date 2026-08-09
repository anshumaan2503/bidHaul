// ignore_for_file: constant_identifier_names

enum ContractStatus {
  PENDING_ACCEPTANCE,
  ACCEPTED,
}

class ContractModel {
  final String id;
  final String contractNumber;
  final String tenderId;
  final String bidId;
  final String negotiationId;
  final String companyId;
  final String transporterId;
  final double finalAmount;
  final String terms;
  final String status;
  final String? acceptedBy;
  final DateTime? acceptedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ContractModel({
    required this.id,
    required this.contractNumber,
    required this.tenderId,
    required this.bidId,
    required this.negotiationId,
    required this.companyId,
    required this.transporterId,
    required this.finalAmount,
    required this.terms,
    required this.status,
    this.acceptedBy,
    this.acceptedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] as String? ?? '',
      contractNumber: json['contractNumber'] as String? ?? '',
      tenderId: json['tenderId'] as String? ?? '',
      bidId: json['bidId'] as String? ?? '',
      negotiationId: json['negotiationId'] as String? ?? '',
      companyId: json['companyId'] as String? ?? '',
      transporterId: json['transporterId'] as String? ?? '',
      finalAmount: (json['finalAmount'] as num?)?.toDouble() ?? 0.0,
      terms: json['terms'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING_ACCEPTANCE',
      acceptedBy: json['acceptedBy'] as String?,
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.tryParse(json['acceptedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contractNumber': contractNumber,
      'tenderId': tenderId,
      'bidId': bidId,
      'negotiationId': negotiationId,
      'companyId': companyId,
      'transporterId': transporterId,
      'finalAmount': finalAmount,
      'terms': terms,
      'status': status,
      'acceptedBy': acceptedBy,
      'acceptedAt': acceptedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  bool get isPendingAcceptance => status.toUpperCase() == 'PENDING_ACCEPTANCE';
  bool get isAccepted => status.toUpperCase() == 'ACCEPTED';
}

class AcceptContractRequest {
  final bool accepted;

  const AcceptContractRequest({
    this.accepted = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'accepted': accepted,
    };
  }
}
