import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase/Models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({
    super.key,
    required this.user,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Column(
          children: [

            Expanded(
              child: StreamBuilder(
                // stream: FirebaseFirestore.instance.collection('user').snapshots(),
                stream: null,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      // return const Center(
                      //   child: CircularProgressIndicator(),
                      // );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      // final data = snapshot.data?.docs;
                      // list =
                      //     data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                      //         [];
              
                      final list = [];
              
                      if (list.isNotEmpty) {
                        return ListView.builder(
                          itemCount:
                           list.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index){
                            return Text('Message: ${list[index]}');
                          },
                        );
                      } else {
                        return Center(
                            child: Text(
                                 'Offer Salam !',
                              style: GoogleFonts.acme(fontSize: MediaQuery.of(context).size.width * 0.05, color: Colors.black54),
                            ),
                        );

                      }
                  }
                },
              ),
            ),

            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: mq.height * 0.05),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * 0.3),
              child: CachedNetworkImage(
                width: mq.height * 0.05,
                height: mq.height * 0.05,
                imageUrl: widget.user.image,
                fit: BoxFit.cover,
                // placeholder: (context, url)=> CircularProgressIndicator(),
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: GoogleFonts.adamina(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text('Last seen available')
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _chatInput() {
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * 0.01, horizontal: mq.width * 0.01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(mq.width * 0.05)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.speaker_notes_outlined,
                      color: Colors.black54,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a massage...',
                          hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {},
            child: Padding(
              padding: EdgeInsets.only(top: 10, right: 5, left: 10, bottom: 8),
              child: Icon(
                Icons.send,
                color: Colors.blueAccent,
              ),
            ),
            shape: CircleBorder(),
            minWidth: 0,
            color: Colors.white70,
          )
        ],
      ),
    );
  }
}
