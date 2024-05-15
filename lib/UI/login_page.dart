import 'package:firebase/Check/forgot_password.dart';
import 'package:firebase/UI/homepage.dart';
import 'package:firebase/UI/sign_up_page.dart';
import 'package:firebase/UI/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> LOGIN FUNCTION
  LogIn(String email, String password) async {
    if (email == "" || password == "") {
      return UIhelper.customAlertBox(context, "Enter required fields !");
    } else {
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then(
              (value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(),
                ),
              ),
            );
      } on FirebaseException {
        return UIhelper.customAlertBox(context, 'Wrong Information !');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          UIhelper.customTextField(
              emailController, "Email", Icons.email, false, context),
          UIhelper.customTextField(
              passwordController, "Password", Icons.key, false, context),
          const SizedBox(height: 30),

          //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> LOGIN BUTTON
          UIhelper.customButton(() {
            LogIn(
              emailController.text.toString(),
              passwordController.text.toString(),
            );
          }, "Login", Colors.lightGreen, context),

          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPassword(),
                ),
              );
            },
            child: Text(
              'Forgotten Password?',
              style:
                  TextStyle(fontSize: width * 0.04, color: Colors.blueAccent),
            ),
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have any account?",
                style: TextStyle(fontSize: width * 0.04, color: Colors.black54),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ),
                  );
                },
                child: Text(
                  'Sign-up',
                  style: TextStyle(
                      fontSize: width * 0.04,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
