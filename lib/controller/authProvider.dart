import 'package:flutter/material.dart';

class AuthPageProvider extends ChangeNotifier {
  bool _showLoginPage = true;

  bool get showLoginPage => _showLoginPage;

  void togglePage() {
    _showLoginPage = !_showLoginPage;
    notifyListeners();
  }
}
