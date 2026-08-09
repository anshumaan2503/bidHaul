// ignore_for_file: constant_identifier_names

typedef Bid = BidModel;

enum BidStatus {
  PENDING,
  ACCEPTED,
  REJECTED,
}

class BidModel {
  final String id;
  final String bidNumber;
  final String tenderId;
  final String transporterName;
  final double amount;
  final int estimatedDays;
  final String remarks;
  final String status;
  final String? createdAt;

  BidModel({
    required this.id,
    required this.bidNumber,
    required this.tenderId,
    required this.transporterName,
    required this.amount,
    required this.estimatedDays,
    required this.remarks,
    required this.status,
    this.createdAt,
  });

  // Backward compatible getters
  String get amountFormatted => '₹${amount.toStringAsFixed(0)}';
  bool get isPending => status.toUpperCase() == 'PENDING';
  bool get isAccepted => status.toUpperCase() == 'ACCEPTED';
  bool get isRejected => status.toUpperCase() == 'REJECTED';

  BidStatus get statusEnum {
    switch (status.toUpperCase()) {
      case 'ACCEPTED':
        return BidStatus.ACCEPTED;
      case 'REJECTED':
        return BidStatus.REJECTED;
      default:
        return BidStatus.PENDING;
    }
  }

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['id']?.toString() ?? '',
      bidNumber: json['bidNumber']?.toString() ?? '',
      tenderId: json['tenderId']?.toString() ?? '',
      transporterName: json['transporterName']?.toString() ?? 'Transporter',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      estimatedDays: (json['estimatedDays'] as num?)?.toInt() ?? 1,
      remarks: json['remarks']?.toString() ?? '',
      status: json['status']?.toString() ?? 'PENDING',
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bidNumber': bidNumber,
      'tenderId': tenderId,
      'transporterName': transporterName,
      'amount': amount,
      'estimatedDays': estimatedDays,
      'remarks': remarks,
      'status': status,
      'createdAt': createdAt,
    };
  }
}

class CreateBidRequest {
  final double amount;
  final int estimatedDays;
  final String remarks;

  CreateBidRequest({
    required this.amount,
    required this.estimatedDays,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'estimatedDays': estimatedDays,
      'remarks': remarks.trim(),
    };
  }
}