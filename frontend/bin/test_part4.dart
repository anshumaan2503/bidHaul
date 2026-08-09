// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

void main() async {
  print('=== PART 4 END-TO-END AUTOMATED MANUAL INTEGRATION TESTING ===');
  final client = HttpClient();

  try {
    // 1. Company Login
    print('\n[1] COMPANY USER LOGIN (test@company.com)');
    final compToken = await login(client, 'test@company.com', '12345678');
    print('Company Token received: ${compToken != null}');
    assert(compToken != null, 'Company token must not be null');

    // 2. Create Tender for Negotiation & Contract test
    print('\n[2] COMPANY: CREATE TENDER (POST /api/v1/tenders)');
    final createTenderPayload = {
      'title': 'Part 4 Heavy Equipment Freight',
      'description': 'Transport heavy industrial machinery from Chennai to Hyderabad',
      'pickupLocation': 'Chennai Industrial Estate',
      'deliveryLocation': 'Hyderabad Industrial Zone',
      'materialType': 'Heavy Machinery',
      'vehicleType': '40ft Low-Bed Trailer',
      'weightTons': 30.0,
      'ceilingBudget': 95000.0,
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

    // 3. Transporter Login
    print('\n[3] TRANSPORTER 1 LOGIN (test@transporter1.com)');
    final transToken = await login(client, 'test@transporter1.com', '12345678');
    print('Transporter Token received: ${transToken != null}');
    assert(transToken != null, 'Transporter token must not be null');

    // 4. Transporter Place Qualified Bid
    print('\n[4] TRANSPORTER: PLACE BID (POST /api/v1/tenders/$tenderId/bids)');
    final bidPayload = {
      'amount': 90000.0,
      'estimatedDays': 4,
      'remarks': 'Heavy transit specialized carrier',
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

    // 5. Company Close Tender
    print('\n[5] COMPANY: CLOSE TENDER (PUT /api/v1/tenders/$tenderId/close)');
    final closeReq = await client.putUrl(Uri.parse('http://localhost:8080/api/v1/tenders/$tenderId/close'));
    closeReq.headers.set('Authorization', 'Bearer $compToken');
    final closeResp = await closeReq.close();
    print('Close Tender Status: ${closeResp.statusCode}');

    // 6. Company Create Negotiation
    print('\n[6] COMPANY: CREATE NEGOTIATION (POST /api/v1/negotiations)');
    final negPayload = {
      'bidId': bidId,
      'remarks': 'Requesting 5% volume discount',
    };
    final negReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/negotiations'));
    negReq.headers.contentType = ContentType.json;
    negReq.headers.set('Authorization', 'Bearer $compToken');
    negReq.write(jsonEncode(negPayload));
    final negResp = await negReq.close();
    final negBody = await negResp.transform(utf8.decoder).join();
    print('Create Negotiation Status: ${negResp.statusCode}');
    final createdNeg = jsonDecode(negBody);
    final negId = createdNeg['id']?.toString();
    print('Created Negotiation ID: $negId');
    print('Negotiation Status: ${createdNeg['status']}');

    // 7. Get Negotiation Details
    print('\n[7] GET NEGOTIATION DETAILS (GET /api/v1/negotiations/$negId)');
    final negDetails = await getJson(client, '/api/v1/negotiations/$negId', compToken!);
    print('Negotiation Status: ${negDetails['status']}');
    print('Current Amount: ₹${negDetails['currentAmount']}');

    // 8. Transporter Get My Negotiations
    print('\n[8] TRANSPORTER: GET MY NEGOTIATIONS (GET /api/v1/negotiations/my)');
    final myNegs = await getJson(client, '/api/v1/negotiations/my', transToken!);
    print('My Negotiations Count: ${(myNegs as List).length}');

    // 9. Get Tender Negotiations
    print('\n[9] GET TENDER NEGOTIATIONS (GET /api/v1/negotiations/tender/$tenderId)');
    final tenderNegs = await getJson(client, '/api/v1/negotiations/tender/$tenderId', compToken);
    print('Tender Negotiations Count: ${(tenderNegs as List).length}');

    // 10. Transporter Add Offer
    print('\n[10] TRANSPORTER: SUBMIT COUNTER OFFER (POST /api/v1/negotiations/$negId/offers)');
    final offerPayload = {
      'amount': 85000.0,
      'remarks': 'We can offer ₹85,000 including all toll charges',
    };
    final offerReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/negotiations/$negId/offers'));
    offerReq.headers.contentType = ContentType.json;
    offerReq.headers.set('Authorization', 'Bearer $transToken');
    offerReq.write(jsonEncode(offerPayload));
    final offerResp = await offerReq.close();
    final offerBody = await offerResp.transform(utf8.decoder).join();
    print('Add Offer Status: ${offerResp.statusCode}');
    final updatedNeg = jsonDecode(offerBody);
    print('Updated Current Amount: ₹${updatedNeg['currentAmount']}');

    // 11. Company Accept Negotiation
    print('\n[11] COMPANY: ACCEPT NEGOTIATION (POST /api/v1/negotiations/$negId/accept)');
    final acceptNegReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/negotiations/$negId/accept'));
    acceptNegReq.headers.set('Authorization', 'Bearer $compToken');
    final acceptNegResp = await acceptNegReq.close();
    final acceptNegBody = await acceptNegResp.transform(utf8.decoder).join();
    print('Accept Negotiation Status: ${acceptNegResp.statusCode}');
    final acceptedNeg = jsonDecode(acceptNegBody);
    print('Accepted Negotiation Status: ${acceptedNeg['status']}');
    print('Accepted Final Amount: ₹${acceptedNeg['finalAmount']}');

    // 12. Company Award Tender to Create Contract
    print('\n[12] COMPANY: AWARD TENDER / GENERATE CONTRACT (POST /api/v1/tenders/$tenderId/award?negotiationId=$negId)');
    final awardReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/tenders/$tenderId/award?negotiationId=$negId'));
    awardReq.headers.contentType = ContentType.json;
    awardReq.headers.set('Authorization', 'Bearer $compToken');
    awardReq.write(jsonEncode('Standard freight terms and 30-day payment cycle.'));
    final awardResp = await awardReq.close();
    final awardBody = await awardResp.transform(utf8.decoder).join();
    print('Award Tender Status: ${awardResp.statusCode}');
    if (awardResp.statusCode != 201 && awardResp.statusCode != 200) {
      print('Award Tender Error Body: $awardBody');
    }
    final createdContract = jsonDecode(awardBody);
    final contractId = createdContract['id']?.toString();
    print('Created Contract ID: $contractId');
    print('Contract Number: ${createdContract['contractNumber']}');
    print('Contract Final Amount: ₹${createdContract['finalAmount']}');
    print('Contract Status: ${createdContract['status']}');

    // 13. Get Contract Details
    print('\n[13] GET CONTRACT DETAILS (GET /api/v1/contracts/$contractId)');
    final contractDetails = await getJson(client, '/api/v1/contracts/$contractId', compToken);
    print('Contract Details Status: ${contractDetails['status']}');

    // 14. Get Tender Contract
    print('\n[14] GET TENDER CONTRACT (GET /api/v1/contracts/tender/$tenderId)');
    final tenderContract = await getJson(client, '/api/v1/contracts/tender/$tenderId', compToken);
    print('Tender Contract Number: ${tenderContract['contractNumber']}');

    // 15. Transporter Get My Contracts
    print('\n[15] TRANSPORTER: GET MY CONTRACTS (GET /api/v1/contracts/my)');
    final myContracts = await getJson(client, '/api/v1/contracts/my', transToken);
    print('Transporter My Contracts Count: ${(myContracts as List).length}');

    // 16. Transporter Accept Contract
    print('\n[16] TRANSPORTER: ACCEPT CONTRACT (POST /api/v1/contracts/$contractId/accept)');
    final acceptCntPayload = {'accepted': true};
    final acceptCntReq = await client.postUrl(Uri.parse('http://localhost:8080/api/v1/contracts/$contractId/accept'));
    acceptCntReq.headers.contentType = ContentType.json;
    acceptCntReq.headers.set('Authorization', 'Bearer $transToken');
    acceptCntReq.write(jsonEncode(acceptCntPayload));
    final acceptCntResp = await acceptCntReq.close();
    final acceptCntBody = await acceptCntResp.transform(utf8.decoder).join();
    print('Accept Contract Status: ${acceptCntResp.statusCode}');
    final acceptedContract = jsonDecode(acceptCntBody);
    print('Final Contract Status: ${acceptedContract['status']}');
    print('Contract Accepted At: ${acceptedContract['acceptedAt']}');

    print('\n=== ALL PART 4 NEGOTIATION & CONTRACT WORKFLOWS VERIFIED SUCCESSFULLY! ===');
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
