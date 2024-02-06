// ignore_for_file: use_super_parameters, avoid_print, unnecessary_cast, sized_box_for_whitespace, prefer_const_constructors, use_build_context_synchronously, sort_child_properties_last, unused_field, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_app/Screens/Add_Employee.dart';
import 'package:employee_app/Screens/UpdateEmployee.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  State<HomePage> createState() => _HomePageState();

  void navigateToUpdateEmployee(
    BuildContext context,
    String employeeId,
    dynamic imageUrl,
    dynamic designation,
    dynamic name,
    dynamic email,
    int gender,
    dynamic address,
    dynamic country,
    String phoneNumber,
    dynamic state,
    dynamic city,
    Map<String, dynamic> arguments,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateEmployee(
          arguments: arguments,
          employeeId: employeeId,
          imageUrl: imageUrl,
          designation: designation,
          name: name,
          email: email,
          gender: gender,
          address: address,
          country: country,
          phoneNumber: phoneNumber,
          state: state,
          city: city,
          onTap: () {},
        ),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> employeeList = [];
  int selectedGender = 0;

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
            onPressed: () {
              _showLogoutConfirmationDialog();
            },
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
                } else if (value == 3) {
                  _showLogoutConfirmationDialog();
                }
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
                        )));
          },
          backgroundColor: Colors.grey.shade900,
          shape: const CircleBorder(side: BorderSide(color: Colors.white)),
          child: const Icon(
            Icons.add_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("employees").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("Some error occurred"),
              );
            }
            if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No employees found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var employeeData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    String imageUrl = employeeData['imageUrl'] ?? '';
                    String name = employeeData['name'] ?? '';
                    String email = employeeData['email'] ?? '';
                    String designation = employeeData['designation'] ?? '';

                    return Center(
                      child: Container(
                        width: double.infinity,
                        height: 90.0,
                        child: Card(
                          elevation: 5.0,
                          color: Colors.grey,
                          child: ListTile(
                            leading: InkWell(
                              onTap: () {
                                showImagePopup(imageUrl);
                              },
                              child: Container(
                                width: 55,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                child: ClipOval(
                                  child: imageUrl.isNotEmpty
                                      ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          (loadingProgress
                                                                  .expectedTotalBytes ??
                                                              1)
                                                      : null,
                                                ),
                                              );
                                            }
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            print(
                                                'Error loading image: $error');
                                            print('Stack trace: $stackTrace');
                                            return const Icon(Icons.error);
                                          },
                                        )
                                      : const Icon(Icons.person),
                                ),
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  email,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  designation,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    // Check if 'employeeId' is not null
                                    if (employeeData['employeeId'] != null) {
                                      String employeeId =
                                          employeeData['employeeId'];
                                      String imageUrl =
                                          employeeData['imageUrl'] ?? '';
                                      dynamic designation =
                                          employeeData['designation'];
                                      dynamic name = employeeData['name'];
                                      dynamic email = employeeData['email'];
                                      int gender = selectedGender;
                                      dynamic address = employeeData['address'];
                                      dynamic country = employeeData['country'];
                                      String phoneNumber =
                                          employeeData['phoneNumber']
                                              .toString();
                                      dynamic state = employeeData['state'];
                                      dynamic city = employeeData['city'];

                                      // Map of arguments to pass to the update page
                                      Map<String, dynamic> arguments = {
                                        'employeeId': employeeId,
                                        'imageUrl': imageUrl,
                                        'name': name,
                                        'email': email,
                                        'designation': designation,
                                        'gender': gender,
                                        'address': address,
                                        'phoneNumber': phoneNumber,
                                        'country': country,
                                        'state': state,
                                        'city': city,
                                      };

                                      // Navigate to the update page
                                      widget.navigateToUpdateEmployee(
                                        context,
                                        employeeId,
                                        imageUrl,
                                        designation,
                                        name,
                                        email,
                                        gender,
                                        address,
                                        country,
                                        phoneNumber,
                                        state,
                                        city,
                                        arguments,
                                      );
                                    } else {
                                      print(
                                        'Error: Employee ID is null. Full employeeData: $employeeData',
                                      );
                                    }
                                  },
                                ),

                                // SizedBox(width: 5),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    showDeleteConfirmationDialog(employeeData);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Future<void> deleteEmployee(Map<String, dynamic> employeeData) async {
    try {
      String? employeeId = employeeData['employeeId'] as String?;
      if (employeeId == null || employeeId.isEmpty) {
        print('Error: Employee ID is null or empty.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Employee ID is null.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      String imageUrl = employeeData['imageUrl'] ?? '';

      await FirebaseFirestore.instance
          .collection('employees')
          .doc(employeeId)
          .delete();

      if (imageUrl.isNotEmpty) {
        Reference storageReference =
            FirebaseStorage.instance.refFromURL(imageUrl);
        await storageReference.delete();
      }

      setState(() {
        employeeList
            .removeWhere((employee) => employee['employeeId'] == employeeId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Employee and associated image deleted successfully.'),
        ),
      );
    } catch (error) {
      print('Error deleting employee: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete employee. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Do you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                widget.signUserOut();
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes",
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    ).then((result) {
      if (result == true) {
        Navigator.pushReplacementNamed(context, '/LoginPage');
      }
    });
  }

  void showDeleteConfirmationDialog(Map<String, dynamic> employeeData) {
    String? employeeId = employeeData['employeeId'] as String?;
    if (employeeId == null || employeeId.isEmpty) {
      print('Error: Invalid employeeId');
      return;
    }

    print('Deleting employee with ID: $employeeId');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Employee"),
          content: const Text("Are you sure you want to delete this employee?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                deleteEmployee(employeeData);
                Navigator.of(context).pop();
              },
              child: const Text("Delete",
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      // Delete image from Firebase Storage
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();

      // Update Firestore document to remove image URL
      await FirebaseFirestore.instance
          .collection('employees')
          .where('imageUrl', isEqualTo: imageUrl)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({'imageUrl': FieldValue.delete()});
        });
      });

      print('Image deleted successfully');
    } catch (error) {
      print('Error deleting image: $error');
    }
  }

  void showImagePopup(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      imageUrl,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error');
                        print('Stack trace: $stackTrace');
                        return const Icon(Icons.error);
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (imageUrl != null) {
                          await deleteImage(imageUrl);
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Delete Image',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
