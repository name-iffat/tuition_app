import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final int? maxLine;

  MyTextField({this.hint,this.controller, this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        maxLines: null,
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (value) => value!.isEmpty ? "Field cannot be empty." : null,
      ),
      
    );
  }
}
