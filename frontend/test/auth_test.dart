import 'package:flutter_test/flutter_test.dart';
import 'package:bidhaul/models/user_model.dart';
import 'package:bidhaul/models/auth_request.dart';
import 'package:bidhaul/models/auth_response.dart';

void main() {
  group('Authentication Models Unit Tests', () {
    test('UserModel.fromJson parses valid COMPANY user DTO', () {
      final json = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'email': 'company@bidhaul.com',
        'fullName': 'Test Shipper Ltd',
        'phone': '+1234567890',
        'userType': 'COMPANY',
        'status': 'ACTIVE',
        'createdAt': '2026-08-08T00:00:00Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, equals('123e4567-e89b-12d3-a456-426614174000'));
      expect(user.email, equals('company@bidhaul.com'));
      expect(user.isCompany, isTrue);
      expect(user.isTransporter, isFalse);
      expect(user.isAdmin, isFalse);
      expect(user.isSuperAdmin, isFalse);
      expect(user.isAdministrative, isFalse);
      expect(user.isSuspended, isFalse);
    });

    test('UserModel parses SUPER_ADMIN correctly', () {
      final json = {
        'id': '999e4567-e89b-12d3-a456-426614174999',
        'email': 'superadmin@bidhaul.com',
        'fullName': 'Super Admin',
        'userType': 'SUPER_ADMIN',
        'status': 'ACTIVE',
      };

      final user = UserModel.fromJson(json);

      expect(user.isSuperAdmin, isTrue);
      expect(user.isAdministrative, isTrue);
    });

    test('SignupRequest.toJson formats payload correctly', () {
      final req = SignupRequest(
        email: '  NEW_USER@BIDHAUL.COM  ',
        password: 'password123',
        fullName: ' John Doe ',
        companyName: ' Doe Logistics ',
        phone: ' +1987654321 ',
        role: 'company',
      );

      final json = req.toJson();

      expect(json['email'], equals('new_user@bidhaul.com'));
      expect(json['role'], equals('COMPANY'));
      expect(json['fullName'], equals('John Doe'));
      expect(json['companyName'], equals('Doe Logistics'));
    });

    test('AuthResponse.fromJson parses complete auth payload', () {
      final json = {
        'token': 'access_token_123',
        'refreshToken': 'refresh_token_456',
        'tokenType': 'Bearer',
        'expiresIn': 86400,
        'user': {
          'id': 'user_001',
          'email': 'transporter@carrier.com',
          'fullName': 'Apex Carrier',
          'userType': 'TRANSPORTER',
          'status': 'ACTIVE',
        },
      };

      final response = AuthResponse.fromJson(json);

      expect(response.token, equals('access_token_123'));
      expect(response.refreshToken, equals('refresh_token_456'));
      expect(response.user.isTransporter, isTrue);
    });
  });
}
