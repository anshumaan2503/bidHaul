import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';

class StorageService {
  static const String keyAccessToken = 'bidhaul_access_token';
  static const String keyRefreshToken = 'bidhaul_refresh_token';
  static const String keyUserData = 'bidhaul_user_data';
  static const String keyBaseUrl = 'bidhaul_base_url';

  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // Access Token
  Future<bool> setAccessToken(String token) async {
    return await _prefs?.setString(keyAccessToken, token) ?? false;
  }

  String? getAccessToken() {
    return _prefs?.getString(keyAccessToken);
  }

  // Refresh Token
  Future<bool> setRefreshToken(String token) async {
    return await _prefs?.setString(keyRefreshToken, token) ?? false;
  }

  String? getRefreshToken() {
    return _prefs?.getString(keyRefreshToken);
  }

  // User Data
  Future<bool> setUser(UserModel user) async {
    final jsonStr = jsonEncode(user.toJson());
    return await _prefs?.setString(keyUserData, jsonStr) ?? false;
  }

  UserModel? getUser() {
    final jsonStr = _prefs?.getString(keyUserData);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  // Base URL
  Future<bool> setBaseUrl(String url) async {
    return await _prefs?.setString(keyBaseUrl, url) ?? false;
  }

  String? getBaseUrl() {
    return _prefs?.getString(keyBaseUrl);
  }

  // Clear Session Data
  Future<void> clearSession() async {
    await _prefs?.remove(keyAccessToken);
    await _prefs?.remove(keyRefreshToken);
    await _prefs?.remove(keyUserData);
  }
}
