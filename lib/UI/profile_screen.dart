import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Models/chat_user.dart';
import 'package:firebase/UI/homepage.dart';
import 'package:firebase/UI/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class profileScreen extends StatefulWidget {
  final ChatUser user;

  const profileScreen({super.key, required this.user});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return GestureDetector(
      //________________________________________________________________________ For unfocus
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> AppBar
        appBar: AppBar(
          // leading: Icon(Icons.home),
          title: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()));
            },
            icon: const Icon(Icons.home),
          ),
        ),

        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BODY
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * 0.02,
            ),

            //_____________________________________________________________________Column with scroll view
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: mq.height * 0.03),

                  //____________________________________________________________ Stack for Profile picture
                  Stack(children: [
                    _image != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(mq.height * 0.1),
                            child: Image.file(
                              File(_image!),
                              width: mq.height * 0.2,
                              height: mq.height * 0.2,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(mq.height * 0.1),
                            child: CachedNetworkImage(
                              width: mq.height * 0.2,
                              height: mq.height * 0.2,
                              imageUrl: widget.user.image,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                child: Icon(CupertinoIcons.person),
                              ),
                            ),
                          ),

                    //__________________________________________________________ Image Changes Button
                    Positioned(
                      bottom: 4,
                      right: 0,
                      child: MaterialButton(
                        onPressed: () {
                          _showBottomSheet();
                        },
                        elevation: 0.01,
                        shape: const CircleBorder(),
                        color: Colors.transparent,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
                  SizedBox(height: mq.height * 0.03),

                  //__________________________________________________________________Show email
                  Text(
                    widget.user.email,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: mq.width * 0.04,
                    ),
                  ),

                  //___________________________________________________________________Name textField
                  SizedBox(height: mq.height * 0.02),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => widget.user.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.drive_file_rename_outline,
                        color: Colors.blueAccent,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'eg. Abdullah',
                      label: const Text('Name'),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.02),
                  //____________________________________________________________________About textField

                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => widget.user.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.description_outlined,
                        color: Colors.blueAccent,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'eg. Feeling Happy !',
                      label: const Text('About'),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.02),

                  //_____________________________________________________________________________________Update button
                  UIhelper.customButton(() async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await FirebaseFirestore.instance
                          .collection('user')
                          .doc(widget.user.email)
                          .update({
                        'name': widget.user.name,
                        'about': widget.user.about,
                      });
                      UIhelper.customAlertBox(context, 'Update successful...');
                    }
                  }, 'Update', Colors.lightGreen, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //____________________________________________________________________________Show bottom sheet

  void _showBottomSheet() {
    final mq = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(mq.width * 0.05),
          topRight: Radius.circular(mq.width * 0.05),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding:
              EdgeInsets.only(top: mq.width * 0.015, bottom: mq.width * 0.015),
          children: [
            // Container for upper line
            Container(
              height: 4,
              margin: EdgeInsets.symmetric(
                  vertical: mq.height * 0.015, horizontal: mq.width * 0.4),
              decoration: BoxDecoration(
                  color: Colors.blueGrey[700],
                  borderRadius: BorderRadius.circular(15)),
            ),

            Text(
              'Pic Profile Picture',
              textAlign: TextAlign.center,
              style: GoogleFonts.aladin(
                  fontSize: mq.width * .07,
                  color: Colors.white70,
                  fontWeight: FontWeight.w200),
            ),

            //Divider
            Divider(
              color: Colors.white30,
              endIndent: mq.width * 0.15,
              indent: mq.width * 0.15,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    //_____________________________________________________________________ Gallery for pic an image
                    IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });

                          updateProfilePic(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      icon: Icon(
                        Icons.photo_camera_back,
                        size: mq.width * 0.15,
                        color: Colors.green[800],
                      ),
                    ),

                    Text(
                      'Gallery',
                      style: GoogleFonts.aladin(
                          fontSize: mq.width * .05,
                          color: Colors.white70,
                          fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
                Column(
                  children: [
                    //____________________________________________________________________Camera for pick an image
                    IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        //Pick an image
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });

                          updateProfilePic(File(_image!));
                          //For hiding bottom shit
                          Navigator.pop(context);
                        }
                      },
                      icon: Icon(
                        Icons.camera_outlined,
                        size: mq.width * 0.15,
                        color: Colors.green[800],
                      ),
                    ),

                    Text(
                      'Camera',
                      style: GoogleFonts.aladin(
                          fontSize: mq.width * .05,
                          color: Colors.white70,
                          fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
  }

  //____________________________________________________________________________ Update profile image
  updateProfilePic(File file) async {
    //Getting image file extension
    final ext = file.path.split('.').last;
    print('Extension: $ext');

    //Storage file reference with path
    final ref = FirebaseStorage.instance
        .ref()
        .child('image/ProfilePic/${FirebaseAuth.instance.currentUser!.email}');

    //Uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transfer: ${p0.bytesTransferred / 1000} kb');
    });

    //Updating image in firestore database
    widget.user.image = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({'image': widget.user.image});
  }
}
