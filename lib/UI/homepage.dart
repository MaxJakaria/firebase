import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Models/chat_card.dart';
import 'package:firebase/Models/chat_user.dart';
import 'package:firebase/UI/pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = TextEditingController();
  bool _isSearching = false;
  List<ChatUser> list = [];
  List<ChatUser> _searchList = [];

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
                Color(0xffFFFEFD),
                Color(0xffFFE6B2),
                Color(0xffC5FFBD),
                Colors.teal.shade200
              ],
              stops: [
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
                      decoration: InputDecoration(
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
                : Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.02),
                    child: Text(
                      'Chats',
                      style: GoogleFonts.acme(color: Colors.lightGreen[700]),
                    ),
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
              //____________________________________________________________________________ PopUpMenu button
              CustomPopupMenuButton(userList: list),
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

                  if (list.isNotEmpty) {
                    return ListView.builder(
                      itemCount:
                          _isSearching ? _searchList.length : list.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatCard(
                            user: _isSearching
                                ? _searchList[index]
                                : list[index]);
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
