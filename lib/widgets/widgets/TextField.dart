import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  const CustomTextField({Key? key , required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          height: 50,
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Color(0xFF2F55D4)),
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 20.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Color(0xFF2F55D4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Color(0xFF2F55D4)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
