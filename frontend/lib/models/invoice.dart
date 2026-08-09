class InvoiceModel {
  final String id;
  final String invoiceNo;
  final String userId;
  final String subscriptionId;
  final String planName;
  final double amount;
  final String status; // PENDING, PAID, FAILED, CANCELLED
  final String? billingPeriod;
  final String? date; // issuedAt
  final String? dueDate; // dueAt
  final String? paidAt;
  final String? paymentOrderReference;
  final String? paymentReference;
  final String? createdAt;
  final String? updatedAt;

  InvoiceModel({
    required this.id,
    required this.invoiceNo,
    required this.userId,
    required this.subscriptionId,
    required this.planName,
    required this.amount,
    required this.status,
    this.billingPeriod,
    this.date,
    this.dueDate,
    this.paidAt,
    this.paymentOrderReference,
    this.paymentReference,
    this.createdAt,
    this.updatedAt,
  });

  bool get isPending => status.toUpperCase() == 'PENDING';
  bool get isPaid => status.toUpperCase() == 'PAID';
  bool get isFailed => status.toUpperCase() == 'FAILED';
  bool get isCancelled => status.toUpperCase() == 'CANCELLED';

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id']?.toString() ?? '',
      invoiceNo: json['invoiceNo']?.toString() ?? json['invoiceNumber']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      subscriptionId: json['subscriptionId']?.toString() ?? '',
      planName: json['planName']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'PENDING',
      billingPeriod: json['billingPeriod']?.toString(),
      date: json['date']?.toString() ?? json['issuedAt']?.toString(),
      dueDate: json['dueDate']?.toString() ?? json['dueAt']?.toString(),
      paidAt: json['paidAt']?.toString(),
      paymentOrderReference: json['paymentOrderReference']?.toString(),
      paymentReference: json['paymentReference']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceNo': invoiceNo,
      'userId': userId,
      'subscriptionId': subscriptionId,
      'planName': planName,
      'amount': amount,
      'status': status,
      'billingPeriod': billingPeriod,
      'date': date,
      'dueDate': dueDate,
      'paidAt': paidAt,
      'paymentOrderReference': paymentOrderReference,
      'paymentReference': paymentReference,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}