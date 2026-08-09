import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  print('================================================================');
  print('STARTING PART 10 — BIDHAUL FINAL E2E SYSTEM VERIFICATION');
  print('================================================================');

  final baseUrl = 'http://localhost:8080';
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
    validateStatus: (status) => true,
  ));

  final results = <String, String>{};

  void logResult(String step, bool success, String details) {
    final statusStr = success ? 'PASS' : 'FAIL';
    results[step] = statusStr;
    print('[$statusStr] $step: $details');
  }

  Future<Map<String, dynamic>?> loginOrSignup(String email, String password, String name, String role) async {
    var resp = await dio.post('/api/v1/auth/login', data: {
      'email': email,
      'password': password,
    });

    if (resp.statusCode != 200) {
      final signupResp = await dio.post('/api/v1/auth/signup', data: {
        'email': email,
        'password': password,
        'fullName': name,
        'phone': '9876543210',
        'role': role,
      });

      if (signupResp.statusCode == 200 || signupResp.statusCode == 201) {
        resp = await dio.post('/api/v1/auth/login', data: {
          'email': email,
          'password': password,
        });
      }
    }

    if (resp.statusCode == 200) {
      return resp.data as Map<String, dynamic>;
    }
    return null;
  }

  try {
    // =================================================================
    // STEP 2: AUTHENTICATION REGRESSION
    // =================================================================
    print('\n--- STEP 2: AUTHENTICATION REGRESSION ---');

    final companyAuth = await loginOrSignup('test@company.com', '12345678', 'Test Company User', 'COMPANY') ??
                        await loginOrSignup('company@bidhaul.com', 'password123', 'Test Company User', 'COMPANY');
    final companyToken = companyAuth?['token'];
    final companyUser = companyAuth?['user'];
    final companyOpts = Options(headers: {'Authorization': 'Bearer $companyToken'});
    logResult('STEP 2.1 (Company Login)', companyToken != null, 'User: ${companyUser?['fullName']} [Role: ${companyUser?['userType']}]');

    final transporterAuth = await loginOrSignup('test@transporter1.com', '12345678', 'Test Transporter User', 'TRANSPORTER') ??
                             await loginOrSignup('transporter@bidhaul.com', 'password123', 'Test Transporter User', 'TRANSPORTER');
    final transporterToken = transporterAuth?['token'];
    final transporterUser = transporterAuth?['user'];
    final transporterOpts = Options(headers: {'Authorization': 'Bearer $transporterToken'});
    logResult('STEP 2.2 (Transporter Login)', transporterToken != null, 'User: ${transporterUser?['fullName']} [Role: ${transporterUser?['userType']}]');

    final adminAuthResp = await dio.post('/api/v1/auth/admin-login', data: {
      'email': 'admin@bidhaul.com',
      'password': 'password123',
    });
    final adminToken = adminAuthResp.data['token'];
    final adminOpts = Options(headers: {'Authorization': 'Bearer $adminToken'});
    logResult('STEP 2.3 (Admin Login)', adminAuthResp.statusCode == 200 && adminToken != null, 'Role: ${adminAuthResp.data['user']?['userType']}');

    final superAdminAuthResp = await dio.post('/api/v1/auth/admin-login', data: {
      'email': 'superadmin@bidhaul.com',
      'password': 'password123',
    });
    final superAdminToken = superAdminAuthResp.data['token'];
    final superAdminOpts = Options(headers: {'Authorization': 'Bearer $superAdminToken'});
    logResult('STEP 2.4 (Super Admin Login)', superAdminAuthResp.statusCode == 200 && superAdminToken != null, 'Role: ${superAdminAuthResp.data['user']?['userType']}');

    final meResp = await dio.get('/api/v1/auth/me', options: companyOpts);
    logResult('STEP 2.5 (Session Restoration /auth/me)', meResp.statusCode == 200, 'Fetched user: ${meResp.data['email']}');

    final invalidLogin = await dio.post('/api/v1/auth/login', data: {
      'email': 'test@company.com',
      'password': 'WRONG_PASSWORD_123',
    });
    logResult('STEP 2.6 (Invalid Password Rejection)', invalidLogin.statusCode == 401, 'Status: ${invalidLogin.statusCode}');

    // =================================================================
    // STEP 3 & 4: COMPANY & TRANSPORTER PROFILE / KYC
    // =================================================================
    print('\n--- STEPS 3 & 4: COMPANY & TRANSPORTER PROFILE / KYC ---');

    var companyProfileResp = await dio.get('/api/v1/company/profile', options: companyOpts);
    if (companyProfileResp.statusCode != 200) {
      await dio.post('/api/v1/company/profile', options: companyOpts, data: {
        'companyName': 'Apex Logistics Corp',
        'registrationNumber': 'REG123456',
        'taxId': 'TAX987654',
        'address': '123 Business Way',
        'city': 'Mumbai',
        'state': 'Maharashtra',
        'postalCode': '400001',
      });
      companyProfileResp = await dio.get('/api/v1/company/profile', options: companyOpts);
    }
    logResult('STEP 3.1 (Company Profile GET)', companyProfileResp.statusCode == 200, 'Company Name: ${companyProfileResp.data['companyName']}');

    var transporterProfileResp = await dio.get('/api/v1/transporter/profile', options: transporterOpts);
    if (transporterProfileResp.statusCode != 200) {
      await dio.post('/api/v1/transporter/profile', options: transporterOpts, data: {
        'companyName': 'Swift Haulage Ltd',
        'registrationNumber': 'TREG554433',
        'taxId': 'TTAX112233',
        'address': '456 Freight Avenue',
        'city': 'Bengaluru',
        'state': 'Karnataka',
        'postalCode': '560001',
        'fleetSize': 25,
      });
      transporterProfileResp = await dio.get('/api/v1/transporter/profile', options: transporterOpts);
    }
    logResult('STEP 4.1 (Transporter Profile GET)', transporterProfileResp.statusCode == 200, 'Transporter Name: ${transporterProfileResp.data['companyName']}');

    final companyKycList = await dio.get('/api/v1/admin/kyc/companies', options: adminOpts);
    logResult('STEP 3.2 (Admin Company KYC List)', companyKycList.statusCode == 200, 'Total applications: ${(companyKycList.data as List).length}');

    final transporterKycList = await dio.get('/api/v1/admin/kyc/transporters', options: adminOpts);
    logResult('STEP 4.2 (Admin Transporter KYC List)', transporterKycList.statusCode == 200, 'Total applications: ${(transporterKycList.data as List).length}');

    // =================================================================
    // STEP 5: COMPLETE AUCTION WORKFLOW (Tender & Bidding)
    // =================================================================
    print('\n--- STEP 5: COMPLETE AUCTION WORKFLOW ---');

    final createTenderResp = await dio.post('/api/v1/tenders', options: companyOpts, data: {
      'title': 'E2E Logistics Route ${DateTime.now().millisecondsSinceEpoch}',
      'description': 'Full E2E verification shipment from Warehouse A to Distribution B',
      'pickupLocation': 'Mumbai, MH',
      'deliveryLocation': 'Bengaluru, KA',
      'materialType': 'General Cargo',
      'vehicleType': '32ft Multi-Axle Container',
      'weightTons': 15.5,
      'ceilingBudget': 50000.0,
    });
    final tenderId = createTenderResp.data['id'];
    logResult('STEP 5.1 (Company Create Tender)', createTenderResp.statusCode == 201 && tenderId != null, 'Tender ID: $tenderId');

    final tenderDetailsResp = await dio.get('/api/v1/tenders/$tenderId', options: companyOpts);
    logResult('STEP 5.2 (Fetch Tender Details)', tenderDetailsResp.statusCode == 200, 'Title: ${tenderDetailsResp.data['title']}');

    final placeBidResp = await dio.post('/api/v1/tenders/$tenderId/bids', options: transporterOpts, data: {
      'amount': 42000.0,
      'estimatedDays': 3,
      'remarks': 'Verified E2E test bid with 32ft container.',
    });
    final bidId = placeBidResp.data['id'];
    logResult('STEP 5.3 (Transporter Place Bid)', placeBidResp.statusCode == 201 && bidId != null, 'Bid ID: $bidId | Amount: 42000.0');

    final closeAuctionResp = await dio.put('/api/v1/tenders/$tenderId/close', options: companyOpts);
    logResult('STEP 5.4 (Company Close Auction)', closeAuctionResp.statusCode == 200, 'Tender Status: ${closeAuctionResp.data['status']}');

    final conflictBidResp = await dio.post('/api/v1/tenders/$tenderId/bids', options: transporterOpts, data: {
      'amount': 40000.0,
      'estimatedDays': 2,
      'remarks': 'Late bid attempt.',
    });
    logResult('STEP 5.5 (Bid on Closed Tender Rejection)', conflictBidResp.statusCode == 409, 'EXPECTED 409 Conflict: ${conflictBidResp.data['message']}');

    // =================================================================
    // STEP 6: NEGOTIATION
    // =================================================================
    print('\n--- STEP 6: NEGOTIATION ---');

    final startNegResp = await dio.post('/api/v1/negotiations', options: companyOpts, data: {
      'bidId': bidId,
      'remarks': 'Can you optimize price for immediate dispatch?',
    });
    final negotiationId = startNegResp.data['id'];
    logResult('STEP 6.1 (Initiate Negotiation)', startNegResp.statusCode == 201 && negotiationId != null, 'Negotiation ID: $negotiationId');

    final counterOfferResp = await dio.post('/api/v1/negotiations/$negotiationId/offers', options: transporterOpts, data: {
      'amount': 40000.0,
      'remarks': '40,000 INR is our best price.',
    });
    logResult('STEP 6.2 (Transporter Counter Offer)', counterOfferResp.statusCode == 200 || counterOfferResp.statusCode == 201, 'Negotiation Status: ${counterOfferResp.data['status']}');

    final acceptNegResp = await dio.post('/api/v1/negotiations/$negotiationId/accept', options: companyOpts);
    logResult('STEP 6.3 (Company Accept Negotiation)', acceptNegResp.statusCode == 200, 'Status: ${acceptNegResp.data['status']}');

    // =================================================================
    // STEP 7: CONTRACT
    // =================================================================
    print('\n--- STEP 7: CONTRACT ---');

    final awardResp = await dio.post(
      '/api/v1/tenders/$tenderId/award?negotiationId=$negotiationId',
      options: companyOpts,
      data: 'Standard BidHaul Freight Contract Terms 2026',
    );
    final contractId = awardResp.data['id'];
    logResult('STEP 7.1 (Award Tender & Create Contract)', awardResp.statusCode == 201 || awardResp.statusCode == 200, 'Contract ID: $contractId | Status: ${awardResp.data['status']}');

    final contractByTenderResp = await dio.get('/api/v1/contracts/tender/$tenderId', options: companyOpts);
    logResult('STEP 7.2 (Retrieve Contract by Tender)', contractByTenderResp.statusCode == 200, 'Contract Status: ${contractByTenderResp.data['status']}');

    final acceptContractResp = await dio.post('/api/v1/contracts/$contractId/accept', options: transporterOpts, data: {
      'accepted': true,
    });
    logResult('STEP 7.3 (Transporter Accept Contract)', acceptContractResp.statusCode == 200, 'Confirmed Backend Status: ${acceptContractResp.data['status']}');

    final verifiedContractResp = await dio.get('/api/v1/contracts/$contractId', options: companyOpts);
    logResult('STEP 7.4 (Verified Contract State GET)', verifiedContractResp.data['status'] == 'ACCEPTED', 'Contract Verified Status: ${verifiedContractResp.data['status']}');

    // =================================================================
    // STEP 8: DELIVERY & TRACKING
    // =================================================================
    print('\n--- STEP 8: DELIVERY & TRACKING ---');

    final deliveryByContractResp = await dio.get('/api/v1/deliveries/contract/$contractId', options: transporterOpts);
    final deliveryId = deliveryByContractResp.data['id'];
    logResult('STEP 8.1 (Retrieve Delivery by Contract)', deliveryByContractResp.statusCode == 200 && deliveryId != null, 'Delivery ID: $deliveryId | Status: ${deliveryByContractResp.data['status']}');

    final pickupResp = await dio.post('/api/v1/deliveries/$deliveryId/pickup', options: transporterOpts, data: {
      'location': 'Mumbai Port Terminal 2',
      'remarks': 'Cargo loaded and sealed.',
    });
    logResult('STEP 8.2 (Transporter Pickup)', pickupResp.statusCode == 200, 'Delivery Status: ${pickupResp.data['status']}');

    final verifiedPickup = await dio.get('/api/v1/deliveries/$deliveryId', options: transporterOpts);
    logResult('STEP 8.3 (Verified Pickup GET)', verifiedPickup.data['status'] == 'IN_TRANSIT', 'Status: ${verifiedPickup.data['status']}');

    final trackingUpdateResp = await dio.post('/api/v1/deliveries/$deliveryId/tracking', options: transporterOpts, data: {
      'location': 'Pune Highway Toll Gate',
      'remarks': 'Transit on schedule.',
    });
    logResult('STEP 8.4 (Add Tracking Update)', trackingUpdateResp.statusCode == 200 || trackingUpdateResp.statusCode == 201, 'Updated Location: Pune Highway Toll Gate');

    final trackingHistoryResp = await dio.get('/api/v1/deliveries/$deliveryId/tracking', options: companyOpts);
    final trackingList = trackingHistoryResp.data as List;
    logResult('STEP 8.5 (Retrieve Tracking History)', trackingHistoryResp.statusCode == 200, 'Events count: ${trackingList.length}');

    final markDeliveredResp = await dio.post('/api/v1/deliveries/$deliveryId/delivered', options: transporterOpts, data: {
      'location': 'Bengaluru Central Distribution Hub',
      'remarks': 'Offloaded and verified intact.',
    });
    logResult('STEP 8.6 (Transporter Mark Delivered)', markDeliveredResp.statusCode == 200, 'Delivery Status: ${markDeliveredResp.data['status']}');

    final verifiedDelivered = await dio.get('/api/v1/deliveries/$deliveryId', options: companyOpts);
    logResult('STEP 8.7 (Verified DELIVERED State GET)', verifiedDelivered.data['status'] == 'DELIVERED', 'Status: ${verifiedDelivered.data['status']}');

    final confirmDeliveryResp = await dio.post('/api/v1/deliveries/$deliveryId/confirm', options: companyOpts, data: {
      'rating': 5.0,
    });
    logResult('STEP 8.8 (Company Confirm Delivery & Rating)', confirmDeliveryResp.statusCode == 200, 'Delivery Status: ${confirmDeliveryResp.data['status']}');

    final verifiedCompleted = await dio.get('/api/v1/deliveries/$deliveryId', options: companyOpts);
    logResult('STEP 8.9 (Verified COMPLETED State GET)', verifiedCompleted.data['status'] == 'COMPLETED', 'Final Delivery Status: ${verifiedCompleted.data['status']}');

    // =================================================================
    // STEP 9 & 10: SUBSCRIPTION & INVOICE
    // =================================================================
    print('\n--- STEPS 9 & 10: SUBSCRIPTION & INVOICE ---');

    final plansResp = await dio.get('/api/v1/subscriptions/plans', options: companyOpts);
    final plansList = plansResp.data as List;
    logResult('STEP 9.1 (Retrieve Subscription Plans)', plansResp.statusCode == 200 && plansList.isNotEmpty, 'Available Plans: ${plansList.length}');
    final planId = plansList.first['id'];

    final currentSubResp = await dio.get('/api/v1/subscriptions/me/status', options: companyOpts);

    final subscribeResp = await dio.post('/api/v1/subscriptions/subscribe', options: companyOpts, data: {
      'planId': planId,
      'billingCycle': 'MONTHLY',
    });
    final subSuccess = subscribeResp.statusCode == 200 || subscribeResp.statusCode == 201 || (subscribeResp.statusCode == 409 && currentSubResp.statusCode == 200);
    final subscriptionId = subscribeResp.data?['id'] ?? currentSubResp.data?['id'];
    logResult('STEP 9.2 (Subscribe / Verify Active Subscription)', subSuccess, 'Subscription ID: $subscriptionId | Active Status: ${currentSubResp.data?['status']}');

    final invoicesResp = await dio.get('/api/v1/invoices/my', options: companyOpts);
    final invoiceList = invoicesResp.data as List;
    logResult('STEP 10.1 (Retrieve My Invoices)', invoicesResp.statusCode == 200, 'Invoices count: ${invoiceList.length}');

    final pendingInvoice = invoiceList.firstWhere(
      (inv) => inv['subscriptionId'] == subscriptionId || inv['status'] == 'PENDING',
      orElse: () => invoiceList.isNotEmpty ? invoiceList.first : null,
    );
    final invoiceId = pendingInvoice?['id'];
    logResult('STEP 10.2 (Retrieve Invoice Details)', pendingInvoice != null, 'Invoice ID: $invoiceId | Amount: ${pendingInvoice['amount']} | Status: ${pendingInvoice['status']}');

    // =================================================================
    // STEP 11: RAZORPAY PAYMENT INTEGRATION
    // =================================================================
    print('\n--- STEP 11: RAZORPAY PAYMENT INTEGRATION ---');

    if (invoiceId != null) {
      final orderResp = await dio.post('/api/v1/payments/orders', options: companyOpts, data: {
        'invoiceId': invoiceId,
      });
      final razorpayOrderId = orderResp.data['razorpayOrderId'];
      final razorpayKeyId = orderResp.data['keyId'];
      logResult('STEP 11.1 (Backend Create Razorpay Order)', orderResp.statusCode == 201 || orderResp.statusCode == 200, 'Razorpay Order ID: $razorpayOrderId | Key: $razorpayKeyId');

      final invalidVerifyResp = await dio.post('/api/v1/payments/verify', options: companyOpts, data: {
        'razorpayOrderId': razorpayOrderId ?? 'order_dummy_123',
        'razorpayPaymentId': 'pay_TEST_123456',
        'razorpaySignature': 'INVALID_SIGNATURE_HASH',
      });
      logResult('STEP 11.2 (Invalid Razorpay Signature Rejection)', invalidVerifyResp.statusCode == 400 || invalidVerifyResp.statusCode == 403, 'Status: ${invalidVerifyResp.statusCode} (No False Success!)');
    }

    // =================================================================
    // STEP 12: NOTIFICATIONS
    // =================================================================
    print('\n--- STEP 12: NOTIFICATIONS ---');

    final notifsResp = await dio.get('/api/v1/notifications/my', options: companyOpts);
    final notifsList = notifsResp.data['content'] as List;
    logResult('STEP 12.1 (Retrieve Notifications)', notifsResp.statusCode == 200, 'Total notifications: ${notifsList.length}');

    final unreadResp = await dio.get('/api/v1/notifications/my/unread', options: companyOpts);
    final unreadList = unreadResp.data['content'] as List;
    logResult('STEP 12.2 (Retrieve Unread Notifications)', unreadResp.statusCode == 200, 'Unread count: ${unreadList.length}');

    final countResp = await dio.get('/api/v1/notifications/my/unread/count', options: companyOpts);
    logResult('STEP 12.3 (Unread Notification Count)', countResp.statusCode == 200, 'Count: ${countResp.data}');

    final markAllResp = await dio.patch('/api/v1/notifications/my/read-all', options: companyOpts);
    logResult('STEP 12.4 (Mark All Notifications Read)', markAllResp.statusCode == 204 || markAllResp.statusCode == 200, 'Success: ${markAllResp.statusCode}');

    final finalCountResp = await dio.get('/api/v1/notifications/my/unread/count', options: companyOpts);
    logResult('STEP 12.5 (Verified Unread Count Zero)', finalCountResp.data == 0, 'Final Unread Count: ${finalCountResp.data}');

    // =================================================================
    // STEPS 13 & 14: ADMIN & SUPER ADMIN GOVERNANCE
    // =================================================================
    print('\n--- STEPS 13 & 14: ADMIN & SUPER ADMIN GOVERNANCE ---');

    final adminDash = await dio.get('/api/v1/admin/dashboard', options: adminOpts);
    logResult('STEP 13.1 (Admin Dashboard Live Metrics)', adminDash.statusCode == 200, 'Users: ${adminDash.data['totalUsers']} | Companies: ${adminDash.data['activeCompanies']}');

    final tempEmail = 'gov_e2e_${DateTime.now().millisecondsSinceEpoch}@bidhaul.com';
    final tempSignup = await dio.post('/api/v1/auth/signup', data: {
      'email': tempEmail,
      'password': 'Password123!',
      'fullName': 'Temp Gov User',
      'phone': '9112233445',
      'role': 'COMPANY',
    });
    final tempUserId = tempSignup.data['user']['id'];

    final suspendUser = await dio.patch('/api/v1/admin/users/$tempUserId/suspend', options: adminOpts);
    logResult('STEP 13.2 (Admin Suspend User)', suspendUser.statusCode == 200 || suspendUser.statusCode == 204, 'User $tempUserId suspended');

    final suspendedLogin = await dio.post('/api/v1/auth/login', data: {
      'email': tempEmail,
      'password': 'Password123!',
    });
    logResult('STEP 13.3 (Suspended User Login Blocked)', suspendedLogin.statusCode == 403, 'Login rejected with status: ${suspendedLogin.statusCode}');

    final activateUser = await dio.patch('/api/v1/admin/users/$tempUserId/activate', options: adminOpts);
    logResult('STEP 13.4 (Admin Reactivate User)', activateUser.statusCode == 200 || activateUser.statusCode == 204, 'User $tempUserId reactivated');

    final reactivatedLogin = await dio.post('/api/v1/auth/login', data: {
      'email': tempEmail,
      'password': 'Password123!',
    });
    logResult('STEP 13.5 (Reactivated User Login Allowed)', reactivatedLogin.statusCode == 200, 'Login succeeded with status: ${reactivatedLogin.statusCode}');

    // =================================================================
    // STEP 15: AUDIT LOGS
    // =================================================================
    print('\n--- STEP 15: AUDIT LOGS ---');

    final auditLogsResp = await dio.get('/api/v1/admin/audit-logs', options: adminOpts);
    logResult('STEP 15.1 (Retrieve Audit Logs)', auditLogsResp.statusCode == 200, 'Total Audit Logs: ${auditLogsResp.data['totalElements']}');

    // =================================================================
    // STEP 16: ROLE ISOLATION
    // =================================================================
    print('\n--- STEP 16: ROLE ISOLATION ---');

    final unauthCompanyAdmin = await dio.get('/api/v1/admin/dashboard', options: companyOpts);
    logResult('STEP 16.1 (Company Access to Admin Dashboard)', unauthCompanyAdmin.statusCode == 403, 'Status: ${unauthCompanyAdmin.statusCode} (403 FORBIDDEN)');

    final unauthTransporterAdmin = await dio.get('/api/v1/admin/audit-logs', options: transporterOpts);
    logResult('STEP 16.2 (Transporter Access to Audit Logs)', unauthTransporterAdmin.statusCode == 403, 'Status: ${unauthTransporterAdmin.statusCode} (403 FORBIDDEN)');

    // =================================================================
    // SUMMARY OF E2E TEST RESULTS
    // =================================================================
    print('\n================================================================');
    print('BIDHAUL E2E TEST EXECUTION SUMMARY');
    print('================================================================');
    var passedCount = 0;
    var failedCount = 0;
    results.forEach((key, val) {
      if (val == 'PASS') passedCount++;
      else failedCount++;
      print('$key: $val');
    });

    print('\nTOTAL TESTS EXECUTION: ${results.length} | PASSED: $passedCount | FAILED: $failedCount');
    print('================================================================\n');

  } catch (e, stack) {
    print('E2E TEST CRITICAL ERROR: $e');
    print(stack);
  }
}
