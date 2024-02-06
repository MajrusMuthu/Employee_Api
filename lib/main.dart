

import 'package:employee_app/Screens/Authentication_Page.dart';
import 'package:employee_app/Screens/Home_Page.dart';
import 'package:employee_app/Screens/Login_Page.dart';
import 'package:employee_app/Screens/Register_Page.dart';
import 'package:employee_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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
    return MaterialApp(
      // home: const AuthPage(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        '/RegisterPage': (context) => RegisterPage(onTap: () {  },),
        '/HomePage': (context) => const HomePage(),
        // '/EmployeeAdd': (context) => EmployeeAdd(),
        '/LoginPage': (context) => LoginPage(onTap: () {  },),
        // '/UpdateEmployee': (context) => UpdateEmployee(employeeId: '', onTap: () {  },),
      },
    );
  }
}