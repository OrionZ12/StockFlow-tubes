import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  // Global app state properties
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // App-wide notification state
  String _appNotification = '';
  String get appNotification => _appNotification;

  void setAppNotification(String message) {
    _appNotification = message;
    notifyListeners();
  }

  void clearAppNotification() {
    _appNotification = '';
    notifyListeners();
  }

  // App-wide error state
  String? _error;
  String? get error => _error;

  void setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
