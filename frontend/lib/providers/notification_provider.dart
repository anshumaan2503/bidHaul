import 'package:flutter/foundation.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService;

  NotificationProvider({NotificationService? notificationService})
      : _notificationService = notificationService ?? NotificationService();

  List<NotificationModel> _notifications = [];
  List<NotificationModel> _unreadNotifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  bool _isMarkingRead = false;
  String? _errorMessage;

  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unreadNotifications => _unreadNotifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  bool get isMarkingRead => _isMarkingRead;
  String? get errorMessage => _errorMessage;

  /// Fetches notifications and unread count from backend
  Future<void> fetchNotifications({int page = 0, int size = 20}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _notificationService.getMyNotifications(page: page, size: size),
        _notificationService.getUnreadNotifications(page: page, size: size),
        _notificationService.getUnreadCount(),
      ]);

      _notifications = results[0] as List<NotificationModel>;
      _unreadNotifications = results[1] as List<NotificationModel>;
      _unreadCount = results[2] as int;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches authoritative unread count from backend
  Future<void> fetchUnreadCount() async {
    try {
      _unreadCount = await _notificationService.getUnreadCount();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to fetch unread count: $e');
    }
  }

  /// Marks a specific notification as read on backend
  Future<bool> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && _notifications[index].read) {
      return true; // Already read
    }

    _isMarkingRead = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _notificationService.markAsRead(id);
      if (success) {
        // Update local list optimistically upon backend success
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(
            read: true,
            readAt: DateTime.now(),
          );
        }
        _unreadNotifications.removeWhere((n) => n.id == id);
        await fetchUnreadCount();
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isMarkingRead = false;
      notifyListeners();
    }
  }

  /// Marks all notifications as read on backend
  Future<bool> markAllAsRead() async {
    _isMarkingRead = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _notificationService.markAllAsRead();
      if (success) {
        _notifications = _notifications.map((n) {
          return n.copyWith(
            read: true,
            readAt: n.readAt ?? DateTime.now(),
          );
        }).toList();
        _unreadNotifications = [];
        await fetchUnreadCount();
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isMarkingRead = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
