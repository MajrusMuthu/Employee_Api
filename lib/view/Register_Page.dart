// ignore_for_file: use_build_context_synchronously, use_super_parameters

import 'package:employee_app/controller/provider/regSignProvider.dart';
import 'package:employee_app/view/widget/Image_Size.dart';
import 'package:employee_app/view/widget/MyButton.dart';
import 'package:employee_app/view/widget/Text_field.dart';
import 'package:employee_app/view/Home_Page.dart';
import 'package:employee_app/view/Login_Page.dart';
import 'package:employee_app/controller/Authentication_Service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required void Function() onTap})
      : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // variable to track whether passwords match
  bool passwordsMatch = true;

  // Sign user up method
  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // pop the loading circle
        Navigator.pop(context);

        // show success message
        showSuccessMessage("Account created successfully!");

        // Navigate to the HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // pop the loading circle
        Navigator.pop(context);

        // show error message, Passwords don't match
        showErrorMessage("Passwords Don't Match");
      }
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      // show error message
      showErrorMessage(e.code);
    }
  }

  // Method to show error messages
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          title: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  // Method to show success messages
  void showSuccessMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          title: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // logo
                const Icon(
                  Icons.supervisor_account_outlined,
                  size: 200,
                  color: Colors.white,
                ),

                const SizedBox(height: 20),
                // text
                const Text(
                  "Let's create an account for you!",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                const SizedBox(height: 25),

                // username text field
                MyTextField(
                  controller: emailController,
                  hintText: "User Name",
                  obscureText: false,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 10),
                // password text field
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                  keyboardType: TextInputType.none,
                ),
                const SizedBox(height: 10),
                // confirm password text field
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                  keyboardType: TextInputType.none,
                ),

                const SizedBox(height: 10),

                // sign up button
                Consumer<SignUpProvider>(
                  builder: (context, signUpProvider, _) {
                    return MyButton(
                      onTap: () {
                        signUpProvider.checkPasswordMatch(
                          passwordController.text,
                          confirmPasswordController.text,
                        );
                        if (signUpProvider.passwordsMatch) {
                          signUserUp();
                        } else {
                          showErrorMessage("Passwords Don't Match");
                        }
                      },
                      text: "Sign Up",
                    );
                  },
                ),

                const SizedBox(height: 25),

                // or continue with
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("Or continue with",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: () async {
                        await AuthService().signInWithGoogle();
                      },
                      imagePath: 'Images/Google.png',
                    ),
                    const SizedBox(width: 10),
                    SquareTile(
                      imagePath: 'Images/Apple.png',
                      onTap: () {
                        // Handle Apple sign-in logic here
                      },
                    ),
                  ],
                ),

                // not a member register now

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already Have An Account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                      onTap: () {},
                                    )));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
