import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;

  MyTextField({this.hint,this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (value) => value!.isEmpty ? "Field cannot be empty." : null,
      ),
      
    );
  }
}
