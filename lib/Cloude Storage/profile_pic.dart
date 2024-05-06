import 'dart:io';
import 'dart:math';

import 'package:firebase/UI/homepage.dart';
import 'package:firebase/UI/uihelper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {

  File? pickedImage;

  showAlertBox(){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Pick image from'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap : (){
                pickImage(ImageSource.camera);
              },
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
            ),
            ListTile(
              onTap: (){
                pickImage(ImageSource.gallery);
              },
              leading: const Icon(Icons.image_outlined),
              title: const Text('Gallery'),
            )
          ],
        ),
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.21),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                showAlertBox();
              },
              child: pickedImage!=null? CircleAvatar(
                radius: 120,
                backgroundImage: FileImage(pickedImage!),
              ): const CircleAvatar(
                radius: 120,
                child: Icon(
                  Icons.image,
                  size: 120,
                ),
              ),
            ),
            UIhelper.customButton(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(),
                ),
              );
            }, 'Next', context)
          ],
        ),
      ),
    );
  }

  pickImage(ImageSource imageSource)async{
    try{
      final photo = await ImagePicker().pickImage(source: imageSource);
      if(photo == null) return;
      
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
    }
    catch(ex){
      log(ex.toString() as num);
    }
  }
}
