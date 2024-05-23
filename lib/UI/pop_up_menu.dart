import 'package:firebase/Models/chat_user.dart';
import 'package:firebase/UI/login_page.dart';
import 'package:firebase/UI/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomPopupMenuButton extends StatefulWidget {
  final List<ChatUser> userList;

  const CustomPopupMenuButton({super.key, required this.userList});

  @override
  State<CustomPopupMenuButton> createState() => _CustomPopupMenuButtonState();
}

class _CustomPopupMenuButtonState extends State<CustomPopupMenuButton> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return PopupMenuButton<String>(
      color: Colors.blueGrey[100],
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(mq.width * 0.5),
              topLeft: Radius.circular(mq.width * 0.5),
              bottomRight: Radius.circular(mq.width * 1.0))),
      onSelected: (String result) async {
        if (result == 'profile') {
          // Find the index of the current user in the list
          int currentUserIndex = widget.userList.indexWhere(
                  (user) => user.email == FirebaseAuth.instance.currentUser!.email);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    profileScreen(user: widget.userList[currentUserIndex])),
                (route) => false,
          );
        } else if (result == 'logout') {
          showDialog(
            context: context,
            builder: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
          await FirebaseAuth.instance.signOut().then(
                (value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                    (route) => false),
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'profile',
          child: ListTile(
            leading: const Icon(
              Icons.person,
              color: Colors.blueAccent,
            ),
            title: Text(
              'Profile',
              style: GoogleFonts.acme(fontSize: mq.width * 0.04),
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.blueAccent,
            ),
            title: Text(
              'Logout',
              style: GoogleFonts.acme(fontSize: mq.width * 0.04),
            ),
          ),
        ),
      ],
    );
  }
}
