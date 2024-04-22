import 'package:app_saude/field_form.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerPasswordConfirm = TextEditingController();

  String btnPassword = '';

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
              label: 'Nome',
              isPassword: false,
              controller: controllerName,
            ),
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
            FieldForm(
              label: ' Confirmar Senha',
              isPassword: true,
              controller: controllerPasswordConfirm,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 80,
                    width: 350,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(62, 124, 120, 1.0),
                        ),
                      ),
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
