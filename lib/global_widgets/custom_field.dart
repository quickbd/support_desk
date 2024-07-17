import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String title;
  final bool? secured;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;



  const CustomField({
    super.key,
    required this.title,
    this.secured,
    this.prefixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      keyboardType: keyboardType,
      obscureText: secured ?? false,
      decoration: InputDecoration(
          prefixIcon: prefixIcon != null ?  Icon(prefixIcon, color: Colors.black.withOpacity(0.5)): null,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(
                  color: Colors.black38
              )
          ),
          focusedBorder : OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(
                  color: Colors.blueAccent
              )
          ),
          hintText: title
      ),
    );
  }
}
