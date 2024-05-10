import 'dart:io';

import 'package:firebase/API/apis.dart';
import 'package:firebase/UI/homepage.dart';
import 'package:firebase/UI/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File? pickedImage;

  showAlertBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick image from'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  pickImage(ImageSource.camera);
                },
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
              ),
              ListTile(
                onTap: () {
                  pickImage(ImageSource.gallery);
                },
                leading: const Icon(Icons.image_outlined),
                title: const Text('Gallery'),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                showAlertBox();
              },
              child: pickedImage != null
                  ? CircleAvatar(
                      radius: 140,
                      backgroundImage: FileImage(pickedImage!),
                    )
                  : CircleAvatar(
                      radius: 140,
                      child: Icon(
                        Icons.image,
                        size: 140,
                      ),
                    ),
            ),
            UIhelper.customButton(() {
              uploadImageToFirebase();
              APIs.creatUser();
            }, 'Next', context)
          ],
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

      // Upload image to Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('image/${FirebaseAuth.instance.currentUser!.uid}');
      UploadTask uploadTask = ref.putFile(pickedImage!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // Get download URL of the uploaded image
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Save the download URL to Firestore
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('user').doc(uid).update({
        'image': downloadUrl,
      });

      // Navigate to the next screen
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
