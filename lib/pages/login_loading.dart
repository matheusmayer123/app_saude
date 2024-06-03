// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LoginLoading extends StatefulWidget {
  const LoginLoading({super.key});

  @override
  State<LoginLoading> createState() => _LoginLoadingState();
}

class _LoginLoadingState extends State<LoginLoading> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(67, 136, 131, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Icon(Icons.medical_services, size: 100, color: Colors.white),
            Text('Carregando...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                )),
          ],
        ),
      ),
    );
  }
}
