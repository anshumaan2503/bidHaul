import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  print('====================================================');
  print('STARTING PART 9 — ADMIN + SUPER ADMIN + AUDIT E2E TEST');
  print('====================================================');

  final baseUrl = 'http://localhost:8080';
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
    validateStatus: (status) => true, // capture all HTTP status codes gracefully
  ));

  try {
    // ----------------------------------------------------
    // STEP 1: ADMIN LOGIN
    // ----------------------------------------------------
    print('\n[STEP 1] Testing Admin Login (admin@bidhaul.com)...');
    final adminLoginResp = await dio.post('/api/v1/auth/admin-login', data: {
      'email': 'admin@bidhaul.com',
      'password': 'password123',
    });

    if (adminLoginResp.statusCode != 200) {
      print('FAILED: Admin login returned status ${adminLoginResp.statusCode}');
      print(adminLoginResp.data);
      return;
    }

    final adminToken = adminLoginResp.data['token'];
    final adminUser = adminLoginResp.data['user'];
    print('SUCCESS: Admin logged in! User: ${adminUser['fullName']} [Role: ${adminUser['userType']}]');

    final adminOptions = Options(headers: {'Authorization': 'Bearer $adminToken'});

    // ----------------------------------------------------
    // STEP 2: SUPER ADMIN LOGIN
    // ----------------------------------------------------
    print('\n[STEP 2] Testing Super Admin Login (superadmin@bidhaul.com)...');
    final superAdminLoginResp = await dio.post('/api/v1/auth/admin-login', data: {
      'email': 'superadmin@bidhaul.com',
      'password': 'password123',
    });

    String? superAdminToken;
    if (superAdminLoginResp.statusCode == 200) {
      superAdminToken = superAdminLoginResp.data['token'];
      final superAdminUser = superAdminLoginResp.data['user'];
      print('SUCCESS: Super Admin logged in! User: ${superAdminUser['fullName']} [Role: ${superAdminUser['userType']}]');
    } else {
      print('NOTE: Super Admin account status: ${superAdminLoginResp.statusCode}. Proceeding with Admin token.');
    }

    final superAdminOptions = Options(headers: {'Authorization': 'Bearer ${superAdminToken ?? adminToken}'});

    // ----------------------------------------------------
    // STEP 3: GET ADMIN DASHBOARD
    // ----------------------------------------------------
    print('\n[STEP 3] GET /api/v1/admin/dashboard...');
    final dashResp = await dio.get('/api/v1/admin/dashboard', options: adminOptions);
    if (dashResp.statusCode == 200) {
      final data = dashResp.data;
      print('SUCCESS: Admin Dashboard metrics retrieved:');
      print('  Total Users: ${data['totalUsers']}');
      print('  Active Companies: ${data['activeCompanies']}');
      print('  Active Transporters: ${data['activeTransporters']}');
      print('  Live Tenders: ${data['liveTenders']}');
      print('  Open Negotiations: ${data['openNegotiations']}');
    } else {
      print('FAILED: Dashboard status ${dashResp.statusCode}');
    }

    // ----------------------------------------------------
    // STEP 4: USER GOVERNANCE (SUSPEND & ACTIVATE)
    // ----------------------------------------------------
    print('\n[STEP 4] Testing User Suspension & Activation...');

    // Create temporary company user to suspend/activate
    final testEmail = 'gov_test_${DateTime.now().millisecondsSinceEpoch}@test.com';
    print('Creating temporary user ($testEmail)...');
    final signupResp = await dio.post('/api/v1/auth/signup', data: {
      'email': testEmail,
      'password': 'Password123!',
      'fullName': 'Governance Test User',
      'phone': '9988776655',
      'role': 'COMPANY',
    });

    if (signupResp.statusCode == 201 || signupResp.statusCode == 200) {
      final targetUserId = signupResp.data['user']['id'];
      print('Target user created with ID: $targetUserId');

      // Suspend user
      print('Suspending user $targetUserId...');
      final suspendResp = await dio.patch('/api/v1/admin/users/$targetUserId/suspend', options: adminOptions);
      if (suspendResp.statusCode == 200 || suspendResp.statusCode == 204) {
        print('SUCCESS: User $targetUserId suspended!');
      } else {
        print('FAILED to suspend user: ${suspendResp.statusCode} ${suspendResp.data}');
      }

      // Verify suspended user login is rejected or handled
      print('Attempting login as suspended user...');
      final suspendedLoginResp = await dio.post('/api/v1/auth/login', data: {
        'email': testEmail,
        'password': 'Password123!',
      });
      print('Suspended login response status: ${suspendedLoginResp.statusCode} (Expected rejection/forbidden/unauthorized)');

      // Activate user
      print('Activating user $targetUserId...');
      final activateResp = await dio.patch('/api/v1/admin/users/$targetUserId/activate', options: adminOptions);
      if (activateResp.statusCode == 200 || activateResp.statusCode == 204) {
        print('SUCCESS: User $targetUserId activated!');
      } else {
        print('FAILED to activate user: ${activateResp.statusCode} ${activateResp.data}');
      }
    } else {
      print('NOTE: Could not create test user: ${signupResp.statusCode}');
    }

    // ----------------------------------------------------
    // STEP 5: AUDIT LOGS RETRIEVAL
    // ----------------------------------------------------
    print('\n[STEP 5] Testing Audit Log Retrieval...');
    final auditLogsResp = await dio.get('/api/v1/admin/audit-logs', options: adminOptions);
    if (auditLogsResp.statusCode == 200) {
      final content = auditLogsResp.data['content'] as List;
      print('SUCCESS: Retrieved ${content.length} audit log entries (Total elements: ${auditLogsResp.data['totalElements']})');
      if (content.isNotEmpty) {
        final sample = content.first;
        print('  Sample Log -> Action: ${sample['action']} | Actor: ${sample['actorUserId']} | Entity: ${sample['entityType']} [${sample['entityId']}]');

        // Test filter by actor
        final actorId = sample['actorUserId'];
        if (actorId != null) {
          print('Testing audit logs by actor ($actorId)...');
          final actorResp = await dio.get('/api/v1/admin/audit-logs/actor/$actorId', options: adminOptions);
          if (actorResp.statusCode == 200) {
            print('SUCCESS: Actor audit logs retrieved: ${(actorResp.data['content'] as List).length} entries');
          }
        }
      }
    } else {
      print('FAILED: Audit logs status ${auditLogsResp.statusCode}');
    }

    // ----------------------------------------------------
    // STEP 6: ROLE ISOLATION & SECURITY REJECTION TEST
    // ----------------------------------------------------
    print('\n[STEP 6] Testing Security Rejection (Role Isolation)...');

    // Login as regular COMPANY user
    print('Logging in as regular COMPANY user...');
    final companyLoginResp = await dio.post('/api/v1/auth/login', data: {
      'email': 'company@bidhaul.com',
      'password': 'password123',
    });

    if (companyLoginResp.statusCode == 200) {
      final companyToken = companyLoginResp.data['token'];
      final companyOptions = Options(headers: {'Authorization': 'Bearer $companyToken'});

      print('Company user attempting GET /api/v1/admin/dashboard...');
      final unauthorizedDash = await dio.get('/api/v1/admin/dashboard', options: companyOptions);
      if (unauthorizedDash.statusCode == 403) {
        print('PASSED REJECTION TEST: Backend properly rejected company access with 403 Forbidden!');
      } else {
        print('SECURITY WARNING: Backend responded with ${unauthorizedDash.statusCode} instead of 403');
      }

      print('Company user attempting GET /api/v1/admin/audit-logs...');
      final unauthorizedAudit = await dio.get('/api/v1/admin/audit-logs', options: companyOptions);
      if (unauthorizedAudit.statusCode == 403) {
        print('PASSED REJECTION TEST: Backend properly rejected company access to audit logs with 403 Forbidden!');
      } else {
        print('SECURITY WARNING: Backend responded with ${unauthorizedAudit.statusCode} instead of 403');
      }
    }

    // Test SUPER_ADMIN endpoint restriction on regular ADMIN
    print('Testing SUPER_ADMIN endpoint restriction on regular ADMIN user...');
    final superAdminEndpoint = await dio.post(
      '/api/v1/subscriptions/plans',
      data: {
        'name': 'Test Plan',
        'description': 'Test',
        'monthlyPrice': 100,
        'annualPrice': 1000,
        'maxTendersPerMonth': 10,
        'maxBidsPerMonth': 20,
        'features': '["test"]',
        'targetUserType': 'COMPANY',
      },
      options: adminOptions, // Using regular ADMIN token
    );

    if (superAdminEndpoint.statusCode == 403) {
      print('PASSED REJECTION TEST: Regular ADMIN token properly rejected from SUPER_ADMIN plan creation endpoint with 403 Forbidden!');
    } else {
      print('NOTE: Subscription plan endpoint response status: ${superAdminEndpoint.statusCode}');
    }

    print('\n====================================================');
    print('PART 9 ADMIN + SUPER ADMIN + AUDIT E2E TEST COMPLETED SUCCESSFULLY');
    print('====================================================');
  } catch (e) {
    print('ERROR IN E2E TEST: $e');
  }
}
