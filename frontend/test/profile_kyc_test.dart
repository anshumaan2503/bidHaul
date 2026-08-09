import 'package:flutter_test/flutter_test.dart';
import 'package:bidhaul/models/company.dart';
import 'package:bidhaul/models/transporter.dart';

void main() {
  group('Part 2 — Company & Transporter Profile & KYC Models Unit Tests', () {
    test('CompanyProfileModel parses CompanyProfileResponseDto correctly', () {
      final json = {
        'id': 'comp_001',
        'userId': 'user_100',
        'companyName': 'Acme Freight Logistics',
        'ownerName': 'Alice Smith',
        'email': 'alice@acme.com',
        'phone': '+1555123456',
        'address': '100 Industrial Parkway, City, ST',
        'gstNumber': '07ACMEF1234F1Z5',
        'licenseNumber': 'LIC-ACME-01',
        'verificationStatus': 'VERIFIED',
        'rejectionReason': null,
        'submittedAt': '2026-08-08T10:00:00Z',
        'verifiedAt': '2026-08-08T12:00:00Z',
        'createdAt': '2026-08-08T08:00:00Z',
      };

      final company = CompanyProfileModel.fromJson(json);

      expect(company.id, equals('comp_001'));
      expect(company.companyName, equals('Acme Freight Logistics'));
      expect(company.isVerified, isTrue);
      expect(company.isSubmitted, isFalse);
      expect(company.isPending, isFalse);
      expect(company.isRejected, isFalse);
    });

    test('CreateCompanyProfileRequest serializes JSON correctly', () {
      final req = CreateCompanyProfileRequest(
        companyName: ' Delta Carriers ',
        address: ' 200 Dock St ',
        gstNumber: ' 27DELTA1234F1Z2 ',
        licenseNumber: ' LIC-DELTA-02 ',
      );

      final json = req.toJson();

      expect(json['companyName'], equals('Delta Carriers'));
      expect(json['address'], equals('200 Dock St'));
      expect(json['gstNumber'], equals('27DELTA1234F1Z2'));
      expect(json['licenseNumber'], equals('LIC-DELTA-02'));
    });

    test('TransporterProfileModel parses TransporterProfileResponseDto correctly', () {
      final json = {
        'id': 'trans_001',
        'userId': 'user_200',
        'companyName': 'Swift Transport Solutions',
        'ownerName': 'Bob Jones',
        'email': 'bob@swift.com',
        'phone': '+1555987654',
        'vehicleType': '32ft Container',
        'fleetSize': 15,
        'licenseNumber': 'LIC-SWIFT-99',
        'completedDeliveries': 42,
        'rating': 4.8,
        'verificationStatus': 'SUBMITTED',
        'rejectionReason': null,
        'submittedAt': '2026-08-08T11:00:00Z',
        'verifiedAt': null,
        'createdAt': '2026-08-08T09:00:00Z',
      };

      final transporter = TransporterProfileModel.fromJson(json);

      expect(transporter.id, equals('trans_001'));
      expect(transporter.transporterName, equals('Swift Transport Solutions'));
      expect(transporter.fleetSize, equals(15));
      expect(transporter.completedDeliveries, equals(42));
      expect(transporter.rating, equals(4.8));
      expect(transporter.isSubmitted, isTrue);
      expect(transporter.isVerified, isFalse);
    });

    test('CreateTransporterProfileRequest serializes JSON correctly', () {
      final req = CreateTransporterProfileRequest(
        companyName: ' Apex Hauling ',
        vehicleType: ' Flatbed Trailer ',
        fleetSize: 10,
        licenseNumber: ' LIC-APEX-10 ',
      );

      final json = req.toJson();

      expect(json['companyName'], equals('Apex Hauling'));
      expect(json['vehicleType'], equals('Flatbed Trailer'));
      expect(json['fleetSize'], equals(10));
      expect(json['licenseNumber'], equals('LIC-APEX-10'));
    });
  });
}
