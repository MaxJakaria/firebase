import 'package:firebase/Models/chat_user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UIhelper {
  static customTextField(TextEditingController controller, String text,
      IconData iconData, bool toHide, BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        style: GoogleFonts.acme(
          fontSize: width * 0.045,
          color: Colors.black87,
        ),
        controller: controller,
        obscureText: toHide,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: GoogleFonts.aBeeZee(),
          prefixIcon: Icon(iconData),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
        ),
      ),
    );
  }

  static customButton(VoidCallback voidCallback, String text, Color buttonColor,
      BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        child: ElevatedButton(
          onPressed: () {
            voidCallback();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: width * 0.05, color: Colors.white),
          ),
        ),
      ),
    );
  }

  static customAlertBox(BuildContext context, String text) {
    final width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.black54,
          title: Text(
            text,
            style:
                GoogleFonts.acme(color: Colors.white, fontSize: width * 0.05),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Ok',
                style: TextStyle(fontSize: width * 0.04, color: Colors.green),
              ),
            )
          ],
        );
      },
    );
  }

  static textField(IconData iconData, String text, String levelText,
      String hintText, BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return TextFormField(
      style: TextStyle(
        fontSize: width * 0.04,
        color: Colors.black,
        // fontStyle: FontStyle.italic,
      ),
      initialValue: text,
      decoration: InputDecoration(
        prefixIcon: Icon(
          iconData,
          color: Colors.blueAccent,
        ),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.amber),
            borderRadius: BorderRadius.circular(12)),
        hintText: hintText,
        label: Text(levelText),
      ),
    );
  }

  static String getChatId(String user1, String user2) =>
      user1.hashCode <= user2.hashCode ? '$user1-$user2' : '$user2-$user1';


}


//_____________________________________________________________MyDateUtil
class MyDateUtil{
  //Date-time format
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final int i = int.tryParse(time) ?? -1;

    DateTime data = DateTime.fromMillisecondsSinceEpoch(i);

    String formattedTime = TimeOfDay.fromDateTime(data).format(context);
      return '$formattedTime';
  }

  //Get last message time (Used in chat_card)
  static String getLastMessageTime({
    required BuildContext context, required String time
}){
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if(now.day == sent.day && now.month == sent.month && now.year == sent.year){
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return '${sent.day} ${_getMonth(sent)}';
  }

  //Get month name from month
  static String _getMonth(DateTime date){
    switch (date.month){
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dic';
    }
    return 'NA';
  }

  static String getLastActiveTime({required BuildContext context, required String lastActive}){
    final int i = int.tryParse(lastActive) ?? -1;

    //If time is not available then return below statement
    if(i == -1) return 'Last seen is not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if(time.day == now.day && time.month == now.month && time.year == now.year){
      return 'Last seen today at $formattedTime';
    }

    if((now.difference(time).inHours /24).round() == 1){
      return 'Last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);
    return 'Last seen on ${time.day} $month on $formattedTime';
  }
}

class API{
  //For storing self information
  static late ChatUser me;

  //For accessing firebase messaging (Push Notification)
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;

  //For getting firebase messaging token
  static Future<void> getFirebaseMessageingToken() async {

    await fmessaging.requestPermission();
    await fmessaging.getToken().then((t){
      if(t != null){

      }
    });

  }
}
