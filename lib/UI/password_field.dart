import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final IconData iconData;

  const CustomPasswordField({super.key, 
    required this.controller,
    required this.text,
    required this.iconData,
  });

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        style: GoogleFonts.acme(
          fontSize: width * 0.045,
          color: Colors.black87,
        ),
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: widget.text,
          labelStyle: GoogleFonts.aBeeZee(),
          prefixIcon: Icon(widget.iconData),
          suffixIcon: IconButton(
            icon: _obscureText
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
    );
  }
}
