import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Check/chat_card.dart';
import 'package:firebase/Models/chat_user.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
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
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];

                if (list.isNotEmpty) {
                  return ListView.builder(
                    itemCount: list.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatCard(user: list[index]);
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
          }),
    );
  }
}
