import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  final String labelText;

  const CustomLabel({Key? key, required this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          labelText,
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFF2F55D4),
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
