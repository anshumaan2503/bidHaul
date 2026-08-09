import 'package:flutter_test/flutter_test.dart';
import 'package:bidhaul/models/notification.dart';

void main() {
  group('Part 8 — Notification Model Unit Tests', () {
    test('NotificationModel.fromJson parses backend NotificationResponseDto correctly', () {
      final json = {
        'id': 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
        'type': 'PAYMENT',
        'title': 'Payment successful',
        'message': 'Your payment of ₹999.0 was successfully captured.',
        'read': false,
        'readAt': null,
        'referenceType': 'PAYMENT',
        'referenceId': 'f1e2d3c4-b5a6-9788-7766-554433221100',
        'createdAt': '2026-08-09T10:00:00.000Z',
        'updatedAt': '2026-08-09T10:00:00.000Z',
      };

      final model = NotificationModel.fromJson(json);

      expect(model.id, equals('a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d'));
      expect(model.type, equals(NotificationTypeEnum.PAYMENT));
      expect(model.title, equals('Payment successful'));
      expect(model.message, equals('Your payment of ₹999.0 was successfully captured.'));
      expect(model.read, isFalse);
      expect(model.readAt, isNull);
      expect(model.referenceType, equals('PAYMENT'));
      expect(model.referenceId, equals('f1e2d3c4-b5a6-9788-7766-554433221100'));
      expect(model.createdAt, isNotNull);
    });

    test('NotificationTypeEnum handles all backend types and fallback correctly', () {
      expect(NotificationTypeEnum.fromString('SYSTEM'), equals(NotificationTypeEnum.SYSTEM));
      expect(NotificationTypeEnum.fromString('TENDER'), equals(NotificationTypeEnum.TENDER));
      expect(NotificationTypeEnum.fromString('BID'), equals(NotificationTypeEnum.BID));
      expect(NotificationTypeEnum.fromString('NEGOTIATION'), equals(NotificationTypeEnum.NEGOTIATION));
      expect(NotificationTypeEnum.fromString('CONTRACT'), equals(NotificationTypeEnum.CONTRACT));
      expect(NotificationTypeEnum.fromString('DELIVERY'), equals(NotificationTypeEnum.DELIVERY));
      expect(NotificationTypeEnum.fromString('SUBSCRIPTION'), equals(NotificationTypeEnum.SUBSCRIPTION));
      expect(NotificationTypeEnum.fromString('INVOICE'), equals(NotificationTypeEnum.INVOICE));
      expect(NotificationTypeEnum.fromString('PAYMENT'), equals(NotificationTypeEnum.PAYMENT));
      expect(NotificationTypeEnum.fromString('NON_EXISTENT'), equals(NotificationTypeEnum.UNKNOWN));
      expect(NotificationTypeEnum.fromString(null), equals(NotificationTypeEnum.UNKNOWN));
    });

    test('NotificationModel copyWith updates read status correctly', () {
      const initial = NotificationModel(
        id: '123',
        type: NotificationTypeEnum.SYSTEM,
        title: 'Test',
        message: 'Message',
        read: false,
      );

      final updated = initial.copyWith(
        read: true,
        readAt: DateTime.parse('2026-08-09T10:05:00.000Z'),
      );

      expect(updated.read, isTrue);
      expect(updated.readAt, equals(DateTime.parse('2026-08-09T10:05:00.000Z')));
      expect(updated.id, equals('123'));
    });
  });
}
