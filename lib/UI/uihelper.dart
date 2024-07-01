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

class MyDateUtil{
  //Date-time format
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final data = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(data).format(context);
  }

  //Get last message time (Used in chat_card)
  static String getLastMessageTime({
    required BuildContext context, required String time
}){
    final DateTime sent = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if(now.day == sent.day && now.month == sent.month && now.year == sent.year){
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return '${sent.day} ${_getMonth(sent)}';
  }

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
}
