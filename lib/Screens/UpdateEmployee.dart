// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, unused_element, use_super_parameters

import 'dart:io';

import 'package:employee_app/Components/Text_field.dart';
import 'package:employee_app/Components/dropdownButton.dart';
import 'package:employee_app/Screens/Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:employee_app/Model/EmployeeData.dart';
import 'package:employee_app/Services/Api_Service.dart';
import 'package:image_picker/image_picker.dart';

class UpdateEmployee extends StatefulWidget {
  final DataModel employee;

  const UpdateEmployee({Key? key, required this.employee}) : super(key: key);

  @override
  State<UpdateEmployee> createState() => _UpdateEmployeeState();
}

class _UpdateEmployeeState extends State<UpdateEmployee> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String? dropdownValue;
  File? _image;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final ApiService _apiService = ApiService();

  // Method to clear selected image
  void _clearSelectedImage() {
    setState(() {
      _image = null;
    });
  }

  // Method to pick an image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers with employee data
    nameController.text = widget.employee.name ?? '';
    emailController.text = widget.employee.email ?? '';
    designationController.text = widget.employee.designation ?? '';
    addressController.text = widget.employee.address ?? '';
    phoneNumberController.text = widget.employee.phoneNumber ?? '';
    dropdownValue = widget.employee.gender ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Update Employee Profile",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    await _pickImage();
                  },
                  child: const Text(
                    'Select Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 20),
                // Display selected image
                _image != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          _image!,
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () {
                    _clearSelectedImage();
                  },
                  child: const Text(
                    'Clear Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                SizedBox(height: 20),
                MyTextField(
                  hintText: 'Name',
                  obscureText: false,
                  controller: nameController,
                  keyboardType: TextInputType.name,
                ),
                SizedBox(height: 10),
                MyTextField(
                  obscureText: false,
                  hintText: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10),
                MyDropdownField(
                  items: ["Male", "Female", "Other"],
                  hintText: "Gender",
                  value: dropdownValue,
                  onChanged: (newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                ),

                SizedBox(height: 10),
                MyTextField(
                  hintText: 'Designation',
                  obscureText: false,
                  controller: designationController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 10),
                MyTextField(
                  hintText: 'Address',
                  obscureText: false,
                  controller: addressController,
                  keyboardType: TextInputType.streetAddress,
                ),
                SizedBox(height: 10),
                MyTextField(
                  hintText: 'Phone Number',
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  controller: phoneNumberController,
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey),
                    fixedSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                  ),
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    _updateEmployee();
                    _showSuccessMessage();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateEmployee() async {
    DataModel updatedEmployee = DataModel(
      id: widget.employee.id,
      name: nameController.text,
      email: emailController.text,
      designation: designationController.text,
      address: addressController.text,
      phoneNumber: phoneNumberController.text,
      gender: dropdownValue!,
      imageUrl: _image != null ? _image!.path : widget.employee.imageUrl,
    );

    try {
      await _apiService.updateEmployee(widget.employee.id!, updatedEmployee);

      if (mounted) {
        if (_scaffoldMessengerKey.currentState != null) {
          _scaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(
              content: Text('Employee updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _showSuccessMessage();
      }
    } catch (e) {
      if (mounted) {
        if (_scaffoldMessengerKey.currentState != null) {
          _scaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(
              content: Text('Failed to update employee: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showSuccessMessage() {
    if (mounted) {
      if (_scaffoldMessengerKey.currentState != null) {
        _scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(
            content: Text('Employee information updated successfully.'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
      }

      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        }
      });
    }
  }
}
