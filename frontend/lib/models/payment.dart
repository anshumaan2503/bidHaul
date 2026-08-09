class CreatePaymentOrderRequest {
  final String invoiceId;

  CreatePaymentOrderRequest({
    required this.invoiceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'invoiceId': invoiceId,
    };
  }
}

class PaymentOrderResponse {
  final String paymentId;
  final String invoiceId;
  final String razorpayKeyId;
  final String razorpayOrderId;
  final double amount;
  final int amountInPaise;
  final String currency;
  final String status;

  PaymentOrderResponse({
    required this.paymentId,
    required this.invoiceId,
    required this.razorpayKeyId,
    required this.razorpayOrderId,
    required this.amount,
    required this.amountInPaise,
    required this.currency,
    required this.status,
  });

  factory PaymentOrderResponse.fromJson(Map<String, dynamic> json) {
    return PaymentOrderResponse(
      paymentId: json['paymentId']?.toString() ?? '',
      invoiceId: json['invoiceId']?.toString() ?? '',
      razorpayKeyId: json['razorpayKeyId']?.toString() ?? '',
      razorpayOrderId: json['razorpayOrderId']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      amountInPaise: (json['amountInPaise'] as num?)?.toInt() ?? 0,
      currency: json['currency']?.toString() ?? 'INR',
      status: json['status']?.toString() ?? 'CREATED',
    );
  }
}

class VerifyPaymentRequest {
  final String invoiceId;
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;

  VerifyPaymentRequest({
    required this.invoiceId,
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
  });

  Map<String, dynamic> toJson() {
    return {
      'invoiceId': invoiceId,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
      'razorpaySignature': razorpaySignature,
    };
  }
}

class PaymentResponse {
  final String paymentId;
  final String invoiceId;
  final String razorpayOrderId;
  final String? razorpayPaymentId;
  final double amount;
  final String currency;
  final String status;
  final bool signatureVerified;
  final String? capturedAt;

  PaymentResponse({
    required this.paymentId,
    required this.invoiceId,
    required this.razorpayOrderId,
    this.razorpayPaymentId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.signatureVerified,
    this.capturedAt,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      paymentId: json['paymentId']?.toString() ?? '',
      invoiceId: json['invoiceId']?.toString() ?? '',
      razorpayOrderId: json['razorpayOrderId']?.toString() ?? '',
      razorpayPaymentId: json['razorpayPaymentId']?.toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'INR',
      status: json['status']?.toString() ?? 'FAILED',
      signatureVerified: json['signatureVerified'] == true,
      capturedAt: json['capturedAt']?.toString(),
    );
  }

  bool get isCaptured => status.toUpperCase() == 'CAPTURED';
}
