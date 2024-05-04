import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UIhelper {
  static customTextField(TextEditingController controller, String text,
      IconData iconData, bool toHide, BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        style: TextStyle(fontSize: _width*0.04, color: Colors.black87, fontWeight: FontWeight.bold),
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
      VoidCallback voidCallback, String text, BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: _width * 0.4,
      child: ElevatedButton(
        onPressed: () {
          voidCallback();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: _width * 0.05, color: Colors.white),
        ),
      ),
    );
  }
}
