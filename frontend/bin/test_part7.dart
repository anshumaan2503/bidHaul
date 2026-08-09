import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
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
  print('PART 7 — RAZORPAY PAYMENT INTEGRATION TEST');
  print('====================================================\n');

  try {
    final timestamp = DateTime.now().millisecondsSinceEpoch % 10000;
    final email = 'pay_company_$timestamp@test.com';
    const password = 'Password123!';

    // STEP 1: Register/login test Company user
    print('[1/7] Registering test Company user ($email)...');
    final signupRes = await dio.post('/api/v1/auth/signup', data: {
      'email': email,
      'password': password,
      'fullName': 'Pay Test Company',
      'companyName': 'Payment Test Co $timestamp',
      'role': 'COMPANY',
    });

    print('Signup status: ${signupRes.statusCode}');
    String userToken = '';
    if (signupRes.statusCode == 200 || signupRes.statusCode == 201) {
      userToken = signupRes.data['token'] ?? signupRes.data['accessToken'] ?? '';
    }

    if (userToken.isEmpty) {
      print('Attempting login to acquire user token...');
      final loginRes = await dio.post('/api/v1/auth/login', data: {
        'email': email,
        'password': password,
      });
      print('Login status: ${loginRes.statusCode}');
      userToken = loginRes.data['token'] ?? loginRes.data['accessToken'];
    }

    dio.options.headers['Authorization'] = 'Bearer $userToken';
    print('Company logged in successfully.');

    // STEP 2: Fetch subscription plans
    print('\n[2/7] User fetching active subscription plans (GET /api/v1/subscriptions/plans)...');
    final plansRes = await dio.get('/api/v1/subscriptions/plans');
    print('GET /api/v1/subscriptions/plans status: ${plansRes.statusCode}');
    assert(plansRes.statusCode == 200);
    final plans = plansRes.data as List;
    assert(plans.isNotEmpty, 'Active plans list should not be empty');

    final selectedPlan = plans.first;
    final planId = selectedPlan['id'].toString();
    final planName = selectedPlan['name'].toString();
    print('Selected Plan: $planName ($planId)');

    // STEP 3: Create Pending Subscription
    print('\n[3/7] Subscribing user to plan ($planName)...');
    final subRes = await dio.post('/api/v1/subscriptions/subscribe', data: {
      'planId': planId,
      'billingCycle': 'MONTHLY',
    });
    print('Subscribe status: ${subRes.statusCode}');
    assert(subRes.statusCode == 200 || subRes.statusCode == 201);
    final subStatus = subRes.data['status'].toString();
    print('Subscription Created! Status: $subStatus');
    assert(subStatus == 'PENDING_PAYMENT');

    // STEP 4: Retrieve auto-provisioned pending invoice
    print('\n[4/7] Retrieving user pending invoice (GET /api/v1/invoices/my)...');
    final invRes = await dio.get('/api/v1/invoices/my');
    print('GET /api/v1/invoices/my status: ${invRes.statusCode}');
    assert(invRes.statusCode == 200);
    final invoices = invRes.data as List;
    assert(invoices.isNotEmpty);

    final firstInvoice = invoices.first;
    final invoiceId = firstInvoice['id'].toString();
    final invoiceNo = firstInvoice['invoiceNo'] ?? firstInvoice['invoiceNumber'];
    final invoiceStatus = firstInvoice['status'].toString();
    final amount = firstInvoice['amount'];

    print('Pending Invoice ID: $invoiceId');
    print('Invoice Number: $invoiceNo');
    print('Invoice Status: $invoiceStatus');
    print('Invoice Amount: ₹$amount');
    assert(invoiceStatus == 'PENDING');

    // STEP 5: Create Razorpay Payment Order via Backend
    print('\n[5/7] Creating Razorpay payment order (POST /api/v1/payments/orders)...');
    final orderRes = await dio.post('/api/v1/payments/orders', data: {
      'invoiceId': invoiceId,
    });

    print('POST /api/v1/payments/orders status: ${orderRes.statusCode}');
    assert(orderRes.statusCode == 201 || orderRes.statusCode == 200);
    final orderData = orderRes.data;

    final paymentId = orderData['paymentId'].toString();
    final razorpayKeyId = orderData['razorpayKeyId'].toString();
    final razorpayOrderId = orderData['razorpayOrderId'].toString();
    final amountInPaise = orderData['amountInPaise'];
    final orderStatus = orderData['status'].toString();

    print('SUCCESS: Razorpay Payment Order Created!');
    print('  Payment ID: $paymentId');
    print('  Razorpay Key ID: $razorpayKeyId');
    print('  Razorpay Order ID: $razorpayOrderId');
    print('  Amount in Paise: $amountInPaise');
    print('  Order Status: $orderStatus');

    assert(paymentId.isNotEmpty);
    assert(razorpayKeyId.isNotEmpty);
    assert(razorpayOrderId.isNotEmpty);
    assert(amountInPaise > 0);

    // Test Idempotency: Repeating createOrder returns the same order
    final repeatOrderRes = await dio.post('/api/v1/payments/orders', data: {
      'invoiceId': invoiceId,
    });
    print('Idempotency order creation status: ${repeatOrderRes.statusCode}');
    assert(repeatOrderRes.data['razorpayOrderId'] == razorpayOrderId);

    // STEP 6: Test Security & State Immutability on Fake Verification Callback
    print('\n[6/7] Testing invalid payment verification security handling (POST /api/v1/payments/verify)...');
    final invalidVerifyRes = await dio.post('/api/v1/payments/verify', data: {
      'invoiceId': invoiceId,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': 'pay_fake123456789',
      'razorpaySignature': 'invalid_signature_hash',
    });

    print('POST /api/v1/payments/verify status (Expected >= 400): ${invalidVerifyRes.statusCode}');
    assert((invalidVerifyRes.statusCode ?? 0) >= 400, 'Invalid signature MUST be rejected by backend');

    // Verify Invoice and Subscription status remain PENDING / PENDING_PAYMENT
    final checkInvRes = await dio.get('/api/v1/invoices/$invoiceId');
    print('Post-failed-verification Invoice status: ${checkInvRes.data['status']} (Expected: PENDING)');
    assert(checkInvRes.data['status'] == 'PENDING');

    // STEP 7: Test Valid Verification Callback & Backend State Transitions
    print('\n[7/7] Testing valid payment verification & state transitions (POST /api/v1/payments/verify)...');
    final fakePaymentId = 'pay_test_$timestamp';
    const keySecret = 'secret_test_bidhaul12345';
    final payloadToSign = '$razorpayOrderId|$fakePaymentId';
    final hmac = Hmac(sha256, utf8.encode(keySecret));
    final validSignature = hmac.convert(utf8.encode(payloadToSign)).toString();

    print('Generated HMAC signature for test verification: $validSignature');

    final validVerifyRes = await dio.post('/api/v1/payments/verify', data: {
      'invoiceId': invoiceId,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': fakePaymentId,
      'razorpaySignature': validSignature,
    });

    print('POST /api/v1/payments/verify status: ${validVerifyRes.statusCode}');
    assert(validVerifyRes.statusCode == 200);
    print('Payment Verification Response: ${validVerifyRes.data}');

    // Verify backend updated state: Invoice -> PAID, Subscription -> ACTIVE
    final finalInvRes = await dio.get('/api/v1/invoices/$invoiceId');
    print('Final Invoice Status: ${finalInvRes.data['status']} (Expected: PAID)');
    assert(finalInvRes.data['status'] == 'PAID');
    assert(finalInvRes.data['paidAt'] != null);

    final finalSubRes = await dio.get('/api/v1/subscriptions/me/status');
    print('Final Subscription Status: ${finalSubRes.data['status']} (Expected: ACTIVE)');
    assert(finalSubRes.data['status'] == 'ACTIVE');

    print('\n====================================================');
    print('PART 7 INTEGRATION TEST PASSED SUCCESSFULLY!');
    print('====================================================');
    exit(0);
  } catch (e, stack) {
    print('\nTEST FAILED WITH ERROR: $e');
    print(stack);
    exit(1);
  }
}
