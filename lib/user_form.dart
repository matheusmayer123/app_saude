import 'package:flutter/material.dart';
import 'package:app_saude/field_form.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          FieldForm(
            label: 'Nome',
            isPassword: false,
            controller: controllerName,
          ),
          const SizedBox(
            height: 10,
          ),
          FieldForm(
            label: 'Email',
            isPassword: false,
            controller: controllerEmail,
          ),
          const SizedBox(
            height: 10,
          ),
          FieldForm(
            label: 'Senha',
            isPassword: true,
            controller: controllerPassword,
          ),
          const SizedBox(
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
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(62, 124, 120, 1.0))),
                    child: const Text(
                      'Salvar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )),
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ainda não possui uma conta?'),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Cadastre-se',
                      style: TextStyle(color: Colors.blueGrey),
                    )),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
