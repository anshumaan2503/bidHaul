import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';
import '../models/auth_request.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated }

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;
  AuthStatus _status = AuthStatus.uninitialized;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated && _user != null;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> restoreSession() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final storage = await StorageService.getInstance();
      final accessToken = storage.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        _user = null;
        _status = AuthStatus.unauthenticated;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // First load cached user for snappy UX
      _user = storage.getUser();

      try {
        // Validate and refresh current user profile from server
        final liveUser = await _authService.getCurrentUser();
        _user = liveUser;
        await storage.setUser(liveUser);
        _status = AuthStatus.authenticated;
      } catch (err) {
        // If GET /me fails, check if we still have a cached user or if token is dead
        if (_user != null) {
          _status = AuthStatus.authenticated;
        } else {
          await storage.clearSession();
          _user = null;
          _status = AuthStatus.unauthenticated;
        }
      }

      _isLoading = false;
      notifyListeners();
      return isAuthenticated;
    } catch (e) {
      _user = null;
      _status = AuthStatus.unauthenticated;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    String? role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final req = LoginRequest(
        email: email,
        password: password,
        role: role,
      );
      final response = await _authService.login(req);

      final storage = await StorageService.getInstance();
      await storage.setAccessToken(response.token);
      await storage.setRefreshToken(response.refreshToken);
      await storage.setUser(response.user);

      _user = response.user;
      _status = AuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = AuthStatus.unauthenticated;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup({
    required String email,
    required String password,
    required String fullName,
    String? companyName,
    String? phone,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final req = SignupRequest(
        email: email,
        password: password,
        fullName: fullName,
        companyName: companyName,
        phone: phone,
        role: role,
      );
      final response = await _authService.signup(req);

      final storage = await StorageService.getInstance();
      await storage.setAccessToken(response.token);
      await storage.setRefreshToken(response.refreshToken);
      await storage.setUser(response.user);

      _user = response.user;
      _status = AuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = AuthStatus.unauthenticated;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> adminLogin({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final req = AdminLoginRequest(
        email: email,
        password: password,
      );
      final response = await _authService.adminLogin(req);

      final storage = await StorageService.getInstance();
      await storage.setAccessToken(response.token);
      await storage.setRefreshToken(response.refreshToken);
      await storage.setUser(response.user);

      _user = response.user;
      _status = AuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = AuthStatus.unauthenticated;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final storage = await StorageService.getInstance();
    await storage.clearSession();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }
}
