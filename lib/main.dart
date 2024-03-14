import 'package:employee_app/controller/Authentication_Page.dart';
import 'package:employee_app/controller/provider/deleteIconButtonProvider.dart';
import 'package:employee_app/controller/provider/dropdownProvider.dart';
import 'package:employee_app/controller/provider/editIconButtonProvider.dart';
import 'package:employee_app/controller/provider/regSignProvider.dart';
import 'package:employee_app/controller/provider/selectImageProvider.dart';
import 'package:employee_app/view/Home_Page.dart';
import 'package:employee_app/view/Login_Page.dart';
import 'package:employee_app/view/Register_Page.dart';
import 'package:employee_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:employee_app/controller/authProvider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthPageProvider()),
        ChangeNotifierProvider(create: (context) => DropdownProvider()),
        ChangeNotifierProvider(create: (context) => EmployeeDeletionProvider()),
        ChangeNotifierProvider(create: (context) => EditIconButtonProvider()),
        ChangeNotifierProvider(create: (context) => SignUpProvider()),
        ChangeNotifierProvider(create: (context) => SelectImageProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthPage(),
          '/RegisterPage': (context) => RegisterPage(
                onTap: () {},
              ),
          '/HomePage': (context) => const HomePage(),
          // '/EmployeeAdd': (context) => EmployeeAdd(),
          '/LoginPage': (context) => LoginPage(
                onTap: () {},
              ),
          // '/UpdateEmployee': (context) => UpdateEmployee(employeeId: '', onTap: () {  },),
        },
      ),
    );
  }
}
