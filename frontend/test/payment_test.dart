import 'package:bidhaul/models/payment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Part 7 — Payment Models Unit Tests', () {
    test('CreatePaymentOrderRequest serializes JSON correctly', () {
      final req = CreatePaymentOrderRequest(
        invoiceId: 'ba2f361b-d762-434e-bff0-ad8e1584465b',
      );

      final json = req.toJson();

      expect(json['invoiceId'], 'ba2f361b-d762-434e-bff0-ad8e1584465b');
    });

    test('PaymentOrderResponse parses PaymentOrderResponseDto correctly', () {
      final json = {
        'paymentId': '55555555-5555-5555-5555-555555555555',
        'invoiceId': 'ba2f361b-d762-434e-bff0-ad8e1584465b',
        'razorpayKeyId': 'rzp_test_key123',
        'razorpayOrderId': 'order_K1234567890',
        'amount': 999.00,
        'amountInPaise': 99900,
        'currency': 'INR',
        'status': 'CREATED',
      };

      final res = PaymentOrderResponse.fromJson(json);

      expect(res.paymentId, '55555555-5555-5555-5555-555555555555');
      expect(res.invoiceId, 'ba2f361b-d762-434e-bff0-ad8e1584465b');
      expect(res.razorpayKeyId, 'rzp_test_key123');
      expect(res.razorpayOrderId, 'order_K1234567890');
      expect(res.amount, 999.00);
      expect(res.amountInPaise, 99900);
      expect(res.currency, 'INR');
      expect(res.status, 'CREATED');
    });

    test('VerifyPaymentRequest serializes JSON correctly', () {
      final req = VerifyPaymentRequest(
        invoiceId: 'ba2f361b-d762-434e-bff0-ad8e1584465b',
        razorpayOrderId: 'order_K1234567890',
        razorpayPaymentId: 'pay_L0987654321',
        razorpaySignature: '38a4b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5',
      );

      final json = req.toJson();

      expect(json['invoiceId'], 'ba2f361b-d762-434e-bff0-ad8e1584465b');
      expect(json['razorpayOrderId'], 'order_K1234567890');
      expect(json['razorpayPaymentId'], 'pay_L0987654321');
      expect(json['razorpaySignature'], '38a4b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5');
    });

    test('PaymentResponse parses PaymentResponseDto correctly', () {
      final json = {
        'paymentId': '55555555-5555-5555-5555-555555555555',
        'invoiceId': 'ba2f361b-d762-434e-bff0-ad8e1584465b',
        'razorpayOrderId': 'order_K1234567890',
        'razorpayPaymentId': 'pay_L0987654321',
        'amount': 999.00,
        'currency': 'INR',
        'status': 'CAPTURED',
        'signatureVerified': true,
        'capturedAt': '2026-08-08T17:00:00Z',
      };

      final res = PaymentResponse.fromJson(json);

      expect(res.paymentId, '55555555-5555-5555-5555-555555555555');
      expect(res.invoiceId, 'ba2f361b-d762-434e-bff0-ad8e1584465b');
      expect(res.razorpayOrderId, 'order_K1234567890');
      expect(res.razorpayPaymentId, 'pay_L0987654321');
      expect(res.amount, 999.00);
      expect(res.status, 'CAPTURED');
      expect(res.signatureVerified, isTrue);
      expect(res.isCaptured, isTrue);
    });
  });
}
