import 'package:bidhaul/models/contract.dart';
import 'package:bidhaul/models/negotiation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Part 4 — Negotiation & Contract Models Unit Tests', () {
    test('NegotiationModel parses NegotiationResponseDto correctly', () {
      final json = {
        'id': 'neg-123',
        'tenderId': 'ten-456',
        'bidId': 'bid-789',
        'companyId': 'comp-111',
        'transporterId': 'trans-222',
        'status': 'OPEN',
        'currentAmount': 45000.0,
        'lastOfferedBy': 'comp-111',
        'finalAmount': null,
        'acceptedBy': null,
        'closedAt': null,
        'createdAt': '2026-08-08T12:00:00Z',
        'updatedAt': '2026-08-08T12:30:00Z',
        'offers': [
          {
            'id': 'off-1',
            'offeredBy': 'comp-111',
            'offeredByName': 'Test Logistics Co',
            'amount': 45000.0,
            'remarks': 'Initial discount request',
            'createdAt': '2026-08-08T12:00:00Z',
          }
        ]
      };

      final model = NegotiationModel.fromJson(json);

      expect(model.id, equals('neg-123'));
      expect(model.tenderId, equals('ten-456'));
      expect(model.bidId, equals('bid-789'));
      expect(model.status, equals('OPEN'));
      expect(model.currentAmount, equals(45000.0));
      expect(model.isOpen, isTrue);
      expect(model.offers.length, equals(1));
      expect(model.offers.first.offeredByName, equals('Test Logistics Co'));
    });

    test('CreateNegotiationRequest serializes JSON correctly', () {
      const req = CreateNegotiationRequest(
        bidId: 'bid-789',
        remarks: 'Let us negotiate freight rate',
      );

      final json = req.toJson();

      expect(json['bidId'], equals('bid-789'));
      expect(json['remarks'], equals('Let us negotiate freight rate'));
    });

    test('CreateNegotiationOfferRequest serializes JSON correctly', () {
      const req = CreateNegotiationOfferRequest(
        amount: 42000.0,
        remarks: 'Revised counter offer',
      );

      final json = req.toJson();

      expect(json['amount'], equals(42000.0));
      expect(json['remarks'], equals('Revised counter offer'));
    });

    test('ContractModel parses ContractResponseDto correctly', () {
      final json = {
        'id': 'cnt-999',
        'contractNumber': 'CNT-ABCD1234',
        'tenderId': 'ten-456',
        'bidId': 'bid-789',
        'negotiationId': 'neg-123',
        'companyId': 'comp-111',
        'transporterId': 'trans-222',
        'finalAmount': 42000.0,
        'terms': 'Standard 30-day payment upon delivery confirmation',
        'status': 'PENDING_ACCEPTANCE',
        'acceptedBy': null,
        'acceptedAt': null,
        'createdAt': '2026-08-08T14:00:00Z',
        'updatedAt': '2026-08-08T14:00:00Z',
      };

      final model = ContractModel.fromJson(json);

      expect(model.id, equals('cnt-999'));
      expect(model.contractNumber, equals('CNT-ABCD1234'));
      expect(model.finalAmount, equals(42000.0));
      expect(model.status, equals('PENDING_ACCEPTANCE'));
      expect(model.isPendingAcceptance, isTrue);
      expect(model.isAccepted, isFalse);
    });

    test('AcceptContractRequest serializes JSON correctly', () {
      const req = AcceptContractRequest(accepted: true);

      final json = req.toJson();

      expect(json['accepted'], isTrue);
    });
  });
}
