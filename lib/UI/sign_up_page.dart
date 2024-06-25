import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Cloude%20Storage/profile_pic.dart';
import 'package:firebase/UI/login_page.dart';
import 'package:firebase/UI/password_field.dart';
import 'package:firebase/UI/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      //____________________________________________ Create user in Firebase Authentication & send verification link

      UserCredential? userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      //________________________________________________________________________ Show Alert Dialog

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor: Colors.black54,
              title: Text(
                'We have sent a verification link.',
                style: GoogleFonts.acme(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
              actions: [
                TextButton(
                  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> On Press with verification condition
                  onPressed: () {
                    try {
                      // Inside the onPressed callback of your 'Done' button
                      // Check if the email is verified asynchronously
                      FirebaseAuth.instance.currentUser!.reload().then((_) {
                        if (FirebaseAuth.instance.currentUser!.emailVerified) {
                          // Email is verified, proceed with sign-up
                          showDialog(
                            context: context,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          // Set data to Firebase Firestore
                          FirebaseFirestore.instance
                              .collection('user')
                              .doc(userCredential.user!.email)
                              .set({
                            'name': name,
                            'email': email,
                            'about': "اَلْحَمْدُ لِلَّٰهِ",
                          }).then((_) {
                            Navigator.pop(context);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePic(),
                              ),
                            );
                          }).catchError((error) {
                            // Handle error
                            print("Error: $error");
                          });
                        } else {
                          // Email is not verified yet, inform the user
                          FirebaseAuth.instance.currentUser!.delete();
                          // Remove Dialog
                          Navigator.pop(context);
                          UIhelper.customAlertBox(
                              context, 'Verification failed!');
                        }
                      });
                    } on FirebaseAuthException {
                      UIhelper.customAlertBox(context, 'Something wrong !');
                    }
                  },

                  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Text
                  child: Text(
                    'Done',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.green),
                  ),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        //___________________________________________________________________Background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          //____________________________________________________________________AppBar
          appBar: AppBar(
            backgroundColor: Colors.blueGrey[200],
            title: Text(
              'Signup Page',
              style: GoogleFonts.acme(),
            ),
            centerTitle: true,
          ),

          //____________________________________________________________________BODY
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Text Fields
                  UIhelper.customTextField(nameController, 'Name',
                      Icons.account_box_outlined, false, context),

                  UIhelper.customTextField(emailController, 'Email',
                      Icons.email_rounded, false, context),

                  CustomPasswordField(
                      controller: passwordController,
                      text: 'Password',
                      iconData: Icons.key),
                  CustomPasswordField(
                      controller: confirmPasswordController,
                      text: 'Confirm password',
                      iconData: Icons.key),
                  const SizedBox(height: 30),
                  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SIGNUP BUTTON

                  UIhelper.customButton(() {
                    SignUp(
                        nameController.text.toString(),
                        emailController.text.toString(),
                        passwordController.text.toString(),
                        confirmPasswordController.text.toString());
                  }, "Sign Up", Colors.lightGreen, context),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Under Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                            fontSize: width * 0.04, color: Colors.black54),
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
            ),
          ),
        ),
      ),
    );
  }
}
