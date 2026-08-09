import 'package:bidhaul/models/delivery.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Part 5 — Delivery & Tracking Models Unit Tests', () {
    test('DeliveryModel parses DeliveryResponseDto correctly', () {
      final json = {
        'id': 'del-123456',
        'contractId': 'cnt-7890',
        'tenderId': 'tnd-1111',
        'companyId': 'comp-2222',
        'transporterId': 'trans-3333',
        'pickupLocation': 'Mumbai Central Warehouse',
        'deliveryLocation': 'Delhi Logistics Hub',
        'status': 'PENDING_PICKUP',
        'pickedUpAt': '2026-08-08T10:00:00Z',
        'deliveredAt': null,
        'confirmedAt': null,
        'rating': 4.5,
        'createdAt': '2026-08-08T09:00:00Z',
        'updatedAt': '2026-08-08T09:00:00Z',
      };

      final delivery = DeliveryModel.fromJson(json);

      expect(delivery.id, 'del-123456');
      expect(delivery.contractId, 'cnt-7890');
      expect(delivery.tenderId, 'tnd-1111');
      expect(delivery.companyId, 'comp-2222');
      expect(delivery.transporterId, 'trans-3333');
      expect(delivery.pickupLocation, 'Mumbai Central Warehouse');
      expect(delivery.deliveryLocation, 'Delhi Logistics Hub');
      expect(delivery.status, 'PENDING_PICKUP');
      expect(delivery.isPendingPickup, isTrue);
      expect(delivery.isInTransit, isFalse);
      expect(delivery.rating, 4.5);
    });

    test('TrackingEventModel parses TrackingEventResponseDto correctly', () {
      final json = {
        'id': 'event-999',
        'deliveryId': 'del-123456',
        'status': 'IN_TRANSIT',
        'location': 'Surat Checkpoint',
        'remarks': 'Shipment passed toll plaza',
        'createdAt': '2026-08-08T12:00:00Z',
      };

      final event = TrackingEventModel.fromJson(json);

      expect(event.id, 'event-999');
      expect(event.deliveryId, 'del-123456');
      expect(event.status, 'IN_TRANSIT');
      expect(event.location, 'Surat Checkpoint');
      expect(event.remarks, 'Shipment passed toll plaza');
    });

    test('AddTrackingUpdateRequest serializes JSON correctly', () {
      const request = AddTrackingUpdateRequest(
        location: 'Vadodara Hub ',
        remarks: ' Refueled truck ',
      );

      final json = request.toJson();

      expect(json['location'], 'Vadodara Hub');
      expect(json['remarks'], 'Refueled truck');
    });

    test('RateDeliveryRequest serializes JSON correctly', () {
      const request = RateDeliveryRequest(rating: 4.8);

      final json = request.toJson();

      expect(json['rating'], 4.8);
    });
  });
}
