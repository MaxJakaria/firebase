import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase/Models/chat_user.dart';
import 'package:firebase/UI/homepage.dart';
import 'package:firebase/UI/uihelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class profileScreen extends StatefulWidget {
  final ChatUser user;

  const profileScreen({super.key, required this.user});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
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
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
                
                Positioned(
                  bottom: 4,
                  right: 0,
                  child: MaterialButton(onPressed: (){},
                    elevation: 0.01,
                    shape: CircleBorder(),
                    color: Colors.transparent,
                    child: Icon(Icons.edit,color: Colors.white,),),
                )
              ]),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Text(
                widget.user.email,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              UIhelper.textField(
                Icons.drive_file_rename_outline,
                widget.user.name,
                'Name',
                'eg. Abdullah',
                context,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              UIhelper.textField(
                Icons.description,
                widget.user.about,
                'About',
                'eg. Feeling Happy !',
                context,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              UIhelper.customButton(
                  () async {}, 'Update', Colors.lightGreen, context),
            ],
          ),
        ),
      ),
    );
  }
}
