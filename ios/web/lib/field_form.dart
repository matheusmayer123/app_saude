import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FieldForm extends StatelessWidget {
  String label;
  bool isPassword;
  TextEditingController controller;

  FieldForm({
    super.key,
    required this.label,
    required this.isPassword,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          labelStyle: const TextStyle(
            color: Color.fromRGBO(67, 136, 131, 1.0),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromRGBO(67, 136, 131, 1.0),
              width: 2,
            ),
          ),
        ));
  }
}
