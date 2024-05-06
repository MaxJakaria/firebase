import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({super.key});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {



  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: (){},
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: _width*0.04, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0.5,
        child: ListTile(
          leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
          title: Text('Demo user'),
          subtitle: Text('Last user massage', maxLines: 1,),
          trailing: Text('12:00 am'),
        ),
      ),
    );
  }
}
