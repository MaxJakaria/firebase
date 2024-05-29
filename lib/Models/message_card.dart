import 'package:firebase/Models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({super.key, required this.message});

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

  //____________________________________________________________________________Sender of another user message
  Widget _yourMessage(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    DateTime sentTime = DateTime.parse(widget.message.sent); // Parse the sent time
    String formattedTime = DateFormat('HH:mm a').format(sentTime); // Format the time



    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * 0.04),
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
            child: Text(
              widget.message.msg,
              style: GoogleFonts.acme(fontSize: mq.width * 0.04),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.04),
          child: Text(
            formattedTime,
            style: GoogleFonts.acme(
                fontSize: mq.width * 0.04, color: Colors.black45),
          ),
        )
      ],
    );
  }

  //____________________________________________________________________________Our or user message
  Widget _myMessage(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    DateTime sentTime = DateTime.parse(widget.message.sent); // Parse the sent time
    String formattedTime = DateFormat('HH:mm a').format(sentTime); // Format the time

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            //For Adding some space
            SizedBox(width: mq.width * 0.04),

            //Double tik button icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blueAccent,
              ),

            //For Adding some space
            SizedBox(width: mq.width * 0.01),

            //__________________________________________________________________Read Time

            Text(
              formattedTime,
              style: GoogleFonts.acme(
                  fontSize: mq.width * 0.04, color: Colors.black45),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * 0.04),
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
            child: Text(
              widget.message.msg,
              style: GoogleFonts.acme(fontSize: mq.width * 0.04),
            ),
          ),
        ),
      ],
    );
  }
}
