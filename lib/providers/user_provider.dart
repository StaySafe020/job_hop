import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class UserProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  // Getters
  UserModel? get user => _user;
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;

  // Fetch user profile
  Future<void> fetchUserProfile() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      _user = await _firestoreService.getUserProfile(user.uid);
      notifyListeners();
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    await _firestoreService.saveUserProfile(user);
    await fetchUserProfile();
  }

  // Toggle theme mode
  void toggleThemeMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  // Toggle notifications
  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _isDarkMode = false; // Reset theme mode on sign-out
    _notificationsEnabled = true; // Reset notifications on sign-out
    notifyListeners();
  }
}