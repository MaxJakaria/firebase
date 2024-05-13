import 'package:flutter/material.dart';

class UIhelper {
  static customTextField(TextEditingController controller, String text,
      IconData iconData, bool toHide, BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        style: TextStyle(
            fontSize: width * 0.04,
            color: Colors.black87,
            fontWeight: FontWeight.bold),
        controller: controller,
        obscureText: toHide,
        decoration: InputDecoration(
          labelText: text,
          prefixIcon: Icon(iconData),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
        ),
      ),
    );
  }

  static customButton(
      VoidCallback voidCallback, String text,Color buttonColor, BuildContext context) {
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
          title: Text(
            text,
            style: const TextStyle(color: Colors.blueGrey),
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

  static textField( IconData iconData,
      String text, String levelText, String hintText, BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return TextFormField(
      style: TextStyle(
        fontSize: width * 0.04,
        color: Colors.black,
        // fontStyle: FontStyle.italic,
      ),
      initialValue: text,
      decoration: InputDecoration(
        prefixIcon: Icon(iconData, color: Colors.blueAccent,),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.amber),
            borderRadius: BorderRadius.circular(12)),
        hintText: hintText,
        label: Text(levelText),
      ),
    );
  }
}
