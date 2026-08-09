import 'package:bidhaul/models/invoice.dart';
import 'package:bidhaul/models/subscription_plan.dart';
import 'package:bidhaul/models/user_subscription.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Part 6 — Subscription & Invoice Models Unit Tests', () {
    test('SubscriptionPlanModel parses SubscriptionPlanResponseDto correctly', () {
      final json = {
        'id': '11111111-1111-1111-1111-111111111111',
        'name': 'Enterprise Freight Plan',
        'monthlyPrice': 4999.00,
        'description': 'Unlimited bidding and custom analytics',
        'features': '["Unlimited Bids", "Priority Logistics Support", "Custom Analytics"]',
        'recommended': true,
        'active': true,
        'createdAt': '2026-08-08T10:00:00Z',
        'updatedAt': '2026-08-08T10:00:00Z',
      };

      final plan = SubscriptionPlanModel.fromJson(json);

      expect(plan.id, '11111111-1111-1111-1111-111111111111');
      expect(plan.name, 'Enterprise Freight Plan');
      expect(plan.monthlyPrice, 4999.00);
      expect(plan.features.length, 3);
      expect(plan.features[0], 'Unlimited Bids');
      expect(plan.recommended, isTrue);
      expect(plan.active, isTrue);
    });

    test('CreateSubscriptionPlanRequest serializes JSON correctly', () {
      final req = CreateSubscriptionPlanRequest(
        name: 'Starter Logistics',
        monthlyPrice: 1499.0,
        description: 'Ideal for small transport operators',
        features: ['10 Active Bids', 'Basic Support'],
        recommended: false,
      );

      final json = req.toJson();

      expect(json['name'], 'Starter Logistics');
      expect(json['monthlyPrice'], 1499.0);
      expect(json['recommended'], isFalse);
    });

    test('UserSubscriptionModel parses UserSubscriptionResponseDto correctly', () {
      final json = {
        'id': '22222222-2222-2222-2222-222222222222',
        'userId': '33333333-3333-3333-3333-333333333333',
        'planId': '11111111-1111-1111-1111-111111111111',
        'planName': 'Enterprise Freight Plan',
        'monthlyPrice': 4999.00,
        'priceAtSubscription': 4999.00,
        'description': 'Unlimited bidding',
        'features': '["Unlimited Bids"]',
        'billingCycle': 'MONTHLY',
        'status': 'PENDING_PAYMENT',
        'startDate': null,
        'expiryDate': null,
        'remainingDays': 0,
        'createdAt': '2026-08-08T12:00:00Z',
      };

      final sub = UserSubscriptionModel.fromJson(json);

      expect(sub.id, '22222222-2222-2222-2222-222222222222');
      expect(sub.planName, 'Enterprise Freight Plan');
      expect(sub.billingCycle, 'MONTHLY');
      expect(sub.status, 'PENDING_PAYMENT');
      expect(sub.isPendingPayment, isTrue);
      expect(sub.isActive, isFalse);
    });

    test('SubscribeRequest serializes JSON correctly', () {
      final req = SubscribeRequest(
        planId: '11111111-1111-1111-1111-111111111111',
        billingCycle: 'ANNUAL',
      );

      final json = req.toJson();

      expect(json['planId'], '11111111-1111-1111-1111-111111111111');
      expect(json['billingCycle'], 'ANNUAL');
    });

    test('InvoiceModel parses InvoiceResponseDto correctly', () {
      final json = {
        'id': '44444444-4444-4444-4444-444444444444',
        'invoiceNumber': 'INV-2026-0089',
        'userId': '33333333-3333-3333-3333-333333333333',
        'subscriptionId': '22222222-2222-2222-2222-222222222222',
        'planName': 'Enterprise Freight Plan',
        'amount': 4999.00,
        'status': 'PENDING',
        'billingPeriod': 'Monthly Billing',
        'issuedAt': '2026-08-08T12:00:00Z',
        'dueAt': '2026-08-15T12:00:00Z',
        'paidAt': null,
      };

      final invoice = InvoiceModel.fromJson(json);

      expect(invoice.id, '44444444-4444-4444-4444-444444444444');
      expect(invoice.invoiceNo, 'INV-2026-0089');
      expect(invoice.amount, 4999.00);
      expect(invoice.status, 'PENDING');
      expect(invoice.isPending, isTrue);
      expect(invoice.isPaid, isFalse);
    });
  });
}
