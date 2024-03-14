import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageProvider extends ChangeNotifier {
  File? _image;

  File? get image => _image;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _image = File(pickedImage.path);
      notifyListeners(); // Notify listeners that the image has been updated
    }
  }

  void clearSelectedImage() {
    _image = null;
    notifyListeners(); // Notify listeners that the image has been cleared
  }
}
