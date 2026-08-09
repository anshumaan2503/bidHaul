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
  print('PART 8 — NOTIFICATION INTEGRATION E2E TEST');
  print('====================================================\n');

  try {
    final timestamp = DateTime.now().millisecondsSinceEpoch % 10000;
    final email = 'notif_company_$timestamp@test.com';
    const password = 'Password123!';

    // STEP 1: Register test Company user
    print('[1/8] Registering test Company user ($email)...');
    final signupRes = await dio.post('/api/v1/auth/signup', data: {
      'email': email,
      'password': password,
      'fullName': 'Notification Test User',
      'companyName': 'Notification Test Co $timestamp',
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

    // STEP 2: Initial notifications & unread count check
    print('\n[2/8] Fetching initial notifications & unread count...');
    final initNotifsRes = await dio.get('/api/v1/notifications/my');
    print('GET /api/v1/notifications/my status: ${initNotifsRes.statusCode}');
    assert(initNotifsRes.statusCode == 200);

    final initCountRes = await dio.get('/api/v1/notifications/my/unread/count');
    print('GET /api/v1/notifications/my/unread/count status: ${initCountRes.statusCode}');
    assert(initCountRes.statusCode == 200);
    print('Initial unread count: ${initCountRes.data}');

    // STEP 3: Trigger a backend event (Subscribe plan & verify payment)
    print('\n[3/8] Triggering business event (Subscribe plan & capture payment)...');
    final plansRes = await dio.get('/api/v1/subscriptions/plans');
    assert(plansRes.statusCode == 200);
    final plans = plansRes.data as List;
    assert(plans.isNotEmpty, 'Subscription plans should not be empty');

    final planId = plans[0]['id'].toString();

    final subRes = await dio.post('/api/v1/subscriptions/subscribe', data: {
      'planId': planId,
      'billingCycle': 'MONTHLY',
    });
    print('POST /api/v1/subscriptions/subscribe status: ${subRes.statusCode}');
    assert(subRes.statusCode == 200 || subRes.statusCode == 201);

    // Retrieve pending invoice
    final invRes = await dio.get('/api/v1/invoices/my');
    assert(invRes.statusCode == 200);
    final invoices = invRes.data as List;
    assert(invoices.isNotEmpty);
    final invoiceId = invoices.first['id'].toString();

    // Create payment order
    final orderRes = await dio.post('/api/v1/payments/orders', data: {
      'invoiceId': invoiceId,
    });
    assert(orderRes.statusCode == 200 || orderRes.statusCode == 201);
    final razorpayOrderId = orderRes.data['razorpayOrderId'].toString();

    // Generate valid HMAC signature and verify payment
    final fakePaymentId = 'pay_notif_$timestamp';
    const keySecret = 'secret_test_bidhaul12345';
    final payloadToSign = '$razorpayOrderId|$fakePaymentId';
    final hmac = Hmac(sha256, utf8.encode(keySecret));
    final validSignature = hmac.convert(utf8.encode(payloadToSign)).toString();

    final validVerifyRes = await dio.post('/api/v1/payments/verify', data: {
      'invoiceId': invoiceId,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': fakePaymentId,
      'razorpaySignature': validSignature,
    });
    print('POST /api/v1/payments/verify status: ${validVerifyRes.statusCode}');
    assert(validVerifyRes.statusCode == 200);

    // STEP 4: Fetch notifications after backend payment event
    print('\n[4/8] Fetching notifications after business event (GET /api/v1/notifications/my)...');
    final notifsRes = await dio.get('/api/v1/notifications/my');
    print('GET /api/v1/notifications/my status: ${notifsRes.statusCode}');
    assert(notifsRes.statusCode == 200);
    final notifsList = (notifsRes.data['content'] as List?) ?? [];
    print('Total notifications received: ${notifsList.length}');
    for (var n in notifsList) {
      print('  - Notification ID: ${n['id']} | Type: ${n['type']} | Title: ${n['title']} | Read: ${n['read']}');
    }
    assert(notifsList.isNotEmpty, 'A backend payment notification should have been published!');

    // STEP 5: Verify unread count > 0
    print('\n[5/8] Checking unread count after notification event...');
    final unreadCountRes = await dio.get('/api/v1/notifications/my/unread/count');
    print('GET /api/v1/notifications/my/unread/count status: ${unreadCountRes.statusCode}, unread count: ${unreadCountRes.data}');
    assert(unreadCountRes.statusCode == 200);

    final unreadNotifsRes = await dio.get('/api/v1/notifications/my/unread');
    print('GET /api/v1/notifications/my/unread status: ${unreadNotifsRes.statusCode}');
    assert(unreadNotifsRes.statusCode == 200);
    final unreadList = (unreadNotifsRes.data['content'] as List?) ?? [];
    print('Unread notifications count from /my/unread: ${unreadList.length}');
    assert(unreadList.isNotEmpty, 'Unread notification list should not be empty');

    // STEP 6: Mark single notification as read
    final targetId = notifsList[0]['id'].toString();
    print('\n[6/8] Marking individual notification as read (PATCH /api/v1/notifications/$targetId/read)...');
    final markReadRes = await dio.patch('/api/v1/notifications/$targetId/read');
    print('PATCH mark notification status: ${markReadRes.statusCode}');
    assert(markReadRes.statusCode == 200 || markReadRes.statusCode == 204);

    final updatedCountRes = await dio.get('/api/v1/notifications/my/unread/count');
    print('Updated unread count after marking 1 notification as read: ${updatedCountRes.data}');

    // STEP 7: Mark all notifications as read
    print('\n[7/8] Marking all notifications as read (PATCH /api/v1/notifications/my/read-all)...');
    final markAllRes = await dio.patch('/api/v1/notifications/my/read-all');
    print('PATCH markAllAsRead status: ${markAllRes.statusCode}');
    assert(markAllRes.statusCode == 200 || markAllRes.statusCode == 204);

    // STEP 8: Final unread count check
    print('\n[8/8] Verifying final unread count is 0...');
    final finalCountRes = await dio.get('/api/v1/notifications/my/unread/count');
    print('Final unread count: ${finalCountRes.data}');
    assert(finalCountRes.statusCode == 200);
    final finalCount = (finalCountRes.data is num) ? (finalCountRes.data as num).toInt() : int.parse(finalCountRes.data.toString());
    assert(finalCount == 0, 'Final unread count should be 0 after markAllAsRead');

    print('\n====================================================');
    print('SUCCESS: PART 8 E2E NOTIFICATION INTEGRATION TEST PASSED!');
    print('====================================================');
  } catch (e, stack) {
    print('\nFAILED: Part 8 notification test threw exception: $e');
    print(stack);
    exit(1);
  }
}
