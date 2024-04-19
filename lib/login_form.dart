import 'package:app_saude/field_form.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          FieldForm(
            label: 'Email',
            isPassword: false,
            controller: controllerEmail,
          ),
          SizedBox(
            height: 10,
          ),
          FieldForm(
            label: 'Senha',
            isPassword: true,
            controller: controllerPassword,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(color: Colors.blueGrey),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 80,
              width: 350,
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(62, 124, 120, 1.0)))),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
