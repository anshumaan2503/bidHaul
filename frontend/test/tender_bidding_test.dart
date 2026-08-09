import 'package:bidhaul/models/bid.dart';
import 'package:bidhaul/models/competitive_bid.dart';
import 'package:bidhaul/models/tender.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Part 3 — Tender & Bidding Models Unit Tests', () {
    test('TenderModel parses TenderResponseDto correctly', () {
      final json = {
        'id': '22911131-22b2-40fd-b065-b3134f24d1bc',
        'tenderNumber': 'TND-2026-001',
        'title': 'Bulk Cement Cargo',
        'description': 'Transport 20 tons of cement from Pune to Surat',
        'pickupLocation': 'Pune, MH',
        'deliveryLocation': 'Surat, GJ',
        'materialType': 'Cement',
        'vehicleType': '32ft Container',
        'weightTons': 20.0,
        'ceilingBudget': 50000.0,
        'status': 'LIVE',
        'createdAt': '2026-08-08T10:00:00Z',
        'updatedAt': '2026-08-08T10:00:00Z',
      };

      final tender = TenderModel.fromJson(json);

      expect(tender.id, equals('22911131-22b2-40fd-b065-b3134f24d1bc'));
      expect(tender.tenderNumber, equals('TND-2026-001'));
      expect(tender.title, equals('Bulk Cement Cargo'));
      expect(tender.weightTons, equals(20.0));
      expect(tender.ceilingBudget, equals(50000.0));
      expect(tender.status, equals('LIVE'));
      expect(tender.isLive, isTrue);
      expect(tender.budget, equals('₹50000'));
      expect(tender.weight, equals('20.0 Tons'));
    });

    test('CreateTenderRequest serializes JSON correctly', () {
      final req = CreateTenderRequest(
        title: 'Steel Rods Cargo',
        description: 'Transport 15 tons of steel rods',
        pickupLocation: 'Delhi',
        deliveryLocation: 'Mumbai',
        materialType: 'Steel',
        vehicleType: 'Trailer',
        weightTons: 15.5,
        ceilingBudget: 45000.0,
      );

      final json = req.toJson();

      expect(json['title'], equals('Steel Rods Cargo'));
      expect(json['weightTons'], equals(15.5));
      expect(json['ceilingBudget'], equals(45000.0));
    });

    test('BidModel parses BidResponseDto correctly', () {
      final json = {
        'id': 'bid-123-uuid',
        'bidNumber': 'BID-001',
        'tenderId': '22911131-22b2-40fd-b065-b3134f24d1bc',
        'transporterName': 'Express Logistics Pvt Ltd',
        'amount': 46000.0,
        'estimatedDays': 3,
        'remarks': 'Fast delivery guaranteed',
        'status': 'PENDING',
        'createdAt': '2026-08-08T11:00:00Z',
      };

      final bid = BidModel.fromJson(json);

      expect(bid.id, equals('bid-123-uuid'));
      expect(bid.bidNumber, equals('BID-001'));
      expect(bid.transporterName, equals('Express Logistics Pvt Ltd'));
      expect(bid.amount, equals(46000.0));
      expect(bid.estimatedDays, equals(3));
      expect(bid.status, equals('PENDING'));
      expect(bid.isPending, isTrue);
      expect(bid.amountFormatted, equals('₹46000'));
    });

    test('CreateBidRequest serializes JSON correctly', () {
      final req = CreateBidRequest(
        amount: 47000.0,
        estimatedDays: 4,
        remarks: 'GPS tracked truck',
      );

      final json = req.toJson();

      expect(json['amount'], equals(47000.0));
      expect(json['estimatedDays'], equals(4));
      expect(json['remarks'], equals('GPS tracked truck'));
    });

    test('CompetitiveBidModel parses CompetitiveBidResponseDto correctly', () {
      final json = {
        'rank': 1,
        'bidId': 'bid-001',
        'bidNumber': 'BID-101',
        'transporterId': 'transporter-001',
        'transporterName': 'Speedy Transports',
        'initialBidAmount': 48000.0,
        'currentNegotiationAmount': 46000.0,
        'finalNegotiatedAmount': 45500.0,
        'savingsAmount': 2500.0,
        'negotiationStatus': 'ACCEPTED',
      };

      final compBid = CompetitiveBidModel.fromJson(json);

      expect(compBid.rank, equals(1));
      expect(compBid.bidId, equals('bid-001'));
      expect(compBid.transporterName, equals('Speedy Transports'));
      expect(compBid.initialBidAmount, equals(48000.0));
      expect(compBid.savingsAmount, equals(2500.0));
      expect(compBid.winner, isTrue);
    });
  });
}
