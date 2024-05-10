import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  //For checking if user exists or not?
  static Future<bool> userExists() async {
    return (await FirebaseFirestore.instance
            .collection('user')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  //For creating a new user
  static Future<void> creatUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final user = ChatUser(
      image: auth.currentUser!.uid.toString(),
      name: auth.currentUser!.displayName.toString(),
      about: "Hey, I'm using chat app!",
      createdAt: time,
      isOnline: false,
      lastActive: time,
      id: auth.currentUser!.uid,
      email: auth.currentUser!.email.toString(),
      pushToken: '',
    );

    return await FirebaseFirestore.instance
        .collection('user')
        .doc(auth.currentUser!.uid)
        .set(user.toJson());
  }
}