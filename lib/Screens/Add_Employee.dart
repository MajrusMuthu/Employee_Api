// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, use_super_parameters

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:employee_app/Components/Text_field.dart';
import 'package:employee_app/Screens/Home_Page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EmployeeAdd extends StatefulWidget {
  const EmployeeAdd({Key? key, required Null Function() onTap})
      : super(key: key);

  @override
  State<EmployeeAdd> createState() => _EmployeeAddState();
}

class _EmployeeAddState extends State<EmployeeAdd> {
  TextEditingController imageurlController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  late int selectedGender = 0;
  File? _image;

  void _clearSelectedImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: Colors.white,
                                  value: 1,
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value as int;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    'Male',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: Colors.white,
                                  value: 2,
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value as int;
                                    });
                                  },
                                ),
                                Text(
                                  'Female',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: Colors.white,
                                  value: 3,
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value as int;
                                    });
                                  },
                                ),
                                Text(
                                  'Others',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
                          disabledDropdownDecoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                            color: Colors.grey.shade600,
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          dropdownDecoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            color: Colors.grey.shade600,
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          onCountryChanged: (country) {
                            countryController.text = country;
                          },
                          onStateChanged: (state) {
                            stateController.text = state ?? '';
                          },
                          onCityChanged: (city) {
                            cityController.text = city ?? '';
                          },
                        ),
                      ),
                    ],
                  ),
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
                    print('Submit button pressed');
                    if (_validateForm()) {
                      await createEmployeeInFirestore();
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> createEmployeeInFirestore() async {
    try {
      CollectionReference employees =
          FirebaseFirestore.instance.collection('employees');
      String imageUrl;

      if (_image != null) {
        imageUrl = await _uploadImage();
      } else if (imageurlController.text.isNotEmpty) {
        imageUrl = imageurlController.text;
      } else {
        print('Error: Please select an image or provide an image URL.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an image or provide an image URL.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      DocumentReference docRef = await employees.add({
        'name': nameController.text,
        'email': emailController.text,
        'designation': designationController.text,
        'gender': selectedGender == 1
            ? 'Male'
            : selectedGender == 2
                ? 'Female'
                : 'Others',
        'address': addressController.text,
        'phoneNumber': phoneNumberController.text,
        'country': countryController.text,
        'state': stateController.text,
        'city': cityController.text,
        'imageUrl': imageUrl,
      });

      String employeeId = docRef.id;
      await docRef.update({'employeeId': employeeId});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Employee created successfully.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );

      _clearFormFields();
    } catch (error) {
      print('Error creating employee: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating employee. Please try again.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String> _uploadImage() async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = storageReference.putFile(_image!);

      await uploadTask.whenComplete(() => null);
      String imageUrl = await storageReference.getDownloadURL();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image uploaded successfully.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }

      return imageUrl;
    } catch (error) {
      print('Error uploading image: $error');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image. Please try again.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }

      return '';
    }
  }

  bool _validateForm() {
    // Check if Employee ID, Name, Email, Designation, and Gender are not empty
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        designationController.text.isEmpty ||
        selectedGender == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Employee ID, Name, Email, Designation, and Gender are mandatory.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      print(
          'Validation failed: Employee ID, Name, Email, Designation, and Gender are mandatory.');
      return false;
    }

    // Check if both image and image URL are not empty
    if (_image == null && imageurlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image or provide an image URL.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      print(
          'Validation failed: Please select an image or provide an image URL.');
      return false;
    }

    return true;
  }

  void _clearFormFields() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Employee information stored successfully.'),
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

    setState(() {
      _image = null;
      imageurlController.clear();
      nameController.clear();
      emailController.clear();
      designationController.clear();
      addressController.clear();
      phoneNumberController.clear();
      countryController.clear();
      stateController.clear();
      cityController.clear();
    });
  }
}
