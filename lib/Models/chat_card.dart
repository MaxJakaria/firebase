import 'package:cached_network_image/cached_network_image.dart';
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
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {},
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: mq.width * 0.01, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0.5,
        child: ListTile(
          // user profile picture
          // leading: const CircleAvatar(child: Icon(CupertinoIcons.person),),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 0.3),
            child: CachedNetworkImage(
              width: mq.height * 0.058,
              height: mq.height * 0.058,
              imageUrl: widget.user.image,
              fit: BoxFit.cover,
              // placeholder: (context, url)=> CircularProgressIndicator(),
              errorWidget: (context, url, error) => CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          title: Text(widget.user.name),
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),

          //Green light
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
