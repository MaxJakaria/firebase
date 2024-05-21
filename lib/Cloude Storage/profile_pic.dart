import 'dart:io';

import 'package:firebase/UI/homepage.dart';
import 'package:firebase/UI/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? pickedImage;

  //____________________________________________________________________Box for pic image
  showAlertBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff2d2d30),
          title: Text(
            'Pick image from',
            style: GoogleFonts.italiana(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.camera, color: Colors.blueAccent,),
                title:  Text('Camera',style: GoogleFonts.acme(color: Colors.white, fontSize: MediaQuery.of(context).size.width *0.04),),
              ),
              ListTile(
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: const Icon(Icons.image_outlined, color: Colors.blueAccent,),
                title: Text('Gallery',style: GoogleFonts.acme(color: Colors.white, fontSize: MediaQuery.of(context).size.width *0.04),),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //____________________________________________________ Background Image
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/b1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //________________________________________________________________ Image Box
              InkWell(
                onTap: () {
                  showAlertBox();
                },
                child: pickedImage != null
                    ? CircleAvatar(
                        radius: 140,
                        backgroundImage: FileImage(pickedImage!),
                      )
                    : const CircleAvatar(
                        radius: 140,
                        child: Icon(
                          Icons.image,
                          size: 140,
                        ),
                      ),
              ),

              //________________________________________________________________ Next Button
              UIhelper.customButton(() {
                uploadImageToFirebase();
              }, 'Next', Colors.lightGreen, context)
            ],
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageSource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) return;

      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
    } catch (ex) {
      print(ex);
    }
  }

  uploadImageToFirebase() async {
    try {
      if (pickedImage == null) return;

      showDialog(
        context: context,
        builder: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      //____________________________________________________ Upload image to Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('image/${FirebaseAuth.instance.currentUser!.email}');
      UploadTask uploadTask = ref.putFile(pickedImage!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // _______________________________________________________________________ Get download URL of the uploaded image
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // _______________________________________________________________________ Add image section into Firebase Doc
      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .set({
        'image': downloadUrl,
      }, SetOptions(merge: true));

      Navigator.pop(context); // Navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ),
      );
    } catch (ex) {
      print(ex);
    }
  }
}
