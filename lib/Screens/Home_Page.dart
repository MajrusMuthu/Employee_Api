// ignore_for_file: prefer_const_constructors, avoid_print, sized_box_for_whitespace, prefer_const_declarations, use_super_parameters, unnecessary_null_comparison, unused_import, unused_field, sort_child_properties_last, unused_element, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:employee_app/Model/EmployeeData.dart';
import 'package:employee_app/Screens/Add_Employee.dart';
import 'package:employee_app/Screens/UpdateEmployee.dart';
import 'package:employee_app/Services/Api_Service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late File _image;
  final ApiService _apiService = ApiService();
  late Future<List<DataModel>> _futureEmployeeData;

  @override
  void initState() {
    super.initState();
    _futureEmployeeData = _apiService.fetchEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text(
          "Employee Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 0) {
                Navigator.pushNamed(context, '/EmployeeAdd');
                print("Add Employee menu is selected.");
              } else if (value == 1) {
                print("Search menu is selected.");
              } else if (value == 2) {
                print("Settings is selected.");
              } else if (value == 3) {}
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 0,
                child: Text(
                  "Add Employee",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text(
                  "Search",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text(
                  "Settings",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  widget.signUserOut();
                },
                value: 3,
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            color: Colors.black,
          )
        ],
        backgroundColor: Colors.grey.shade900,
      ),
      floatingActionButton: FloatingActionButton(
        highlightElevation: 50,
        tooltip: 'Add',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeAdd(
                onTap: () {},
              ),
            ),
          );
        },
        backgroundColor: Colors.grey.shade900,
        shape: const CircleBorder(side: BorderSide(color: Colors.white)),
        child: const Icon(
          Icons.add_rounded,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<List<DataModel>>(
        future: _futureEmployeeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final List<DataModel>? employees = snapshot.data;
          if (employees == null || employees.isEmpty) {
            return const Center(
              child: Text(
                'No employees found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return Card(
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        showImagePopup(employee.imageUrl);
                      },
                      child: CircleAvatar(
                        backgroundImage: employee.imageUrl != null &&
                                employee.imageUrl.isNotEmpty
                            ? FileImage(File(employee.imageUrl))
                            : null,
                        child: (employee.imageUrl == null ||
                                employee.imageUrl.isEmpty)
                            ? Icon(Icons.person)
                            : null,
                      ),
                    ),
                    title: Text(employee.name),
                    subtitle: Text(employee.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            if (employee.id != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Do you want to Edit '),
                                    content: Text(
                                        'Are you sure you want to edit this employee?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateEmployee(
                                                      employee: employee),
                                            ),
                                          );
                                          DataModel updatedEmployee = DataModel(
                                            id: employee.id,
                                            name: 'name',
                                            email: 'email',
                                            gender: 'gender',
                                            designation: 'designation',
                                            address: 'address',
                                            phoneNumber: 'phoneNumber',
                                            imageUrl: 'imageUrl',
                                          );
                                          try {
                                            await _apiService.updateEmployee(
                                                employee.id!, updatedEmployee);
                                            Navigator.of(context).pop();
                                            setState(() {
                                              _futureEmployeeData =
                                                  _apiService.fetchEmployees();
                                            });
                                          } catch (e) {
                                            print('Error editing employee: $e');
                                            // Handle error
                                          }
                                        },
                                        child: Text('Edit'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            if (employee.id != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm Deletion'),
                                    content: Text(
                                        'Are you sure you want to delete this employee?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            await _apiService
                                                .deleteEmployee(employee.id!);
                                            Navigator.of(context).pop();
                                            setState(() {
                                              _futureEmployeeData =
                                                  _apiService.fetchEmployees();
                                            });
                                          } catch (e) {
                                            print('Error deleting employee: $e');
                                            // Handle error
                                          }
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void showImagePopup(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(
                File(imageUrl),
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error');
                  print('Stack trace: $stackTrace');
                  return const Icon(Icons.error);
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
