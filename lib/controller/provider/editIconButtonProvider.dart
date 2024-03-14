import 'package:flutter/material.dart';

class EditIconButtonProvider extends ChangeNotifier {
  bool _isEditing = false;

  bool get isEditing => _isEditing;

  void startEditing() {
    _isEditing = true;
    notifyListeners();
  }

  void stopEditing() {
    _isEditing = false;
    notifyListeners();
  }
}
