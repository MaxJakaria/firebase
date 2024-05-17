import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Models/chat_card.dart';
import 'package:firebase/Models/chat_user.dart';
import 'package:firebase/UI/login_page.dart';
import 'package:firebase/UI/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ChatUser> list = [];
  TextEditingController searchController = TextEditingController();
  // bool isTextFieldVisible = false;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {


    final mq = MediaQuery.of(context).size;


    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(

          //____________________________________________________________________ Search Text field and Conditions
          title: _isSearching ? Padding(

            padding: EdgeInsets.only(left: mq.width*0.04),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'eg. name, email',
              ),
              autofocus: true,
              style: TextStyle(fontSize: mq.width * 0.045, letterSpacing: mq.width * 0.0025),

              //When search changes then update search list
              onChanged: (val){
                //Search Logic
              },
            ),
          ) : Text('Chat'),
          actions: [
            //________________________________________________________________________Search button
            IconButton(
              onPressed: () {
                setState(
                  () {
                    // isTextFieldVisible = !isTextFieldVisible;
                    _isSearching = !_isSearching;
                  },
                );
              },
              icon: Icon(_isSearching ? CupertinoIcons.clear_circled : Icons.search),
            ),
            // Menu button
            PopupMenuButton<String>(
              onSelected: (String result) async {
                if (result == 'profile') {
                  //_________________________________________________________________________ Call list Current user to profile screen

                  // Find the index of the current user in the list
                  int currentUserIndex = list.indexWhere((user) => user.email == FirebaseAuth.instance.currentUser!.email);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => profileScreen(user: list[currentUserIndex])),
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
                        (value) => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        ),
                      );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'profile',
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                  ),
                ),
              ],
            ),
          ],
          //__________________________________________________________________________TextField in AppBar
          // bottom: isTextFieldVisible
          //     ? PreferredSize(
          //         preferredSize: const Size.fromHeight(55.0),
          //         child: Container(
          //           padding: const EdgeInsets.all(16.0),
          //           alignment: Alignment.centerRight,
          //           child: TextField(
          //             controller: searchController,
          //             decoration: const InputDecoration(
          //               hintText: 'Search...',
          //               border: InputBorder.none,
          //             ),
          //             onChanged: (value) {
          //               // Handle text field changes
          //             },
          //           ),
          //         ),
          //       )
          //     : null,

        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('user').snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                      [];

                  if (list.isNotEmpty) {
                    return ListView.builder(
                      itemCount: list.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatCard(user: list[index]);
                      },
                    );
                  } else {
                    return Center(
                        child: Text(
                      'No connections found !',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ));
                  }
              }
            }),
      ),
    );
  }
}
