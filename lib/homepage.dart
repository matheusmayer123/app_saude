import 'package:app_saude/user_form.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text(
                'Bem-vindo ao App Saúde',
                style: TextStyle(
                    color: Color.fromRGBO(67, 136, 131, 1.0),
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const CircleAvatar(
                radius: 100,
                backgroundColor: Colors.greenAccent,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const UserForm(),
          ],
        ),
      ),
    );
  }
}
