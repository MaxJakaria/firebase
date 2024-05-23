import 'package:firebase/UI/login_page.dart';
import 'package:firebase/UI/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

  //_____________________________________________________________________Forgot Password operations
  static forgotNow(BuildContext context, String text) {
    final width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Text(
            text,
            style: GoogleFonts.inriaSans(color: Colors.white),
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

  //___________________________________________massage showing condition
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        //__________________________________________Background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          //________________________________________________________________________AppBar
          appBar: AppBar(
            backgroundColor: Colors.blueGrey[200],
            title: Text(
              'Forgot Password',
              style: GoogleFonts.acme(),
            ),
            centerTitle: true,
          ),
          //________________________________________________________________________Body
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UIhelper.customTextField(emailController, 'Email',
                    Icons.email_outlined, false, context),
                const SizedBox(
                  height: 20,
                ),
                UIhelper.customButton(() {
                  forgotPassword(emailController.text.toString());
                }, 'Reset Password', Colors.lightGreen, context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
