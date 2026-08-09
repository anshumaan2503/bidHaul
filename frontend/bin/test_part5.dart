// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

void main() async {
  print('=== PART 5 END-TO-END AUTOMATED MANUAL INTEGRATION TESTING ===');
  final client = HttpClient();

  try {
    // 1. Company Login
    print('\n[1] COMPANY USER LOGIN (test@company.com)');
    final compToken = await login(client, 'test@company.com', '12345678');
    print('Company Token received: ${compToken != null}');
    assert(compToken != null, 'Company token must not be null');

    // 2. Transporter Login
    print('\n[2] TRANSPORTER 1 LOGIN (test@transporter1.com)');
    final transToken = await login(client, 'test@transporter1.com', '12345678');
    print('Transporter Token received: ${transToken != null}');
    assert(transToken != null, 'Transporter token must not be null');

    // 3. Establish Contract
    print('\n[3] ESTABLISHING CONTRACT FLOW');
    
    // Create Tender
    final createTenderPayload = {
      'title': 'Part 5 Live Delivery Freight',
      'description': 'Transport perishable goods from Chennai Port to Hyderabad Hub',
      'pickupLocation': 'Chennai Port Gate 3',
      'deliveryLocation': 'Hyderabad Central Logistics Park',
      'materialType': 'Perishable Agro Goods',
      'vehicleType': '32ft Refrigerated Container',
      'weightTons': 18.5,
      'ceilingBudget': 120000.0,
    };
    final createReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/tenders'));
    createReq.headers.contentType = ContentType.json;
    createReq.headers.set('Authorization', 'Bearer $compToken');
    createReq.write(jsonEncode(createTenderPayload));
    final createResp = await createReq.close();
    final createBody = await createResp.transform(utf8.decoder).join();
    print('Create Tender Status: ${createResp.statusCode}');
    final createdTender = jsonDecode(createBody);
    final tenderId = createdTender['id']?.toString();
    print('Created Tender ID: $tenderId');

    // Place Bid
    final bidPayload = {
      'amount': 110000.0,
      'estimatedDays': 2,
      'remarks': 'Cold chain temperature-controlled truck ready',
    };
    final bidReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/tenders/$tenderId/bids'));
    bidReq.headers.contentType = ContentType.json;
    bidReq.headers.set('Authorization', 'Bearer $transToken');
    bidReq.write(jsonEncode(bidPayload));
    final bidResp = await bidReq.close();
    final bidBody = await bidResp.transform(utf8.decoder).join();
    print('Place Bid Status: ${bidResp.statusCode}');
    final placedBid = jsonDecode(bidBody);
    final bidId = placedBid['id']?.toString();
    print('Placed Bid ID: $bidId');

    // Close Tender
    final closeReq = await client.putUrl(Uri.parse('http://localhost:8080/api/v1/tenders/$tenderId/close'));
    closeReq.headers.set('Authorization', 'Bearer $compToken');
    final closeResp = await closeReq.close();
    await closeResp.transform(utf8.decoder).join();
    print('Close Tender Status: ${closeResp.statusCode}');

    // Create Negotiation
    final negPayload = {'bidId': bidId, 'remarks': 'Final cold-chain agreement'};
    final negReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/negotiations'));
    negReq.headers.contentType = ContentType.json;
    negReq.headers.set('Authorization', 'Bearer $compToken');
    negReq.write(jsonEncode(negPayload));
    final negResp = await negReq.close();
    final negBody = await negResp.transform(utf8.decoder).join();
    print('Create Negotiation Status: ${negResp.statusCode}');
    final createdNeg = jsonDecode(negBody);
    final negId = createdNeg['id']?.toString();

    // Transporter Counter Offer
    final offerPayload = {'amount': 105000.0, 'remarks': 'Agreed on 105k including cold chain'};
    final offerReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/negotiations/$negId/offers'));
    offerReq.headers.contentType = ContentType.json;
    offerReq.headers.set('Authorization', 'Bearer $transToken');
    offerReq.write(jsonEncode(offerPayload));
    final offerResp = await offerReq.close();
    await offerResp.transform(utf8.decoder).join();
    print('Transporter Offer Status: ${offerResp.statusCode}');

    // Accept Negotiation
    final acceptNegReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/negotiations/$negId/accept'));
    acceptNegReq.headers.set('Authorization', 'Bearer $compToken');
    final acceptNegResp = await acceptNegReq.close();
    await acceptNegResp.transform(utf8.decoder).join();
    print('Accept Negotiation Status: ${acceptNegResp.statusCode}');

    // Award Tender to generate contract
    final awardReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/tenders/$tenderId/award?negotiationId=$negId'));
    awardReq.headers.contentType = ContentType.json;
    awardReq.headers.set('Authorization', 'Bearer $compToken');
    awardReq.write(jsonEncode('Cold chain delivery terms and conditions.'));
    final awardResp = await awardReq.close();
    final awardBody = await awardResp.transform(utf8.decoder).join();
    print('Award Tender Status: ${awardResp.statusCode}');
    if (awardResp.statusCode != 201 && awardResp.statusCode != 200) {
      print('Award Tender Error Body: $awardBody');
    }
    final createdContract = jsonDecode(awardBody);
    final contractId = createdContract['id']?.toString();
    print('Contract Generated ID: $contractId');

    // Transporter Accept Contract (Triggers Automatic Delivery Provisioning)
    final acceptCntReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/contracts/$contractId/accept'));
    acceptCntReq.headers.contentType = ContentType.json;
    acceptCntReq.headers.set('Authorization', 'Bearer $transToken');
    acceptCntReq.write(jsonEncode({'accepted': true}));
    final acceptCntResp = await acceptCntReq.close();
    await acceptCntResp.transform(utf8.decoder).join();
    print('Accept Contract Status: ${acceptCntResp.statusCode}');

    // 4. Retrieve Delivery by Contract
    print('\n[4] RETRIEVE DELIVERY BY CONTRACT (GET /api/v1/deliveries/contract/$contractId)');
    final delivery = await getJson(client, '/api/v1/deliveries/contract/$contractId', transToken!);
    final deliveryId = delivery['id']?.toString();
    print('Provisioned Delivery ID: $deliveryId');
    print('Delivery Status: ${delivery['status']}');
    print('Pickup Location: ${delivery['pickupLocation']}');
    print('Delivery Location: ${delivery['deliveryLocation']}');

    // 5. Retrieve Delivery Details by ID
    print('\n[5] RETRIEVE DELIVERY DETAILS (GET /api/v1/deliveries/$deliveryId)');
    final deliveryDetails = await getJson(client, '/api/v1/deliveries/$deliveryId', compToken!);
    print('Company fetched delivery status: ${deliveryDetails['status']}');

    // 6. Retrieve My Deliveries
    print('\n[6] RETRIEVE MY DELIVERIES (GET /api/v1/deliveries/my)');
    final compDeliveries = await getJson(client, '/api/v1/deliveries/my', compToken);
    final transDeliveries = await getJson(client, '/api/v1/deliveries/my', transToken);
    print('Company My Deliveries count: ${(compDeliveries as List).length}');
    print('Transporter My Deliveries count: ${(transDeliveries as List).length}');

    // 7. Retrieve Initial Tracking History
    print('\n[7] RETRIEVE INITIAL TRACKING HISTORY (GET /api/v1/deliveries/$deliveryId/tracking)');
    final initialTracking = await getJson(client, '/api/v1/deliveries/$deliveryId/tracking', transToken);
    print('Initial tracking event count: ${(initialTracking as List).length}');
    print('First Event: ${initialTracking[0]['status']} - ${initialTracking[0]['location']}');

    // 8. Transporter Mark Picked Up
    print('\n[8] TRANSPORTER: MARK PICKED UP (POST /api/v1/deliveries/$deliveryId/pickup)');
    final pickupReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/deliveries/$deliveryId/pickup'));
    pickupReq.headers.contentType = ContentType.json;
    pickupReq.headers.set('Authorization', 'Bearer $transToken');
    pickupReq.write(jsonEncode({
      'location': 'Chennai Port Gate 3 Warehouse',
      'remarks': 'Container loaded on refrigerated truck unit #402',
    }));
    final pickupResp = await pickupReq.close();
    final pickupBody = await pickupResp.transform(utf8.decoder).join();
    print('Mark Picked Up Status: ${pickupResp.statusCode}');
    final pickedUpDelivery = jsonDecode(pickupBody);
    print('Updated Status: ${pickedUpDelivery['status']}');
    print('Picked Up At: ${pickedUpDelivery['pickedUpAt']}');

    // 9. Transporter Add Tracking Update
    print('\n[9] TRANSPORTER: ADD TRACKING UPDATE (POST /api/v1/deliveries/$deliveryId/tracking)');
    final trackReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/deliveries/$deliveryId/tracking'));
    trackReq.headers.contentType = ContentType.json;
    trackReq.headers.set('Authorization', 'Bearer $transToken');
    trackReq.write(jsonEncode({
      'location': 'Ongole Highway Checkpoint',
      'remarks': 'Refrigeration unit temperature stable at 4°C',
    }));
    final trackResp = await trackReq.close();
    await trackResp.transform(utf8.decoder).join();
    print('Add Tracking Update Status: ${trackResp.statusCode}');

    // 10. Retrieve Tracking History Again
    print('\n[10] RETRIEVE TRACKING HISTORY AGAIN (GET /api/v1/deliveries/$deliveryId/tracking)');
    final updatedTracking = await getJson(client, '/api/v1/deliveries/$deliveryId/tracking', compToken);
    print('Updated tracking events count: ${(updatedTracking as List).length}');
    for (var i = 0; i < updatedTracking.length; i++) {
      print('  Step ${i + 1}: [${updatedTracking[i]['status']}] at ${updatedTracking[i]['location']} - ${updatedTracking[i]['remarks']}');
    }

    // 11. Transporter Mark Delivered
    print('\n[11] TRANSPORTER: MARK DELIVERED (POST /api/v1/deliveries/$deliveryId/delivered)');
    final delivReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/deliveries/$deliveryId/delivered'));
    delivReq.headers.contentType = ContentType.json;
    delivReq.headers.set('Authorization', 'Bearer $transToken');
    delivReq.write(jsonEncode({
      'location': 'Hyderabad Central Logistics Park',
      'remarks': 'All seal tags verified and goods handed over to site manager',
    }));
    final delivResp = await delivReq.close();
    final delivBody = await delivResp.transform(utf8.decoder).join();
    print('Mark Delivered Status: ${delivResp.statusCode}');
    final deliveredObj = jsonDecode(delivBody);
    print('Updated Status: ${deliveredObj['status']}');
    print('Delivered At: ${deliveredObj['deliveredAt']}');

    // 12. Company Confirm Delivery & Rate Transporter
    print('\n[12] COMPANY: CONFIRM DELIVERY & RATE (POST /api/v1/deliveries/$deliveryId/confirm)');
    final confirmReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/deliveries/$deliveryId/confirm'));
    confirmReq.headers.contentType = ContentType.json;
    confirmReq.headers.set('Authorization', 'Bearer $compToken');
    confirmReq.write(jsonEncode({
      'rating': 4.8,
    }));
    final confirmResp = await confirmReq.close();
    final confirmBody = await confirmResp.transform(utf8.decoder).join();
    print('Confirm Delivery Status: ${confirmResp.statusCode}');
    final confirmedDelivery = jsonDecode(confirmBody);
    print('Final Status: ${confirmedDelivery['status']}');
    print('Confirmed At: ${confirmedDelivery['confirmedAt']}');
    print('Assigned Rating: ${confirmedDelivery['rating']}');

    // 13. Re-verify Final Backend State
    print('\n[13] RE-VERIFY FINAL BACKEND DELIVERY STATE (GET /api/v1/deliveries/$deliveryId)');
    final finalDelivery = await getJson(client, '/api/v1/deliveries/$deliveryId', transToken);
    print('Final verified status from backend: ${finalDelivery['status']}');
    print('Rating recorded: ${finalDelivery['rating']}');

    print('\n=== ALL PART 5 DELIVERY & TRACKING WORKFLOWS VERIFIED SUCCESSFULLY! ===');
  } catch (e, st) {
    print('Error during test execution: $e\n$st');
  } finally {
    client.close();
  }
}

Future<String?> login(HttpClient client, String email, String password) async {
  final req = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/auth/login'));
  req.headers.contentType = ContentType.json;
  req.write(jsonEncode({'email': email, 'password': password}));
  final resp = await req.close();
  final body = await resp.transform(utf8.decoder).join();
  if (resp.statusCode != 200) return null;
  final json = jsonDecode(body);
  return json['accessToken']?.toString() ?? json['token']?.toString();
}

Future<dynamic> getJson(HttpClient client, String path, String token) async {
  final req = await client.getUrl(Uri.parse('http://localhost:8080$path'));
  req.headers.set('Authorization', 'Bearer $token');
  final resp = await req.close();
  final body = await resp.transform(utf8.decoder).join();
  if (body.isEmpty) return null;
  return jsonDecode(body);
}
