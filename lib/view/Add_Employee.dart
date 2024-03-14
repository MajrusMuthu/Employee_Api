// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, unused_element, use_super_parameters, unused_local_variable

import 'dart:io';

import 'package:employee_app/controller/provider/dropdownProvider.dart';
import 'package:employee_app/controller/provider/selectImageProvider.dart';
import 'package:employee_app/view/widget/Text_field.dart';
import 'package:employee_app/view/widget/dropdownButton.dart';
import 'package:employee_app/model/EmployeeData.dart';
import 'package:employee_app/view/Home_Page.dart';
import 'package:employee_app/controller/Api_Service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeAdd extends StatefulWidget {
  const EmployeeAdd({Key? key, required Null Function() onTap})
      : super(key: key);

  @override
  State<EmployeeAdd> createState() => _EmployeeAddState();
}

// Define the state for AddEmployee StatefulWidget
class _EmployeeAddState extends State<EmployeeAdd> {
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
  Widget build(BuildContext context) {
    var imageProvider = SelectImageProvider();
    var dropdownProvider =
        Provider.of<DropdownProvider>(context, listen: false);

    return Scaffold(
      key: _scaffoldMessengerKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Let's create an Employee Profile",
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
                    var imageProvider = Provider.of<SelectImageProvider>(
                        context,
                        listen: false);
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
                              File(imageProvider.image!.path),
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
                  onPressed: () async {
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
                    "SUBMIT",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    _submitEmployeeData();
                    _showSuccessMessage();
                    print('Add Employee');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
//add data in database through Api

  Future<void> _submitEmployeeData() async {
    var imageProvider =
        Provider.of<SelectImageProvider>(context, listen: false);

    final employee = DataModel(
      id: '',
      name: nameController.text,
      email: emailController.text,
      gender: dropdownValue ?? '',
      designation: designationController.text,
      address: addressController.text,
      phoneNumber: phoneNumberController.text,
      imageUrl: imageProvider.image != null ? imageProvider.image!.path : '',
    );

    try {
      await _apiService.addEmployee(employee);
      if (mounted) {
        if (_scaffoldMessengerKey.currentState != null) {
          _scaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(
              content: Text('Employee added successfully'),
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
              content: Text('Failed to add employee: $e'),
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
            content: Text('Employee information stored successfully.'),
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
