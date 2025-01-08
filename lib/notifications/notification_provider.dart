import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // Stream subscription
  StreamSubscription<QuerySnapshot>? _notificationSubscription;

  NotificationProvider() {
    initializeNotifications();
  }

  void initializeNotifications() {
    _setLoading(true);
    try {
      // Listen to notifications collection
      _notificationSubscription = _db
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
        _notifications = snapshot.docs
            .map((doc) => NotificationModel.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                }))
            .toList();
        _setLoading(false);
        notifyListeners();
      });
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _db
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
      
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = NotificationModel.fromJson({
          ..._notifications[index].toJson(),
          'isRead': true,
        });
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final batch = _db.batch();
      final unreadNotifications = _notifications.where((n) => !n.isRead);
      
      for (var notification in unreadNotifications) {
        batch.update(
          _db.collection('notifications').doc(notification.id),
          {'isRead': true},
        );
      }

      await batch.commit();
      
      _notifications = _notifications.map((notification) => NotificationModel.fromJson({
        ...notification.toJson(),
        'isRead': true,
      })).toList();
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _db.collection('notifications').doc(notificationId).delete();
      _notifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    try {
      await _db.collection('notifications').add(notification.toJson());
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }
}