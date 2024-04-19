import 'package:app_saude/login_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Saúde'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(67, 136, 131, 1.0),
              ),
              child: Text(
                'Menu de Ajuda',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('O que é o App Saúde?'),
              onTap: () {},
              textColor: Colors.lightBlue,
            ),
            ListTile(
              title: const Text('Help'),
              onTap: () {},
              textColor: Colors.lightBlue,
            ),
          ],
        ),
      ),
      body: const Center(
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            CircleAvatar(
              radius: 100,
              backgroundColor: Color(0xFFFFFFFF),
              backgroundImage: AssetImage('assets/images/img_inicial.png'),
            ),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}
