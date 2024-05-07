import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshot) {

          final list = [];

          if(snapshot.hasData){
            final data = snapshot.data?.docs;
            for(var i in data!){
              log('${i.data()}');
              list.add(i.data()['name']);
            }
          }


          return ListView.builder(
            itemCount: list.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context,index){
              // return const ChatCard();
              return Text('Name: ${list[index]}');
            },
          );
        }
      ),
    );
  }
}
