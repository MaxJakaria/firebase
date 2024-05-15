import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Cloude%20Storage/profile_pic.dart';
import 'package:firebase/UI/login_page.dart';
import 'package:firebase/UI/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SIGN UP FUNCTIONS

  SignUp(String name, String email, String password,
      String confirmPassword) async {
    if (name == "" || email == "" || password == "" || confirmPassword == "") {
      UIhelper.customAlertBox(context, "Enter required fields !");
    } else if (password != confirmPassword) {
      UIhelper.customAlertBox(context, "Passwords are not the same !");
    } else {
      try {
        //___________________________________________________________ Create user in Firebase Authentication

        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        //Show Dialog
        showDialog(
          context: context,
          builder: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        //______________________________________________________________ Set data to Firebase firestore
        FirebaseFirestore.instance
            .collection('user')
            .doc(userCredential.user!.email)
            .set({
          'name': name,
          'email': email,
          'about': "I'm using IslamicMedea !",
        });

        //Remove Dialog
        Navigator.pop(context);


        // Navigate to the next screen after successful sign-up
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfilePic(),
          ),
        );
      } on FirebaseAuthException {
        UIhelper.customAlertBox(context, 'Something wrong !');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up Page'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Text Fields
          UIhelper.customTextField(nameController, 'Name',
              Icons.account_box_outlined, false, context),
          UIhelper.customTextField(
              emailController, "Email", Icons.email_outlined, false, context),
          UIhelper.customTextField(
              passwordController, "Password", Icons.key, false, context),

          UIhelper.customTextField(confirmPasswordController,
              "Confirm password", Icons.key, false, context),
          const SizedBox(height: 30),
          //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SIGNUP BUTTON

          UIhelper.customButton(() {
            SignUp(
                nameController.text.toString(),
                emailController.text.toString(),
                passwordController.text.toString(),
                confirmPasswordController.text.toString());
          }, "Sign Up", Colors.lightGreen, context),
          const SizedBox(height: 20),

          //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Under Sign Up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account?",
                style: TextStyle(fontSize: width * 0.04, color: Colors.black54),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false);
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: width * 0.04,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
