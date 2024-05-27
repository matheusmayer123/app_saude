import 'package:flutter/material.dart';

import 'loginpage.dart';

class ConfirmarEmailContaNova extends StatefulWidget {
  const ConfirmarEmailContaNova({super.key});

  @override
  State<ConfirmarEmailContaNova> createState() =>
      _ConfirmarEmailContaNovaState();
}

class _ConfirmarEmailContaNovaState extends State<ConfirmarEmailContaNova> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Confirme seu email',
              style: TextStyle(
                color: Color.fromRGBO(67, 136, 131, 1.0),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Enviamos um email para você, por favor, confirme seu email',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(67, 136, 131, 1.0)),
              ),
              child: const Text(
                'Voltar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
