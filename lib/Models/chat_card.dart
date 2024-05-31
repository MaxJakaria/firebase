import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Models/message.dart';
import 'package:firebase/UI/chat_screen.dart';
import 'package:firebase/UI/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_user.dart';

class ChatCard extends StatefulWidget {
  final ChatUser user;

  const ChatCard({super.key, required this.user});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  //Last message info (If null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Card(
      color: const Color(0xffDBD9BC),
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.015, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0.5,
      child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(user: widget.user),
              ),
            );
          },
          child: StreamBuilder(
            stream: getLastMessage(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              final data = snapshot.data?.docs;
              if (data != null) {
                final list =
                    data.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) {
                  _message = list[0];
                }
              }

              return ListTile(
                // user profile picture
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.3),
                  child: CachedNetworkImage(
                    width: mq.height * 0.058,
                    height: mq.height * 0.058,
                    imageUrl: widget.user.image,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),

                //User name
                title: Text(
                  widget.user.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                //Last Message
                subtitle: Row(
                  children: [
                    _message == null
                        ? Expanded(
                            child: Text(
                              widget.user.about,
                              maxLines: 1,
                            ),
                          )
                        : _message!.type == Type.image
                            ? const Row(
                                children: [
                                  Icon(Icons.image,
                                      color: Colors.blue,
                                      size: 16), // Adjust size as needed
                                  SizedBox(
                                      width:
                                          4), // Add some spacing between icon and text
                                  Text('Image'),
                                ],
                              )
                            : Expanded(
                                child: Text(
                                  _message!.msg,
                                  maxLines: 1,
                                ),
                              ),
                  ],
                ),

                //Green light
                trailing: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          )),
    );
  }

  //____________________________________________________________________________Get Last Message

  getLastMessage() {
    return FirebaseFirestore.instance
        .collection(
            'chats/${UIhelper.getChatId(widget.user.email, FirebaseAuth.instance.currentUser!.email!)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
}
