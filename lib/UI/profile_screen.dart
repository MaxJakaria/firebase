import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Models/chat_user.dart';
import 'package:firebase/UI/homepage.dart';
import 'package:firebase/UI/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class profileScreen extends StatefulWidget {
  final ChatUser user;

  const profileScreen({super.key, required this.user});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //________________________________________________________________________ For unfocus
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02,
            ),

            //_____________________________________________________________________Column with scroll view
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  //_________________________________________________________Stack for Profile picture
                  Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * 0.1),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.height * 0.2,
                        height: MediaQuery.of(context).size.height * 0.2,
                        imageUrl: widget.user.image,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),

                    //___________________________________________________Material Button
                    Positioned(
                      bottom: 4,
                      right: 0,
                      child: MaterialButton(
                        onPressed: () {},
                        elevation: 0.01,
                        shape: CircleBorder(),
                        color: Colors.transparent,
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                 //__________________________________________________________________Show email
                  Text(
                    widget.user.email,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),

                  //___________________________________________________________________Name textField
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => widget.user.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.drive_file_rename_outline,
                        color: Colors.blueAccent,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'eg. Abdullah',
                      label: Text('Name'),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  //____________________________________________________________________About textField

                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => widget.user.about = val ?? '',
                    validator: (val) =>
                    val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.description_outlined,
                        color: Colors.blueAccent,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'eg. Feeling Happy !',
                      label: Text('About'),
                    ),
                  ),


                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                  //_____________________________________________________________________________________Update button
                  UIhelper.customButton(() async {
                    final width = MediaQuery.of(context).size.width;
                    if(_formKey.currentState !.validate()){
                      _formKey.currentState!.save();
                      await FirebaseFirestore.instance.collection('user').doc(widget.user.email).update({
                        'name' : widget.user.name,
                        'about': widget.user.about,
                      });
                      UIhelper.customAlertBox(context, 'Update successful...');
                      print(FirebaseAuth.instance.currentUser!.email.toString());

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
}
