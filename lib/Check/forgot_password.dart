import 'package:firebase/UI/login_page.dart';
import 'package:firebase/UI/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

  static forgotNow(BuildContext context, String text) {
    final width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            text,
            style: const TextStyle(color: Colors.blueGrey),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: Text(
                'Ok',
                style: TextStyle(fontSize: width * 0.04, color: Colors.green),
              ),
            )
          ],
        );
      },
    );
  }

  forgotPassword(String email) async {
    if (email == "") {
      return UIhelper.customAlertBox(
          context, 'Enter an Email to reset password.');
    } else {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      forgotNow(context, 'We have sent link for forgot password.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          children: [
            UIhelper.customTextField(
                emailController, 'Email', Icons.email_outlined, false, context),
            const SizedBox(
              height: 20,
            ),
            UIhelper.customButton(() {
              forgotPassword(emailController.text.toString());
            }, 'Reset Password', context),
          ],
        ),
      ),
    );
  }
}
