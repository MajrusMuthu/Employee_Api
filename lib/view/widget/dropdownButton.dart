// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';

class MyDropdownField extends StatelessWidget {
  final List<String> items;
  final String? value;
  final void Function(String?)? onChanged;
  final String hintText;

  const MyDropdownField({
    Key? key,
    required this.items,
    required this.hintText,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          fillColor: Colors.grey,
          filled: true,
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        value: value,
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        dropdownColor: Colors.grey,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
