import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  bool _passwordsMatch = false;

  bool get passwordsMatch => _passwordsMatch;

  void checkPasswordMatch(String password, String confirmPassword) {
    _passwordsMatch = password == confirmPassword;
    notifyListeners();
  }
}
