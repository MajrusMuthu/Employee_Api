import 'package:flutter/material.dart';

class EmployeeDeletionProvider extends ChangeNotifier {
  bool _isDeleting = false;

  bool get isDeleting => _isDeleting;

  void startDeleting() {
    _isDeleting = true;
    notifyListeners();
  }

  void stopDeleting() {
    _isDeleting = false;
    notifyListeners();
  }
}
