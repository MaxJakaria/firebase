import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Models/chat_card.dart';
import 'package:firebase/Models/chat_user.dart';
import 'package:firebase/UI/login_page.dart';
import 'package:firebase/UI/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  TextEditingController searchController = TextEditingController();
  bool _isSearching = false;
  List<ChatUser> list = [];
  final List<ChatUser> _searchList = [];


  //_____________________________________________For online offline
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    updateActiveStatus(true); // Set user status to "online" when the app is resumed
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    updateActiveStatus(false); // Set user status to "offline" when the app is paused
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      updateActiveStatus(true); // Set user status to "online" in Firestore
    } else if (state == AppLifecycleState.paused) {
      updateActiveStatus(false); // Set user status to "offline" in Firestore
    }
  }


  void updateActiveStatus(bool isOnline) {
    String onlineStatus = isOnline ? 'true' : 'false'; // Convert bool to string 'true' or 'false'
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
      'is_online': onlineStatus,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
    }).then((value) {
      print('User online status updated: $isOnline');
    }).catchError((error) {
      print('Error updating user online status: $error');
    });
  }











  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    //______________________________________________Gesture Detector
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      //___________________________________________________________________________ Color
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xffFFFEFD),
                const Color(0xffFFE6B2),
                const Color(0xffC5FFBD),
                Colors.teal.shade200
              ],
              stops: const [
                0.1,
                0.45,
                0.65,
                1
              ]),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white30,
            //____________________________________________________________________ Search Text field and Conditions
            title: _isSearching
                ? Padding(
              padding: EdgeInsets.only(left: mq.width * 0.04),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'eg. name, email',
                ),
                autofocus: true,
                style: TextStyle(
                    fontSize: mq.width * 0.045,
                    letterSpacing: mq.width * 0.0025),

                //When search changes then update search list
                onChanged: (val) {
                  //______________________________________________________Search Logic
                  _searchList.clear();
                  for (var i in list) {
                    if (i.name
                        .toLowerCase()
                        .contains(val.toLowerCase()) ||
                        i.email
                            .toLowerCase()
                            .contains(val.toLowerCase())) {
                      _searchList.add(i);
                    }
                    setState(() {
                      _searchList;
                    });
                  }
                },
              ),
            )
                : Text(
              'Chat',
              style: GoogleFonts.acme(),
            ),
            actions: [
              //________________________________________________________________________Search button
              IconButton(
                onPressed: () {
                  setState(
                        () {
                      _isSearching = !_isSearching;
                    },
                  );
                },
                icon: Icon(
                    _isSearching ? CupertinoIcons.clear_circled : Icons.search),
              ),
              //_______________________________________________________________________________________PopupMenu button
              PopupMenuButton<String>(
                color: Colors.blueGrey[100],
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(mq.width * 1.0),
                        topLeft: Radius.circular(mq.width * 1.0),
                        bottomRight: Radius.circular(mq.width * 5.0))),
                onSelected: (String result) async {
                  if (result == 'profile') {
                    //_________________________________________________________________________ Call list Current user to profile screen

                    // Find the index of the current user in the list
                    int currentUserIndex = list.indexWhere((user) =>
                    user.email == FirebaseAuth.instance.currentUser!.email);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              profileScreen(user: list[currentUserIndex])),
                    );
                  } else if (result == 'logout') {
                    showDialog(
                      context: context,
                      builder: (_) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    await FirebaseFirestore.instance
                        .collection('user')
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .update({
                      'is_online': 'false',
                      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
                    });

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
          ),

          //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BODY
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
                  list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (list.length > 1) {
                    return ListView.builder(
                      itemCount:
                      _isSearching ? _searchList.length : list.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final user =
                        _isSearching ? _searchList[index] : list[index];
                        if (user.email ==
                            FirebaseAuth.instance.currentUser!.email) {

                          // Skip displaying the current user's profile card
                          return const SizedBox.shrink();
                        } else {
                          return ChatCard(user: user);
                        }
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
            },
          ),
        ),
      ),
    );
  }
}