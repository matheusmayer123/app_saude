// ignore_for_file: prefer_const_constructors

import 'package:app_saude/register_form.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App Saúde',
          style: TextStyle(
              color: Color.fromRGBO(67, 136, 131, 1.0),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          children: [
            SizedBox(),
            CircleAvatar(
              radius: 100,
              backgroundColor: Color(0xFFFFFFFF),
              backgroundImage: AssetImage('assets/images/img_form.png'),
            ),
            RegisterForm(),
          ],
        ),
      ),
    );
  }
}
