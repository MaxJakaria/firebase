import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/chat_user.dart';

class ChatCard extends StatefulWidget {

  final ChatUser user;

  const ChatCard({super.key, required this.user});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: (){},
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: width*0.04, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0.5,
        child:  ListTile(
          leading: const CircleAvatar(child: Icon(CupertinoIcons.person),),
          title: Text(widget.user.name),
          subtitle: Text(widget.user.about, maxLines: 1,),
          trailing: const Text('12:00 am'),
        ),
      ),
    );
  }
}
