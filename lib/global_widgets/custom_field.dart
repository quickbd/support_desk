import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final bool obscureText;

  const CustomField({
    Key? key,
    required this.title,
    this.controller,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
