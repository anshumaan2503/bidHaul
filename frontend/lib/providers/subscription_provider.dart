import 'package:flutter/material.dart';
import '../models/subscription_plan.dart';
import '../models/user_subscription.dart';
import '../services/subscription_service.dart';

class SubscriptionProvider with ChangeNotifier {
  final SubscriptionService _service;

  List<SubscriptionPlanModel> _plans = [];
  UserSubscriptionModel? _currentSubscription;
  UserSubscriptionModel? _subscriptionStatus;
  List<UserSubscriptionModel> _subscriptionHistory = [];

  bool _isLoading = false;
  String? _errorMessage;

  SubscriptionProvider({SubscriptionService? service})
      : _service = service ?? SubscriptionService();

  List<SubscriptionPlanModel> get plans => _plans;
  UserSubscriptionModel? get currentSubscription => _currentSubscription;
  UserSubscriptionModel? get subscriptionStatus => _subscriptionStatus;
  List<UserSubscriptionModel> get subscriptionHistory => _subscriptionHistory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchPlans() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _plans = await _service.getActivePlans();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCurrentSubscription() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentSubscription = await _service.getMySubscription();
    } catch (e) {
      _currentSubscription = null;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSubscriptionStatus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _subscriptionStatus = await _service.getMySubscriptionStatus();
    } catch (e) {
      _subscriptionStatus = null;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSubscriptionHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _subscriptionHistory = await _service.getMySubscriptionHistory();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserSubscriptionModel?> subscribe(
    String planId, {
    String billingCycle = 'MONTHLY',
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final req = SubscribeRequest(planId: planId, billingCycle: billingCycle);
      final result = await _service.subscribe(req);
      _subscriptionStatus = result;
      await fetchSubscriptionHistory();
      return result;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<SubscriptionPlanModel?> createPlan(CreateSubscriptionPlanRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final plan = await _service.createPlan(request);
      await fetchPlans();
      return plan;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
