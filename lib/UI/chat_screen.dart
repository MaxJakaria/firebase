import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Models/chat_user.dart';
import 'package:firebase/Models/message.dart';
import 'package:firebase/Models/message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

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
  // For storing all messages
  final List<Message> list = [];

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(219, 230, 239, 1.0),

        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> AppBar
        appBar: AppBar(
          backgroundColor: Colors.white70,
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),

        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Body
        body: Column(
          children: [
            Expanded(
              //________________________________________________________________ StreamBuilder
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(getChatId(widget.user.email,
                        FirebaseAuth.instance.currentUser!.email!))
                    .collection('messages')
                    .orderBy('sent', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: SizedBox(),
                    );
                  }

                  final data = snapshot.data!.docs;
                  list.clear();

                  for (var doc in data) {
                    list.add(Message.fromJson(doc.data()));
                  }

                  if (list.isNotEmpty) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: list.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return MessageCard(
                            message: list[index], user: widget.user);
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Offer Salam !',
                        style: GoogleFonts.acme(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            color: Colors.black54),
                      ),
                    );
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
        child: StreamBuilder(
          stream: getUserInfo(widget.user),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            final data = snapshot.data?.docs;
            if (data != null) {
              final list =
                  data.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
            }

            return Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.3),
                  child: CachedNetworkImage(
                    width: mq.height * 0.05,
                    height: mq.height * 0.05,
                    imageUrl: widget.user.image,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: GoogleFonts.adamina(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text('last seen available')
                  ],
                )
              ],
            );
          },
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
                    icon: const Icon(
                      Icons.speaker_notes_outlined,
                      color: Colors.black54,
                    ),
                  ),
                  //____________________________________________________________TextField
                  Expanded(
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(fontWeight: FontWeight.w300)),
                    ),
                  ),

                  //____________________________________________________________Gallery
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      //Pick multiple images
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);

                      //Uploading and sending image one by one
                      for (var i in images) {
                        sendChatImage(File(i.path));
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                    ),
                  ),

                  //____________________________________________________________Camera
                  IconButton(
                    //Take picture from camera
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        sendChatImage(File(image.path));
                      }
                    },
                    icon: const Icon(
                      Icons.camera,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //____________________________________________________________________Send Button
          MaterialButton(
            onPressed: sendMessage(textController.text.trim(), Type.text),
            shape: const CircleBorder(),
            minWidth: 0,
            color: Colors.white70,
            child: const Padding(
              padding: EdgeInsets.only(top: 10, right: 5, left: 10, bottom: 8),
              child: Icon(
                Icons.send,
                color: Colors.blueAccent,
              ),
            ),
          )
        ],
      ),
    );
  }

  sendMessage(String msg, Type type) {
    if (msg.isNotEmpty) {
      final time = DateTime.now().toIso8601String();

      final message = Message(
        fromId: FirebaseAuth.instance.currentUser!.email!,
        told: widget.user.email,
        msg: msg,
        sent: time, // Store the actual DateTime
        read: '',
        type: type,
      );

      FirebaseFirestore.instance
          .collection('chats')
          .doc(getChatId(
              widget.user.email, FirebaseAuth.instance.currentUser!.email!))
          .collection('messages')
          .doc(time)
          .set(message.toJson());

      textController.clear();
    }
  }

  //____________________________________________________________________________Get chat ID
  String getChatId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode ? '$user1-$user2' : '$user2-$user1';
  }

  //____________________________________________________________________________Send chat image
  sendChatImage(File file) async {
    //Getting image file extension
    final ext = file.path.split('.').last;
    print('Extension: $ext');

    //Storage file reference with path
    final ref = FirebaseStorage.instance.ref().child(
        'image/chat_images/${getChatId(widget.user.email, FirebaseAuth.instance.currentUser!.email!)}/${DateTime.now().millisecondsSinceEpoch}');

    //Uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transfer: ${p0.bytesTransferred / 1000} kb');
    });

    //Updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(imageUrl, Type.image);
  }

  //For getting specific user info
  getUserInfo(ChatUser user) {
    FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: user.email)
        .snapshots();
  }

  //Update online or last active status of user
  updateActiveStatus(bool isOnline) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }
}
