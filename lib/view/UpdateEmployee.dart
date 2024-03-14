// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:employee_app/controller/provider/dropdownProvider.dart';
import 'package:employee_app/controller/provider/selectImageProvider.dart';
import 'package:employee_app/view/widget/Text_field.dart';
import 'package:employee_app/view/widget/dropdownButton.dart';
import 'package:employee_app/view/Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:employee_app/model/EmployeeData.dart';
import 'package:employee_app/controller/Api_Service.dart';

import 'package:provider/provider.dart';

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
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with employee data
    nameController.text = widget.employee.name;
    emailController.text = widget.employee.email;
    designationController.text = widget.employee.designation;
    addressController.text = widget.employee.address;
    phoneNumberController.text = widget.employee.phoneNumber;
    dropdownValue = widget.employee.gender;
  }

  @override
  Widget build(BuildContext context) {
    var imageProvider = SelectImageProvider();
        Provider.of<DropdownProvider>(context, listen: false);
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
                    await imageProvider.pickImage();
                  },
                  child: const Text(
                    'Select Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 20),
                // Display selected image
                Consumer<SelectImageProvider>(
                  builder: (context, imageProvider, _) {
                    return imageProvider.image != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              imageProvider.image!,
                              width: 150.0,
                              height: 150.0,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container();
                  },
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () {
                    imageProvider.clearSelectedImage();
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
                Consumer<DropdownProvider>(
                  builder: (context, dropdownProvider, _) {
                    return MyDropdownField(
                      items: const ["Male", "Female", "Other"],
                      hintText: "Gender",
                      value: dropdownProvider.dropdownValue,
                      onChanged: (newValue) {
                        dropdownProvider.setDropdownValue(newValue);
                      },
                    );
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
                    "UPDATE",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    bool? confirmed = await _showConfirmationDialog();
                    if (confirmed != null && confirmed) {
                      _updateEmployee();
                      _showSuccessMessage();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Update"),
          content: Text("Are you sure you want to update this employee?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false if canceled
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if confirmed
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateEmployee() async {
    var imageProvider =
        Provider.of<SelectImageProvider>(context, listen: false);

    // Get the image from the imageProvider
    File? updatedImage = imageProvider.image;
    String? imageUrl =
        updatedImage != null ? updatedImage.path : widget.employee.imageUrl;

    DataModel updatedEmployee = DataModel(
      id: widget.employee.id,
      name: nameController.text,
      email: emailController.text,
      designation: designationController.text,
      address: addressController.text,
      phoneNumber: phoneNumberController.text,
      gender: dropdownValue!,
      imageUrl: imageUrl,
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
