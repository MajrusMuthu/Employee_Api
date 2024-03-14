import 'package:flutter/material.dart';

class DropdownProvider extends ChangeNotifier {
  String? _dropdownValue;

  String? get dropdownValue => _dropdownValue;

  void setDropdownValue(String? value) {
    _dropdownValue = value;
    notifyListeners();
  }
}
