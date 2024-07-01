import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Models/chat_user.dart';
import 'package:firebase/Models/message.dart';
import 'package:firebase/UI/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  final ChatUser user;

  const MessageCard({super.key, required this.message, required this.user});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser!.email != widget.message.told
        ? _myMessage(context)
        : _yourMessage(context);
  }

  String getChatId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode ? '$user1-$user2' : '$user2-$user1';
  }

  //---------------------------------------------------------------->>>>>>>>>>>> Your Message
  Widget _yourMessage(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    //Update last message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      FirebaseFirestore.instance
          .collection(
              'chats/${getChatId(widget.user.email, FirebaseAuth.instance.currentUser!.email!)}/messages/')
          .doc(widget.message.sent)
          .update(
        {
          'read': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );
    }

    // Parse the sent time
    DateTime sentTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(widget.message.sent));

    // Format the time
    // String formattedTime = DateFormat('HH:mm a').format(sentTime);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.text
                ? mq.width * 0.025
                : mq.width * 0.02),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(223, 202, 232, 206),
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(mq.width * 0.1),
                  topRight: Radius.circular(mq.width * 0.1),
                  bottomRight: Radius.circular(mq.width * 0.1)),
            ),

            //__________________________________________________________________ Text

            child: widget.message.type == Type.text
                ?
                //Show Text
                Text(
                    widget.message.msg,
                    style: GoogleFonts.acme(fontSize: mq.width * 0.04),
                  )
                :
                //Show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * 0.04),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),

        //______________________________________________________________________ Send Time

        Padding(
          padding:
              EdgeInsets.only(right: mq.width * 0.04, top: mq.width * 0.04),
          child: Text(
            // formattedTime,
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: GoogleFonts.adamina(
                fontSize: mq.width * 0.03, color: Colors.black45),
          ),
        )
      ],
    );
  }

  //-------------------------------------------------------------->>>>>>>>>>>>>> MY Message
  Widget _myMessage(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    // Parse the sent time
    DateTime sentTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(widget.message.sent));

    // Format the time
    // String formattedTime = DateFormat('HH:mm a').format(sentTime);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            //For Adding some space
            SizedBox(width: mq.width * 0.04),

            //__________________________________________________________________Read Time

            Padding(
              padding: EdgeInsets.only(top: mq.width * 0.04),
              child: Text(
                // formattedTime,
                MyDateUtil.getFormattedTime(
                    context: context, time: widget.message.sent),
                style: GoogleFonts.adamina(
                    fontSize: mq.width * 0.03, color: Colors.black45),
              ),
            ),

            //For Adding some space
            SizedBox(width: mq.width * 0.01),

            //__________________________________________________________________Double tik button icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blueAccent,
              ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.text
                ? mq.width * 0.025
                : mq.width * 0.02),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(210, 228, 245, 1.0),
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(mq.width * 0.1),
                  topRight: Radius.circular(mq.width * 0.1),
                  bottomLeft: Radius.circular(mq.width * 0.1)),
            ),

            //__________________________________________________________________ Text
            child: widget.message.type == Type.text
                ?
                //Show Text
                Text(
                    widget.message.msg,
                    style: GoogleFonts.acme(fontSize: mq.width * 0.04),
                  )
                :
                //Show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * 0.04),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
