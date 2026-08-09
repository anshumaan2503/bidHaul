import 'dart:io';
import 'package:dio/dio.dart';

void main() async {
  final baseUrl = 'http://localhost:8080';
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    validateStatus: (status) => status != null && status < 500,
  ));

  print('====================================================');
  print('PART 6 — SUBSCRIPTION & INVOICE INTEGRATION TEST');
  print('====================================================\n');

  try {
    // ----------------------------------------------------
    // STEP 1: REGISTER/LOGIN AS A TRANSPORTER USER
    // ----------------------------------------------------
    final timestamp = DateTime.now().millisecondsSinceEpoch % 10000;
    final testEmail = 'sub_transporter_$timestamp@test.com';

    print('[1/6] Registering test Transporter user ($testEmail)...');
    final signupRes = await dio.post('/api/v1/auth/signup', data: {
      'email': testEmail,
      'password': 'Password123!',
      'fullName': 'Test Sub Transporter',
      'role': 'TRANSPORTER',
    });

    print('Signup status: ${signupRes.statusCode}');
    String userToken = '';
    if (signupRes.statusCode == 200 || signupRes.statusCode == 201) {
      userToken = signupRes.data['token'] ?? signupRes.data['accessToken'];
      print('Transporter registered & logged in successfully.');
    } else {
      print('Signup failed: ${signupRes.data}. Attempting login...');
      final loginRes = await dio.post('/api/v1/auth/login', data: {
        'email': testEmail,
        'password': 'Password123!',
      });
      userToken = loginRes.data['token'] ?? loginRes.data['accessToken'];
    }

    dio.options.headers['Authorization'] = 'Bearer $userToken';

    // ----------------------------------------------------
    // STEP 2: FETCH ACTIVE SUBSCRIPTION PLANS
    // ----------------------------------------------------
    print('\n[2/6] User fetching active subscription plans (GET /api/v1/subscriptions/plans)...');
    var plansRes = await dio.get('/api/v1/subscriptions/plans');
    print('GET /api/v1/subscriptions/plans status: ${plansRes.statusCode}');
    assert(plansRes.statusCode == 200);

    List plans = plansRes.data as List;
    print('Active plans count: ${plans.length}');

    String targetPlanId = '';
    String targetPlanName = '';

    if (plans.isNotEmpty) {
      targetPlanId = plans[0]['id'].toString();
      targetPlanName = plans[0]['name'].toString();
      print('Selected existing Plan: $targetPlanName ($targetPlanId)');
    } else {
      print('No pre-existing plans in DB. Attempting Super Admin plan creation...');
      final superAdminRes = await dio.post('/api/v1/auth/admin-login', data: {
        'email': 'superadmin@bidhaul.com',
        'password': 'Password123!',
      });

      if (superAdminRes.statusCode == 200) {
        final adminToken = superAdminRes.data['token'] ?? superAdminRes.data['accessToken'];
        final adminDio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {'Authorization': 'Bearer $adminToken'},
        ));

        final createPlanRes = await adminDio.post('/api/v1/subscriptions/plans', data: {
          'name': 'Dynamic Plan $timestamp',
          'monthlyPrice': 2999.00,
          'description': 'Created via integration test',
          'features': '["Unlimited Bids", "Priority Support"]',
          'recommended': true,
        });

        if (createPlanRes.statusCode == 200 || createPlanRes.statusCode == 201) {
          targetPlanId = createPlanRes.data['id'].toString();
          targetPlanName = createPlanRes.data['name'].toString();
          print('Super Admin created plan: $targetPlanName ($targetPlanId)');
        }
      }
    }

    assert(targetPlanId.isNotEmpty, 'A valid subscription plan ID is required');

    // ----------------------------------------------------
    // STEP 3: CHECK SUBSCRIPTION STATUS (BEFORE SUBSCRIBING)
    // ----------------------------------------------------
    print('\n[3/6] Checking initial subscription status (GET /api/v1/subscriptions/me/status)...');
    final initialStatusRes = await dio.get('/api/v1/subscriptions/me/status');
    print('GET /api/v1/subscriptions/me/status status: ${initialStatusRes.statusCode}');

    // ----------------------------------------------------
    // STEP 4: SUBSCRIBE TO SELECTED PLAN
    // ----------------------------------------------------
    print('\n[4/6] Subscribing user to plan ($targetPlanName)...');
    final subRes = await dio.post('/api/v1/subscriptions/subscribe', data: {
      'planId': targetPlanId,
      'billingCycle': 'MONTHLY',
    });

    print('POST /api/v1/subscriptions/subscribe status: ${subRes.statusCode}');
    print('Subscription Response: ${subRes.data}');

    assert(subRes.statusCode == 200 || subRes.statusCode == 201);
    final subscriptionId = subRes.data['id'].toString();
    final subStatus = subRes.data['status'].toString();

    print('SUCCESS: Subscription Created! ID: $subscriptionId | Status: $subStatus');
    assert(subStatus == 'PENDING_PAYMENT');

    // Verify status and history
    final updatedStatus = await dio.get('/api/v1/subscriptions/me/status');
    print('GET /api/v1/subscriptions/me/status status: ${updatedStatus.statusCode}');
    print('Updated Status: ${updatedStatus.data['status']}');
    assert(updatedStatus.data['status'] == 'PENDING_PAYMENT');

    final historyRes = await dio.get('/api/v1/subscriptions/me/history');
    print('GET /api/v1/subscriptions/me/history count: ${(historyRes.data as List).length}');
    assert((historyRes.data as List).isNotEmpty);

    // ----------------------------------------------------
    // STEP 5: VERIFY AUTO-PROVISIONED INVOICE
    // ----------------------------------------------------
    print('\n[5/6] Verifying provisioned Invoices (GET /api/v1/invoices/my)...');
    final myInvoicesRes = await dio.get('/api/v1/invoices/my');
    print('GET /api/v1/invoices/my status: ${myInvoicesRes.statusCode}');
    assert(myInvoicesRes.statusCode == 200);

    final invoices = myInvoicesRes.data as List;
    print('User Invoices Count: ${invoices.length}');
    assert(invoices.isNotEmpty);

    final firstInvoice = invoices.first;
    final invoiceId = firstInvoice['id'].toString();
    final invoiceNo = firstInvoice['invoiceNo'] ?? firstInvoice['invoiceNumber'];
    final invoiceStatus = firstInvoice['status'];
    final amount = firstInvoice['amount'];

    print('Invoice ID: $invoiceId');
    print('Invoice Number: $invoiceNo');
    print('Invoice Status: $invoiceStatus');
    print('Invoice Amount: ₹$amount');

    assert(invoiceStatus == 'PENDING');

    // ----------------------------------------------------
    // STEP 6: VERIFY SINGLE INVOICE & SUBSCRIPTION INVOICE ENDPOINTS
    // ----------------------------------------------------
    print('\n[6/6] Testing GET /api/v1/invoices/$invoiceId & GET /api/v1/invoices/subscription/$subscriptionId...');

    final singleInvoiceRes = await dio.get('/api/v1/invoices/$invoiceId');
    print('GET /api/v1/invoices/$invoiceId status: ${singleInvoiceRes.statusCode}');
    assert(singleInvoiceRes.statusCode == 200);
    assert(singleInvoiceRes.data['id'] == invoiceId);

    final subInvoiceRes = await dio.get('/api/v1/invoices/subscription/$subscriptionId');
    print('GET /api/v1/invoices/subscription/$subscriptionId status: ${subInvoiceRes.statusCode}');
    assert(subInvoiceRes.statusCode == 200);
    assert(subInvoiceRes.data['subscriptionId'] == subscriptionId);

    print('\n====================================================');
    print('PART 6 INTEGRATION TEST PASSED SUCCESSFULLY!');
    print('====================================================');
    exit(0);
  } catch (e, stack) {
    print('\nTEST FAILED WITH ERROR: $e');
    print(stack);
    exit(1);
  }
}
