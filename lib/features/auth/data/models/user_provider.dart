import 'package:flutter/foundation.dart';

/// Provider for managing user session data
class UserProvider extends ChangeNotifier {
  String? _userId;
  Map<String, dynamic>? _userData;

  String? get userId => _userId;
  Map<String, dynamic>? get userData => _userData;
  bool get isAuthenticated => _userId != null;

  void setUser(String userId, Map<String, dynamic> userData) {
    _userId = userId;
    _userData = userData;
    notifyListeners();
  }

  void clearUser() {
    _userId = null;
    _userData = null;
    notifyListeners();
  }

  void updateUserData(Map<String, dynamic> updates) {
    if (_userData != null) {
      _userData = {..._userData!, ...updates};
      notifyListeners();
    }
  }
}