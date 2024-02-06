// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, use_super_parameters, unused_element

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:employee_app/Components/Text_field.dart';
import 'package:employee_app/Screens/Home_Page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class CSCPickerSelection {
  final String country;
  final String state;
  final String city;
  final int gender;

  CSCPickerSelection({
    required this.country,
    required this.state,
    required this.city,
    required this.gender,
  });
}

class UpdateEmployee extends StatefulWidget {
  final String? employeeId;
  final String? imageUrl;
  final dynamic designation;
  final dynamic name;
  final dynamic email;
  final int gender;
  final dynamic address;
  final dynamic country;
  final String phoneNumber;
  final dynamic state;
  final dynamic city;
  final Map<String, dynamic> arguments;

  const UpdateEmployee({
    Key? key,
    required void Function() onTap,
    required this.employeeId,
    required this.imageUrl,
    required this.designation,
    required this.name,
    required this.email,
    required this.gender,
    required this.address,
    required this.country,
    required this.phoneNumber,
    required this.state,
    required this.city,
    required this.arguments,
  }) : super(key: key);

  @override
  State<UpdateEmployee> createState() => _UpdateEmployeeState();
}

class _UpdateEmployeeState extends State<UpdateEmployee> {
  final CollectionReference employee =
      FirebaseFirestore.instance.collection('employees');
  TextEditingController imageurlController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController selectedGenderController = TextEditingController();

  late int selectedGender = 0;
  File? _image;

  void _clearSelectedImage() {
    setState(() {
      _image = null;
    });
  }

  int _mapGenderToValue(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return 1;
      case 'female':
        return 2;
      case 'others':
        return 3;
      default:
        return 0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = widget.arguments;
    String? employeeId = args['employeeId'];
    print('Employee ID(U): $employeeId');
    nameController.text = args['name'] ?? '';
    emailController.text = args['email'] ?? '';
    designationController.text = args['designation'] ?? '';

    if (args['gender'] != null && args['gender'] is int) {
      selectedGender = args['gender'] as int;
    }

    addressController.text = args['address'] ?? '';
    phoneNumberController.text = args['phoneNumber'] ?? '';
    String? country = args['country'];
    String? state = args['state'];
    String? city = args['city'];

    CSCPickerSelection initialSelection = CSCPickerSelection(
      country: country ?? '',
      state: state ?? '',
      city: city ?? '',
      gender: selectedGender,
    );
    // Set the values for controllers
    countryController.text = initialSelection.country;
    stateController.text = initialSelection.state;
    cityController.text = initialSelection.city;
    // Set the initial gender value
    selectedGenderController.text = initialSelection.gender.toString();
    imageurlController.text = args['imageUrl'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Update an Employee Profile",
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
                Row(
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
                  ],
                ),
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
                SizedBox(height: 20),
                MyTextField(
                  hintText: 'Image Url',
                  obscureText: false,
                  controller: imageurlController,
                  keyboardType: TextInputType.url,
                ),
                SizedBox(height: 10),
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
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        "Gender :",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: _buildGenderRadioButton(1, 'Male'),
                          ),
                          Flexible(
                            flex: 1,
                            child: _buildGenderRadioButton(2, 'Female'),
                          ),
                          Flexible(
                            flex: 1,
                            child: _buildGenderRadioButton(3, 'Others'),
                          ),
                        ],
                      ),
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
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: CSCPicker(
                          flagState: CountryFlag.ENABLE,
                          disabledDropdownDecoration: _getPickerBoxDecoration(),
                          dropdownDecoration: _getPickerBoxDecoration(),
                          onCountryChanged: (country) {
                            setState(() {
                              countryController.text = country;
                            });
                          },
                          onStateChanged: (state) {
                            setState(() {
                              stateController.text = state ?? '';
                            });
                          },
                          onCityChanged: (city) {
                            setState(() {
                              cityController.text = city ?? '';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    if (widget.employeeId != null &&
                        widget.employeeId!.isNotEmpty) {
                      _uploadImageAndData();
                    } else {
                      print('Error: widget.employeeId is null (U).');
                    }
                  },
                  style: _getButtonStyle(),
                  child: Text(
                    "Update Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderRadioButton(int value, String label) {
    return Row(
      children: [
        Radio(
          activeColor: Colors.white,
          value: value,
          groupValue: selectedGender,
          onChanged: (value) {
            setState(() {
              selectedGender = value as int;
            });
          },
        ),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _getPickerBoxDecoration() {
    return BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      color: Colors.grey.shade600,
      border: Border.all(
        color: Colors.white,
        width: 1,
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
      fixedSize: MaterialStateProperty.all<Size>(Size(200, 50)),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

Future<void> _uploadImageAndData() async {
  try {
    if (_image != null && widget.employeeId != null && widget.employeeId!.isNotEmpty) {
      // Upload image to Firebase Storage
      Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('employee_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      UploadTask uploadTask = ref.putFile(_image!);
      
      // Get download URL of the uploaded image
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update employee data in Firestore
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(widget.employeeId)
          .set({
        'name': nameController.text,
        'email': emailController.text,
        'designation': designationController.text,
        'address': addressController.text,
        'phoneNumber': phoneNumberController.text,
        'country': countryController.text,
        'state': stateController.text,
        'city': cityController.text,
        'gender': selectedGender,
        'imageUrl': downloadUrl, // Store image URL in Firestore
      }, SetOptions(merge: true));

      // Clear form fields and show success dialog
      _clearFormFields();
    } else {
      print('Error: Image or widget.employeeId is null or empty.');
    }
  } catch (error) {
    print('Error updating employee data: $error');
  }
}


  void _clearFormFields() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Employee information updated successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
